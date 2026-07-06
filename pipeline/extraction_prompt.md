# LLM Extraction Prompt

**Version:** 0.5 (single-call design; matches codebook v0.5 and concept dictionary v0.5). **Purpose:** This is the operational prompt for running an LLM coding pass against a single document. It sits alongside `codebook.md` (the codebook), `concept_dictionary.md` (the authoritative terminology reference), and `schema.json` (the structured-output constraint). It is **not** a substitute for the codebook — it references the codebook and dictionary for all conceptual content and only encodes LLM-specific operational instructions here.

------------------------------------------------------------------------

## How to use this file

This file is a template, not a finished prompt. The pipeline assembles the API request as follows:

- **System prompt:** the verbatim contents of `codebook.md`, followed by the verbatim contents of `concept_dictionary.md`, followed by the verbatim contents of this file (everything below the `### SYSTEM PROMPT BEGINS HERE ###` marker). Order matters: the codebook frames what is being measured, the dictionary defines how to recognize it on the page, the prompt operationalizes the procedure.
- **User message:** the document text (or chunked retrieval results), wrapped per the `### USER MESSAGE TEMPLATE ###` marker below.
- **Structured output:** `schema.json` as the response-format constraint (tool use or `response_format: json_schema` depending on API).

The split into system prompt vs user message matters: the codebook + dictionary + this prompt are the durable instructions and should be cacheable across documents; only the user message varies per document. Use prompt caching aggressively — these three documents together are \~50K tokens and caching cuts the per-document cost substantially. (A single-call design keeps the cacheable prefix stable across documents, which is what makes cross-document caching actually work.)

For each document, run **one API call** that produces the whole record, in this internal order:

1.  **Orient first.** Before scoring anything, read the document and produce the `orientation` object: a 3-5 sentence summary and an `evidence_index` — your notes on candidate passages (with locations) relevant to any codebook element. This is high-recall: capture anything potentially relevant; strict thresholds are applied at scoring time.
2.  **Score element by element**, drawing on the evidence index you just built plus the full document, in the codebook §5 order.
3.  **Cross-element check**, then emit the final JSON.

All three happen in the single structured-output call, in that order, before the JSON is returned. Emitting the `orientation` object first (it is the first field of the schema) makes the "take notes, then score against the notes" workflow explicit: retrieval is front-loaded once, then scoring is focused verification against those notes.

If the document exceeds the model's effective context window, use the retrieval mode described in the appendix at the end of this file.

------------------------------------------------------------------------

### SYSTEM PROMPT BEGINS HERE

You are coding a single gray-literature climate adaptation or management document against the Range Shift Science codebook provided above. Your job is to apply the codebook to this document and return a structured JSON record.

## Core requirements

1.  **Follow the codebook exactly.** The codebook above is the single source of truth for scoring rules. Where the codebook gives operational definitions, decision rules, or borderline criteria, apply them as written. Do not substitute your own intuitions about what should count.

2.  **Use the concept dictionary as the authoritative terminology reference.** The codebook's element-by-element indicator lists are compact and non-exhaustive; the concept dictionary above (organized by concept ID — C1, C2, C3, T1.1, T1.1a, etc.) is authoritative for what surface forms count as engagement with each concept.

    When scoring an element, look up the relevant dictionary entries first (the codebook's §9 mapping tells you which entries apply to which element). Apply:

    - **In-scope synonyms** — count any of these as engagement with the concept, not just the canonical phrase.
    - **In-scope periphrases** — count multi-word descriptions even when the canonical term is absent.
    - **Hyponyms** — count specific instances (e.g., MaxEnt as a species distribution model).
    - **Hypernyms with caveats** — count broader terms only under the conditions specified.
    - **Polysemy disambiguation** — when a surface form has multiple meanings (e.g., "migration," "shift," "resilience"), apply the disambiguation rule to determine whether the usage is in scope. **This is the single most important way to avoid false positives.**
    - **Excluded lookalikes** — explicitly do **not** count these even though they superficially match.

    The dictionary contains positive and negative example passages for each concept; consult them when a borderline call needs to be made.

3.  **Orient before scoring, in one call.** You receive the document in a single user message and return one JSON record. Work in this order internally: (a) produce the `orientation` object — the summary and the evidence index of candidate passages with locations; (b) score element by element in codebook §5 order, using your evidence index and the full document; (c) run the cross-element check; then (d) emit the JSON. Build the evidence index BEFORE you score — it is your notes, and scoring should draw on it rather than re-searching the document from scratch for each element. Do not skip the orientation step; it is the first field of the required output.

4.  **Verbatim quotes only.** Every quote in an `evidence.text` field must appear verbatim in the source document, including any OCR artifacts, typos, or unusual capitalization. Do not:

    - Silently correct errors in the document.
    - Paraphrase or summarize.
    - Splice non-adjacent passages with `...`.
    - Substitute synthesized descriptions for actual quotes.
    - Quote from TOC entries or section heading lists as a substitute for real evidence.
    - **Quote from the codebook or concept dictionary.** The illustrative example passages in the codebook and dictionary (the quoted `*"..."*` snippets shown to teach scoring distinctions) are NOT part of the document being scored. Never reproduce example text from your instructions in an `evidence.text` field. Evidence must come only from the document provided in the user message for THIS scoring task. If a candidate quote matches a dictionary example rather than the document, it is not valid evidence — find the actual passage in the document or lower the score.

    If you cannot find a verbatim ≤50-word passage to support a score, the score is too high — lower it. Score exactly what the evidence supports — no higher, no lower. An unverifiable high score will be rejected by the downstream check; an unjustified low score that overlooks evidence actually present in the document is an equal error. When genuinely uncertain between two adjacent scores, choose the one your quoted evidence actually supports, and record your reasoning in the `absence_note`.

5.  **Schema conformance.** Your output must be a single JSON object conforming exactly to the schema. No prose before or after the JSON. No markdown fences. No commentary. Use `null` (not omitted fields, not empty strings) where the schema permits null. Use empty arrays where the schema requires arrays but you have nothing to put in them.

6.  **Score = null vs score = 0.** Use `null` only when the document genuinely cannot be evaluated for an element (unreadable section, missing pages, language barrier). Use `0` when the element was evaluable and the topic is absent. These are different states.

7.  **No hallucination.** If you are uncertain whether a passage supports a score, do not score it; either use the lower score and write an `absence_note` explaining why, or use `null` if the relevant document section is unreadable. Hallucinated evidence is the failure mode this pipeline is designed to catch — it is better to under-score than to fabricate.

8.  **Absence notes are valuable.** For any close call (score that could have gone higher or lower), use the `absence_note` field to explain the reasoning. These notes are the most useful artifact for inter-rater reliability analysis and codebook refinement. Be specific: name the candidate evidence you considered and explain why it didn't meet the criterion for the next score up. When a polysemy disambiguation was decisive, note which dictionary rule you applied.

## When evidence appears under one element but bears on another

During element-by-element scoring, you will encounter passages that bear on multiple elements. Examples:

- A passage about **climate corridors** bears on `concepts.connectivity` (1.4), `concepts.adaptive_capacity_components.distribution` (1.3.distribution), `concepts.adaptive_capacity_components.movement` (1.3.movement), and `actions.range_shift_facilitation` (4.2).
- A passage applying a **vulnerability assessment to focal species** bears on `concepts.climate_vulnerability` (1.1) and `tools.vulnerability_models` (2.1).
- A passage about a **habitat connectivity plan used in spatial planning** bears on `tools.connectivity_models` (2.4) and `actions.priority_habitat_restoration` (4.1).

When you have scored the elements, perform the cross-element check before finalizing your JSON: review the evidence you've captured and confirm that any passage relevant to multiple elements is reflected in all of them. Adjust scores up or down if the cross-check reveals an under- or over-scored element. Only emit the final JSON after the cross-check.

## Tone and meta-commentary

Do not include meta-commentary in your output. Do not say "Based on my analysis..." or "Here is the JSON." Return only the single JSON object conforming to the schema — nothing before or after it.

### SYSTEM PROMPT ENDS HERE

------------------------------------------------------------------------

### USER MESSAGE TEMPLATE

Code the following document against the Range Shift Science codebook.

Produce one JSON record conforming to the schema. Work in this order: first build the `orientation` object (a 3-5 sentence summary — genre/jurisdiction/year, posture toward climate change, posture toward range shifts, and what analysis the document performs itself vs. references from elsewhere — and the `evidence_index` of candidate passages with locations). Then score element by element in codebook §5 order (1.1 → 1.2 → 1.3 → 1.4 → 2.1 → 2.2 → 2.3 → 2.4 → 3.1 → 3.2 → 3.3 → 3.4 → 3.5 → 3.6 → 3.7 → 4.1 → 4.2 → 4.3 → 4.4 → 4.5), drawing on your evidence index and the full document. Then perform the cross-element check and adjust any affected scores. Then emit the final JSON. (Theme 5 / Citations is not scored in the automated pass — it is deferred; do not produce it.)

Return only the JSON object. No prose before or after.

Document follows.

------------------------------------------------------------------------

{{document_text}}

### END USER MESSAGE TEMPLATE

------------------------------------------------------------------------

## Appendix: Long-document retrieval mode

When the document exceeds the model's effective context window (rule of thumb: documents over \~150,000 characters of extracted text), use chunked retrieval instead of dumping the full document into the user message. The single-call structure is unchanged; only what goes into `{{document_text}}` changes.

**Retrieval-mode input.** For each element, run a retrieval pass over the full document using the **concept dictionary's in-scope synonyms and periphrases for each concept the element engages** (not the codebook's short indicator list — the dictionary is broader and produces better recall). For each element, look up the concepts in the codebook §9 mapping, gather the in-scope synonyms from those dictionary entries, and use the union as the query set. Concatenate the top-K (K=8 by default) matching chunks per element into a per-element evidence pack. Assemble the user message with: a downsampled overview (TOC, executive summary, introduction, first paragraph of each major section, for orientation); the per-element evidence packs, labeled by element ID; and the document's TOC and section list (so the LLM can resolve page references). Note in the message that orientation is over a downsampled view.

The single call still runs the full procedure — orient (over the downsampled overview), then score element by element (against the per-element packs), then cross-element check — and emits one JSON object. The cross-element check still applies: even though evidence packs are per-element, a passage in element X's pack may bear on element Y.

A retrieval-mode coding pass is structurally different from a full-context pass and IRR results should be analyzed separately for the two modes during pilot. Don't mix retrieval-mode and full-context records in the same κ calculation. (The pipeline stamps `ingest`/`design`/etc. into `coding_meta`; add a retrieval flag so the comparison harness can separate them.)

**Recall vs. precision in retrieval.** The dictionary's broad synonym lists are designed for high recall — they will pull in passages that mention a surface form even when the underlying concept isn't engaged. The LLM must still apply the polysemy disambiguation rules at scoring time to filter false positives. Don't try to encode polysemy rules into the retrieval queries; let retrieval be permissive and let scoring be strict.

------------------------------------------------------------------------

## Appendix: Pipeline pseudocode

```         
for document in corpus:
    text = extract_text(document)
    if len(text) > LONG_DOC_THRESHOLD:
        mode = "retrieval"
        per_element_packs = {el: retrieve(text, dictionary.synonyms[el], k=8)
                             for el in CODEBOOK_ELEMENTS}
        doc_payload = assemble_retrieval_payload(downsample(text), per_element_packs)
    else:
        mode = "full_context"
        doc_payload = text

    # ONE call: orientation (summary + evidence_index) -> scoring -> cross-check.
    record_json = api_call(
        system_prompt = codebook + dictionary + extraction_prompt,  # cacheable prefix
        user_message  = user_template.format(document_text=doc_payload),
        response_format = json_schema(schema.json),
    )

    record = json.loads(record_json)
    # coding_meta (model, provider, codebook_version, ingest, design, coded_at)
    # is merged by the pipeline AFTER generation; retrieval mode adds a flag.
    if mode == "retrieval":
        record["coding_meta"]["retrieval_mode"] = True

    # Validation pipeline (codebook §7)
    assert_schema_valid(record, schema)
    assert_cross_field_consistent(record)
    assert_quotes_verbatim(record, text)

    save(record)
```

Records that fail any assertion are returned to extraction with the specific failure flagged. After ≥3 retry failures, route to human review.