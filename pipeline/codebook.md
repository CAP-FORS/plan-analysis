# Codebook
**Version:** 0.5 (draft)  
**Status:** Pre-pilot. Not frozen.  
**Last updated:** 2026-07-01  
**Companion files:** concept_dictionary.md, schema.json, extraction_prompt.md.

> **Integration note (2026-07-01):** Reconciled from the team's v0.4 draft. Formatting restored after a Google Docs round trip (backslash-escapes and bold-wrapped headers removed). §6 reframed so the three-pass procedure is coder-type-neutral (humans: three reading passes; LLM: one structured call with orientation-index-first — same logical procedure). Theme 5 (Citations/References) is retained but deferred from the automated schema/pipeline pending team discussion (see its section note). New elements 4.4 and 4.5, and the retype of 3.1 (scored → checklist), are reflected in schema.json and the comparison harness. See integration_changelog.md for the full delta.

---

## 1. Purpose and scope
This codebook defines how to evaluate gray-literature climate adaptation and management documents (e.g., State Wildlife Action Plans) for their engagement with **range shift science**: the study of climate-driven changes in the geographic distributions of species, populations, genotypes, phenotypes, and communities.

The codebook is the **single source of truth** for the coding task. It is read by human coders during pilot and inter-rater reliability (IRR) testing, and is provided in full to the LLM as instructions during automated extraction. Any change to the codebook after the freeze date requires re-coding all documents processed under the prior version.

### Conceptual scope: what counts as range shift science
We define range shifts following Lenoir et al. (2013), extended to include changes in genotypes, phenotypes, and communities as well as presence/abundance. The field of range shift science is concerned with **contemporary, climate-driven** distributional change and forecasting, as well as conservation and land management responses to distributional change, not historical biogeography or human-mediated invasions.

The following are **in scope**:

* Latitudinal (poleward) and elevational shifts
* Depth shifts (aquatic and marine)
* Phenological shifts insofar as they affect distribution
* Range expansions, contractions, and abundance changes within range
* Shifts in genotype, phenotype, or community composition driven by climate
* Climate refugia, climate velocity, no-analog communities, climate connectivity
* Assisted migration and conservation relocations as actions in response to climate-driven shifts

The following are **out of scope**:

* Invasive species expansions unless explicitly framed as climate-driven autonomous range shifts
* Paleontological / deep-time biogeography
* Land-use-change-driven distributional shifts that are not also climate-driven

When a document discusses, e.g., invasive species spread, it counts toward our codes **only when** the document frames the spread as climate-mediated (e.g., “warming temperatures have allowed [species] to expand northward”).

---

## 2. Coding unit and structure
**Coding unit:** Each document receives one set of scores across all elements below. Evidence quotes, however, are passage-level—pointing to specific locations within the document.

**Themes (4):** Concepts, Tools, Context, and Actions.  
The “Context” theme spans both **climate context** and **management/organizational context**; these are sub-questions within Context rather than separate themes. (We tried separating them but the boundary was fuzzy—many ideas cross-cut.)

**Elements:** Each theme contains several elements. Each element is scored independently.

**Scoring scales** vary by element (rationale per element below). All scales include a 0 for “not referenced.” Scoring rules distinguish between:

* **null / “insufficient information”:** the document could not be evaluated for this element (e.g., relevant section was unreadable, OCR failed). Different from 0.
* **0 “not referenced”:** topic is absent from the document.
* **>0:** topic is referenced; magnitude reflects depth/specificity per the element’s scale.

---

## 3. Evidence requirements
For every **non-zero** score on every element:

* Provide **1–3 supporting quotes** from the document.
* Each quote must be **≤50 words** of **verbatim** text — copied exactly from the document, including any OCR artifacts, typos, or unusual capitalization. Do **not** silently correct errors. Do **not** paraphrase, splice non-adjacent passages with ..., or substitute synthesized descriptions for actual quotes. Document structure (TOC entries, section heading lists) is not a substitute for a quote; if you cannot find a verbatim passage to support a score, the score should be lower.
* Each quote must include a **location anchor** (page number if available; otherwise section heading or other locator).
* For composite scores (e.g., Vulnerability scored 3 because both exposure and adaptive capacity are referenced), include **at least one quote per sub-component** that contributed to the score.

**Why verbatim matters.** Every coded record is subject to an automated quote-verification check: each evidence text is searched (with whitespace/Unicode normalization) against the source document. Quotes that fail the check invalidate the record. This is the single most effective guard against LLM hallucination and against humans inadvertently reconstructing rather than quoting. If a passage is hard to capture verbatim in ≤50 words, capture the most distinctive ≤50-word substring and let the location anchor point to the surrounding context.

For **zero** scores:

* No quote is required.
* Optionally include a short **absence note** if the topic seemed close but was concluded absent (e.g., “document discusses range shifts extensively but never frames them in vulnerability terms”). This is most useful for elements where false negatives are likely.

**Citations.** When a non-zero score relies on the document citing an academic or non-academic source (e.g., a specific climate model paper, a vulnerability framework), capture the citation in a citations field alongside the quote. Format: as given in the document; do not normalize.

---

## 4. General decision rules
These rules apply across all elements unless the element overrides them.

1. **Generic vs. specific framing.** Many elements distinguish between “referenced generically” and “referenced specifically.” A specific reference (a) names the concept by its technical term OR (b) applies it operationally to a named species/habitat/region/model. A passing mention without operationalization is generic.

2. **Applied to the document’s subject.** Some elements distinguish between “referenced in literature review” and “applied to the document’s subject (species, habitat, region of the plan).” A tool, framework, or analysis is **applied** if **either** (a) the document performs new analysis using it, **or** (b) the document substantively incorporates prior tool-based results into management decisions for its focal subjects. Mere mention or citation without integration is **not** application. A recommendation to use the tool in the future is also **not** application (it is “referenced generally” \= 1).

* *Rationale.* Gray-literature planning documents (SWAPs, climate adaptation plans) often integrate analyses done elsewhere rather than perform their own. The “applied” criterion is about whether the tool’s results actually shape the plan’s decisions about its focal subjects, not about who ran the analysis.

3. **Mentions in references/appendices only.** A citation that appears only in a bibliography or appendix, with no in-text discussion, does **not** count as the document engaging with the concept. The document must engage with the concept in its narrative.

4. **Document-internal contradictions.** If the document is contradictory (e.g., one chapter says climate vulnerability is central, another ignores it), code based on the overall framing of the document, not the strongest single section. Flag in the absence note.

5. **Implicit vs. explicit.** Default to explicit. Score implicit engagement only when the codebook entry for the element explicitly permits it.

---

## 5. Elements
For each element below, the structure is:

* **Definition** — operational definition
* **Inclusion** — what counts
* **Exclusion** — what doesn’t
* **Scoring** — scale and value definitions
* **Indicators** — terms/concepts to look for
* **Positive examples** — hypothetical document passages and the score they’d receive
* **Borderline / decision rules** — common ambiguous cases

---

### Theme 1: Concepts
**Question:** How are scientific concepts related to climate-driven species range shifts referenced in the document?

---

#### 1.1 Climate Vulnerability
**Definition.** How the climate vulnerability of range-shifting species and ecosystems is conceptualized. “Vulnerability” in the IPCC sense decomposes into **exposure** (the magnitude/character of climate change a system faces), **sensitivity** (intrinsic susceptibility to that change), and **adaptive capacity** (ability to cope). We focus on exposure and adaptive capacity as the principal axes; sensitivity is captured implicitly where present.

**Inclusion.** Explicit use of “vulnerability,” “climate vulnerability,” “vulnerable species/habitats,” “climate exposure,” “climate sensitivity,” “adaptive capacity,” “climate velocity, “climate dissimilarity,” “disturbance factors” or “disturbance regimes” in a context that connects to range shifts or climate-driven distributional change.

**Exclusion.** Generic uses of “vulnerable” unrelated to climate (e.g., “vulnerable to poaching”). Uses of “climate vulnerability” that refer only to human/community vulnerability without an ecological dimension.

**Scoring.**  
- 0 — Vulnerability is not referenced in relation to climate-driven range shifts.  
- 1 — Vulnerability is referenced in a non-specific way (no reference to climate exposure or adaptive capacity).  
- 2 — Vulnerability is referenced with respect to climate exposure OR adaptive capacity, but not both.  
- 3 — Vulnerability is referenced with respect to climate exposure AND adaptive capacity.

**Indicators.** climate exposure, climate sensitivity, climate velocity, adaptive capacity, climate-vulnerable species, vulnerability assessment, CCVI.

**Positive examples.**  
- “Species X is vulnerable to climate change” with no further elaboration → 1.  
- “Species X faces high climate exposure as projected temperatures exceed its thermal tolerance” → 2 (exposure only).  
- “Species X faces high climate exposure but its broad dietary niche confers adaptive capacity” → 3.

**Borderline / decision rules.**  
- Climate velocity, when discussed as an exposure metric, satisfies the “exposure” criterion.  
- “Sensitivity” arguably counts toward exposure-side reasoning; treat it as supporting exposure for scoring purposes.  
- A document that lists “vulnerable species” without articulating *why* they are vulnerable scores 1, not 2.

---

#### 1.2 Adaptive Capacity (specificity)
**Definition.** The extent to which organisms’ or habitats’ potential to adapt to climate change — by persisting in place, evolving, or shifting in space — is considered. This element captures the **specificity** of how adaptive capacity is operationalized.

**Note on design.** Adaptive capacity has two related but distinct measurements: (a) **how specifically** it is operationalized (this element, adaptive_capacity_specificity), and (b) **which components** of adaptive capacity are referenced (the next element, adaptive_capacity_components). The first is a 0/1/2 score; the second is a structured checklist. Together they capture both depth and breadth.

**Scoring.**  
- 0 — Adaptive capacity is not referenced directly or indirectly.  
- 1 — Adaptive capacity is referenced in a non-specific way (no reference to specific components).  
- 2 — Adaptive capacity is referenced with reference to one or more specific components (see next element).

**Indicators.** adaptive capacity, capacity to adapt, ability to respond, resilience (in adaptive sense), evolutionary potential, dispersal ability, plasticity.

---

#### 1.3 Adaptive Capacity Components (checklist)
**Definition.** The specific biological/ecological components of adaptive capacity that the document references. This is a multi-select checklist, not a score.

**Components.** For each, mark true if the document references it in connection with climate adaptation or range shifts, false otherwise. Each true requires a supporting quote.

| Component | Definition / what to look for |
| :---- | :---- |
| demography | Population vital rates, age structure, population size, reproduction, recruitment, mortality as adaptive capacity drivers |
| distribution | Spatial distribution, range geometry — poleward, elevational, multidimensional |
| movement | Dispersal, migration, movement ecology, movement potential (landscape permeability) |
| evolutionary_potential | Genetic variation, intraspecific variation, evolutionary adaptation, local adaptation, evolvability |
| ecological_dependencies | Trophic interactions, mutualisms, dependencies on co-occurring species |
| abiotic_niche | Physiological tolerances, thermal niche, hydric niche, phenotypic plasticity |
| life_history | Life history traits (generation time, fecundity, reproductive strategy) influencing capacity to adapt |

**Borderline / decision rules.**  
- A passing mention of “dispersal” in any climate-relevant context counts as movement \= true.  
- “Genetic diversity” alone is sufficient for evolutionary_potential \= true.  
- If a component is referenced but **not** in a climate/adaptation context, do not mark it. E.g., a discussion of demography for harvest management is not relevant.  
- “Climate/adaptation context” includes **resilience-to-environmental-change framing** that names climate change as one of the stressors, even if other stressors (land use, disease) are also named. A passage about “resilience to environmental fluctuations” with no mention of climate at all does **not** qualify; a passage about “resilience to climate change and other stressors” does.

---

#### 1.4 Connectivity
**Definition.** The extent to which connectivity — including climate connectivity — is invoked to understand, manage, or support species movement and range shifts.

**Inclusion.** wildlife corridors, habitat corridors, climate corridors, climate-gradient corridors, stepping-stone parcels, adjacent patches, landscape permeability, structural/functional connectivity, hydrologic connectivity, habitat fragmentation, barriers to movement, migration route, movement route.

**Scoring.**  
- 0 — Connectivity is not referenced.  
- 1 — Connectivity is referenced in a generic way (e.g., “habitat corridors” without climate framing).  
- 2 — Connectivity is referenced in a specific climate-relevant way (e.g., “climate corridors,” “climate-gradient connectivity,” or generic connectivity explicitly framed as a supporting or limiting factor for climate-driven shifts).

**Indicators.** corridors, climate corridors, climate-gradient corridors, stepping stones, landscape permeability, climate connectivity, connectivity for range shifts, habitat fragmentation, habitat loss, movement barriers such as roads, habitat or population isolation, urbanization, land-use change. 

**Borderline / decision rules.**  
- “Corridors to support migration” — if “migration” refers to annual movement, score as generic (1). If it refers to range shifts / climate-driven movement, score as specific (2).  
- If both generic and specific framings appear, score 2.

---

### Theme 2: Tools
**Question:** How are specific tools and data resources related to vulnerability, niche, climate, and connectivity modeling referenced in the document?

For each tool category below, capture:  
- A score for the category (definitions vary by element)  
- A list of specific tools/models named (multi-select against the indicator list, plus free-text “other”)  
- Whether the tool was **applied** to the document’s focal subject(s) vs. only **mentioned/cited**.

---

#### 2.1 Vulnerability Models
**Definition.** Models that estimate the risk of extinction, decline, or persistence for a species, population, or ecosystem by analyzing how environmental stressors and individual-level threats affect persistence.

**Scoring.**  
- 0 — Vulnerability models not referenced.  
- 1 — Vulnerability models referenced generally but not applied specifically to the subject (species, habitat, ecosystem) of the plan.  
- 2 — Vulnerability models applied to the subject of the plan.

**Indicators (named tools/methods).** Climate Change Vulnerability Index (CCVI), NatureServe CCVI, Population Viability Analysis (PVA), climate-vulnerability assessments, species vulnerability assessments.

**Borderline / decision rules.**  
- A document that cites a CCVI study performed on its focal species (even if conducted by others) counts as **applied** (2).  
- A document that lists CCVI as a recommended tool to be used in the future scores 1, not 2.

---

#### 2.2 Niche Models
**Definition.** Models predicting a species’ current or potential future areas of suitable habitat and/or geographic distribution by relating known occurrence records, physiological traits, or performance to environmental conditions.

**Scoring.**  
- 0 — Niche models not referenced.  
- 1 — Niche models referenced generally but not applied specifically to the subject of the plan.  
- 2 — Niche models applied to the subject of the plan.

(Scoring revised from the draft “0 or 1 for each model in list” to match the other Tools elements. The list of specific models is captured as a separate multi-select checklist below.)

**Indicators (named tools/methods).** Species Distribution Models (SDMs), Ecological Niche Models (ENMs), MaxEnt, BIOCLIM, INHABIT, WISDM, ENMTools, GARP, Maxlike, biomod2, LANDIS PRO, Climate Change Tree Atlas.

---

#### 2.3 Climate Models
**Definition.** Use of climate models and simulations of future climate scenarios — both global/regional climate models and downscaled climate analog tools.

**Scoring.**  
- 0 — Climate models / scenarios not referenced.  
- 1 — Climate models referenced generally but not applied specifically to the subject of the plan.  
- 2 — Climate models applied (projections used to inform analysis or management of the subject).

**Indicators (named tools/methods).** Global Circulation Models (GCMs), CMIP5/CMIP6, RCPs (RCP4.5, RCP8.5), SSPs, USGS National Climate Change Viewer, Climate Toolbox, downscaled climate projections, climate analog tools, IPCC scenarios.

**Capture additionally.** Time horizon (years; e.g., “to 2050,” “to 2100”) and emission scenario (RCP/SSP) when specified.

**Borderline / decision rules.**  
- “Climate engagement” is **not** the same as “climate models.” A document may discuss climate change extensively in qualitative terms (warming, drought, snowpack loss, sea level rise) without referencing any specific climate model, GCM, downscaling product, or emission scenario. This is a legitimate 0 for this element. The document’s climate awareness is captured elsewhere (climate threats 3.5–3.7, vulnerability 1.1).  
- Reference to “climate projections” without naming a model class or scenario is 1 (referenced generally), not 2.  
- The 2025 Washington SWAP is the canonical example of a climate-aware document scoring 0 here: it engages with climate change throughout but uses no formal climate-modeling apparatus.

---

#### 2.4 Connectivity Models
**Definition.** Models that evaluate how well a landscape facilitates species range shifts toward more suitable environments. Models related to general animal movement or seasonal migrations are not within scope unless used to understand the potential for species range shifts. 

**Scoring.**  
- 0 — Connectivity models not referenced.  
- 1 — Connectivity models referenced generally but not applied specifically to the subject of the plan.  
- 2 — Connectivity models applied to the subject of the plan.

**Indicators (named tools/methods).** CircuitScape, Omniscape, Marxan, RangeShifter, Climate Linkage Mapper, least-cost path, graph-theoretic connectivity models, resistance surface models, GIS tools or products for assessing land use/land cover (e.g. SyncroSim).

**Borderline / decision rules.**  
- Documents may reference the **output** of connectivity modeling (e.g., a statewide connectivity map, “Connected Landscapes” identified by a connectivity analysis) without naming the underlying software. This still counts as application if the output is used to inform management decisions for the document’s focal subjects. The “applied” criterion is about whether modeling results shape decisions, not whether the document names the algorithm.

---

### Theme 3: Context
**Questions:**  
a. When range shift science is referenced, what is the biological unit being discussed? At what management scale?  
b. What is the organizational and sociopolitical context of the plan?  
c. What climate-related threats to species and habitats are discussed?

---

#### 3.1 Management Scale
**Definition.** Which geopolitical, administrative, or geographic scale(s) of  management are discussed in the context of range shifts. Multi-select.

**Components.** Local, site, watershed, city, county, within-state region, state, multistate, national, transnational, ecosystem, ecoregion, province, section, subsection, lake, river, district.

**Free text.** A short list of named entities (counties, watersheds, administrative flyways) discussed in range-shift contexts. Optional but valuable for downstream analysis.

---

#### 3.2 Biological Unit (score)
**Definition.** What level(s) of biological organization, e.g., community, species, population, individual, is range shift science applied to in the document?

**Scoring.**  
- 0 — No discussion of biological level in relation to range shifts.  
- 1 — One biological unit is discussed.  
- 2 — Two or more biological units are discussed.

---

#### 3.3 Biological Unit Components (checklist + free text)
**Definition.** Which level(s) of biological organization are discussed. Multi-select.

**Components.** species, population, habitat, guild, herd, community, genotype_phenotype.

**Free text.** A short list of named entities (species names, ecoregions, habitat types) discussed in range-shift contexts. Optional but valuable for downstream analysis.

---

#### 3.4 Partnerships and Funding
**Definition.** The level of partnerships and funding (financial) allocation for addressing species range shifts.

**Scoring.**  
- 0 — Funding gap explicitly noted or implied; no partnerships described for range-shift work.  
- 1 — Some funding and/or partnerships described, but limited or aspirational.  
- 2 — Strategic investment with active partnerships in implementing range-shift actions.

(Scoring revised from draft 0/1 to 0/1/2 to allow finer differentiation; the original 0/1 collapsed “no engagement” with “aspirational engagement.”)

**Indicators.** budget allocation, fund allocation, partnerships, collaborations, MOUs, joint ventures, federal-state-tribal partnerships, NGO partnerships, multi-state organization.

**Borderline / decision rules.**  
- Vague mentions of “partnerships” without naming partners or activities → 1.  
- Acknowledged funding gaps + active partnerships → 1 (mixed).

---

#### 3.5 Climate Threat: Habitat Degradation
**Definition.** Habitat degradation or loss by climate-induced threats — drought, wildfires, saltwater intrusion into freshwater systems or freshwater habitats. Habitat degradation and loss includes both physical transformations of previously suitable habitat (e.g., shoreline erosion) as well as climate-driven alterations to the biotic environment (e.g., decline of forage availability) that determine whether a location provides habitat. 

**Scoring.**  
- 0 — No discussion of habitat degradation or loss by climate-induced threats.  
- 1 — Habitat degradation or loss by climate-induced threats (drought, wildfire, saltwater intrusion, or similar) is specifically discussed.

**Indicators.** climate-induced drought, wildfires, saltwater intrusion, sea-level rise impacts on freshwater habitats, climate-driven habitat loss, flooding, inundation.

---

#### 3.6 Climate Threat: Species Vital Rates
**Definition.** Direct effects on species vital rates caused by climate-induced events, primarily wildfires and emerging pathogens.

**Scoring.**  
- 0 — No discussion of species vital rates being affected by climate-induced events.  
- 1 — How species’ vital rates are affected by climate-induced events (wildfire, pathogens, heat events) is specifically discussed.

**Indicators.** Vital rates (e.g., survival, growth, reproduction, establishment, nest success, recruitment) affected directly by climate threats including wildfire, climate-induced disease, emerging pathogens, heat-related mortality, increased salinity.

**Borderline / decision rules.**  
- The framing must be a **direct influence on vital rates** — climate-driven events causing organisms to die, reproduction or recruitment events to fail, populations to be extirpated, or die-off events to occur, etc.. Habitat degradation, ecosystem stress, and altered disturbance regimes that affect species **indirectly** are captured under 3.5 (Habitat Degradation), not here. The chain “climate → habitat impact → eventual species effect” is **not** sufficient for 3.6; the framing must be “climate event → impact on species vital rate.”  
- Generic disease emergence or pathogen discussion without explicit climate linkage does **not** count. The pathogen must be framed as climate-favored or climate-emerging.

---

#### 3.7 Climate Threat: Biotic stressors
**Definition.** Climate-driven changes in biotic conditions that present a threat. This includes invasion (climate-favored expansion of non-native species), successional change in community composition driven by warming, as well as changes in phenology due to growing season expansion which affects species’ interactions with e.g., competitors, mutualists, and food resources.

**Scoring.**  
- 0 — No discussion of climate-driven biotic stressors.  
- 1 — Climate-driven biotic stressors discussed.

**Indicators.** climate-favored invasions, range-shifting invasives, community composition change (when framed as climate-driven), novel communities, succession driven by climate, phenological mismatch, trophic asynchrony, temporal mismatch, temporal asynchrony.

**Borderline / decision rules.**  
- Discussion of invasive species or succession **without** climate framing does not count.  
- “Novel ecosystems” or “no-analog communities” framed as climate-driven count.

---

### Theme 4: Actions
**Question:** When range shift science is referenced, what management and conservation actions are proposed? What frameworks are used to inform decision-making? Are there metrics of action efficacy? Success stories?

---

#### 4.1 Priority Habitat Identification
**Definition.** Identification of priority/critical habitat for restoration and management to address range shifts, including climate-induced threats to habitat. Spatial representation (mapping, zonation) elevates the score.

**Scoring.**  
- 0 — No discussion of priority habitat restoration and management.  
- 1 — Priority habitat restoration and management discussed but not spatially represented.  
- 2 — Priority habitat restoration and management specifically discussed *with* spatial representation (maps, zonation, land acquisition, conservation easements).

**Indicators.** conservation opportunity areas (COAs), climate refugia, corridors, resilient sites, sites of concern, priority habitat, focal areas, zonation.

---

#### 4.2 Targeted Range-Shift Actions
**Definition.** Specific, targeted actions to manage species range shifts, particularly for high-priority Species of Greatest Conservation Need (SGCN). Management may seek to facilitate, prevent, or respond to range shifts. This element captures **action-side** management: what the document proposes *doing* to manage range shifts.

**Scoring.**  
- 0 — No discussion of targeted actions to manage species range shifts.  
- 1 — Targeted actions to manage species range shifts are discussed (structural facilitation, direct manipulation, or both — see decision rules).

**Indicators.** species translocation, assisted migration, assisted colonization, reintroduction (for climate adaptation, not generic recovery), captive breeding, invasive species control to facilitate native shifts, climate-corridor construction, SGCN-focused climate adaptation actions.

**Borderline / decision rules.**  
- This element captures **two categories** of facilitation, either of which can earn a 1:  
- **Structural facilitation** — actions that build/maintain conditions allowing organisms to shift on their own (climate corridors, connectivity easements, refugia protection). These also bear on 1.4 (Connectivity); score both — they are different dimensions of the same evidence (1.4 codes whether the **concept** is engaged; 4.2 codes whether **actions** are proposed).  
- **Direct manipulation** — actions that move organisms or genetic material to track climate (assisted migration, climate-driven translocations, climate-motivated reintroductions).  
- **Generic recovery framing is excluded.** A document that discusses translocation/reintroduction in pure species-recovery terms (e.g., reintroducing extirpated species to historical ranges) does **not** score here. The framing must explicitly invoke climate change, range shifts, or shifting habitat suitability as motivation.  
- A document with structural facilitation only (e.g., proposes climate corridors but no assisted migration) scores 1. Same for direct manipulation only. The scale is binary.

---

#### 4.3 Time-bound Actions and Monitoring
**Definition.** Whether conservation actions are time-bound (have clear deadlines) and include effectiveness monitoring / periodic assessment.

**Scoring.**  
- 0 — Conservation actions are described as broad plans without deadlines or monitoring.  
- 1 — Conservation actions and strategies have clear deadlines.  
- 2 — Conservation actions have clear deadlines **and** include effectiveness monitoring / periodic assessment.

**Indicators.** deadlines, time-bound strategies, periodic assessment, effectiveness monitoring, adaptive management cycles, milestones.

**Borderline / decision rules.**  
- This element evaluates time-binding at the **action level**, not the plan level. A document that mandates a 10-year plan revision cycle but specifies no deadlines for individual conservation actions scores **at most 1** (in recognition that the plan structure includes adaptive-management principles). To earn 2, the document must (a) attach deadlines or milestones to specific actions in the action tables/lists, **and** (b) specify effectiveness monitoring tied to those actions.  
- Endorsing adaptive management or effectiveness monitoring as a principle in the introduction is insufficient for 2; the principle must be operationalized at the action level.

---

#### 4.4 Evidence of efficacy (score + free text)
**Definition.** Whether evidence to support the efficacy of an action is presented. This could include references to data, literature, or demonstration projects from other systems or a reflection on monitoring data of the action itself if it has already been implemented. Distinct from plans to monitor the effectiveness of an action (included in 4.3), this element captures the extent to which actions included in plans are supported by existing evidence.

**Scoring.**

- 0 — No evidence of efficacy is referenced or detailed to support actions.  
- 1 — Rationale is outlined, but no evidence to support actions is presented.  
- 2 — Limited evidence to support actions is presented.   
- 3 — Strong evidence of efficacy is referenced or detailed to support actions. 

**Free text.** A list of projects that have previously implemented an action and a 1-3 sentence summary of the evidence it provides to support (or not support) the action. Optional but valuable for downstream analysis.

**Indicators.** 

* “data-driven,” “data-driven,” “science-backed” in reference to an action  
* a citation being associated with an action   
* “lessons learned,” “maladaptation,” “post-action evaluation,” “after-action reflection,” “impact report,” “post-mortem” (in reference to project assessment), “project takeaways,”  
* “success stories,” “case studies,” “proof of concept,” “insights gained,” “key takeaways” (related to the results of a study or prior action)  
* “efficacy testing,” “efficacy evaluation”   
* “best practices” (when presented with reference to evidence), “strategic insights”    

**Borderline / decision rules.** 

* Actions presented without justification score a 0.
* When general or vague ecological assumptions are presented as first principles to support an action, this does not count as providing evidence to support specific actions and scores a 1. 
* General references to “best practice” or “science-based strategy” without additional justification or support provide limited evidence and score a 1. 
* “Limited evidence” includes references to studies that have limited applicability rather than applied studies testing efficacy. Studies with limited applicability include ones that are conducted in experimental or unrealistic settings, studies that focus on different locations or taxa than the subject of the plan, studies that test the basic principles underlying an idea but do not directly test an action.
* “Strong evidence” includes evaluations of previously implemented actions (“case studies”) and directly applicable studies (e.g., studies conducted in field or realistic conditions, studies that focus on a relevant location and/or subject, studies that directly test the outcomes of implementing the action in question).

---

#### 4.5 Climate adaptation planning frameworks
**Definition.** Climate adaptation planning frameworks encompass the set of planning processes (systematic and consistent series of steps for developing and implementing a plan) and tools (specific object or method for deriving or applying information) used to inform resource stewardship actions under climate change. 

**Scoring.** 

- 0 — Climate adaptation planning frameworks are not referenced directly or indirectly.  
- 1 — Climate adaptation planning frameworks are referenced in a non-specific way.  
- 2 — Climate adaptation planning frameworks are referenced with reference to one or more specific processes or tools.

**Indicators.**  “adaptation menu,” “climate change scenario planning,” “climate change vulnerability assessment,” “CCVA,” “impact evaluation,” “Resist–Accept–Direct,”  “RAD,” “Resistance–Resilience–Transition,” RRT,” “Response modeling,” “Scenario-Based Decision Analysis, “SBDA,” “Structured Decision Making, “SDM”

**Borderline / decision rules.**

* Planning processes, including adaptive management, are in scope only when they are framed in the context of decision-making under current or future conditions that result from climate change. 
* **“Planning framework”** is generic — because most of these documents are plans, almost all of them will inherently reflect an implicit or explicit planning framework, but this framework may not be related to planning under climate change. In scope for T2.1 only when the planning is specifically about climate adaptation.

---

### Theme 5: Citations or References

> **Implementation status (integration note, 2026-07-01):** This theme is part of the codebook but is **deferred from the automated scoring schema/pipeline** pending team discussion. Unlike the judgment-based scored elements, Theme 5 is a per-reference extraction (bibliographic fields + a relevance flag + a times-cited count), which may be better produced by a dedicated reference-parser stage (GROBID TEI `biblStruct` parsing + post-hoc cross-referencing) than by the LLM scoring call — or by the LLM, as a validation cross-check against GROBID. This is an open architectural question to resolve with the group; a head-to-head test (LLM extraction vs. GROBID parse on the same documents) is the planned next step. Until resolved, the LLM scoring schema and prompt do **not** include Theme 5, and the element-order for automated scoring runs 1.1 → … → 4.5 (Theme 5 excluded). The codebook text below is retained as the team's specification.

**Question:** Which scientific papers and grey literature are referenced in the document?

**Definition.** Citations or references to all other literature or resources in the document.

**Scoring (free text + scores).** 

1) *Free text: reference extraction*

Extract each individual reference and all provided information (e.g., Author names, Publication Year, Publication, DOI, etc.) as free text. In-text citations should only be extracted when there is not a corresponding entry in a list of works cited (a bibliography) in the document. 

Score each reference according to the following criteria:

2) *Score: Range shift relevance*

- 0 — Reference had not been previously extracted in support of previous elements.  
- 1 — Reference had been previously extracted in support of previous elements.

3) *Score: Times cited*

The total number of in-text citations for each individual reference across the document.

---

## 6. Coding procedure
This procedure applies to **both human and LLM coders**. Following the same procedure across coder types is essential for inter-rater reliability — strategy differences can otherwise look like codebook ambiguity in the IRR analysis.

### Three-pass approach
Use a structured three-pass approach with the same **logical** steps for every coder: (1) orient to the whole document, (2) score element by element with focused attention, (3) cross-check for evidence that bears on multiple elements. The requirement is the logical sequence, not a particular number of sittings or API calls. Human coders and the LLM realize it differently (see "Realization by coder type" below), but the logic — orient before scoring, re-anchor on each element while scoring, then reconcile cross-cutting evidence — is shared, and that shared logic is what keeps human and LLM coding comparable for IRR.

**Pass 1 — Orientation (no scoring).** Read the document end-to-end. For very long documents (>50 pages), read the executive summary, table of contents, introduction, and skim each major section. The goal is to build a map: what is this document about, what is its overall posture toward climate change and range shifts, what kinds of analysis does it perform itself versus reference from elsewhere. **Do not score during this pass.** Produce a 3–5 sentence orientation summary and note candidate passages (with locations) relevant to any element — an evidence index. This orientation is the basis for scoring; capture broadly here (high recall) and apply strict thresholds during scoring.

**Pass 2 — Element-by-element scoring.** For each element in the order listed in §5 (1.1 → 1.2 → 1.3 → 1.4 → 2.1 → 2.2 → 2.3 → 2.4 → 3.1 → … → 4.5):

1. Re-anchor on the codebook entry for that element including scoring rubric, indicators, and decision rules.

2. Locate relevant passages using the element’s indicator terms and your orientation evidence index (built in Pass 1) rather than re-reading the whole document from scratch.

3. Determine the score per the rubric.

4. For any non-zero score, capture 1–3 **verbatim** supporting quotes (see §3 for the verbatim requirement; this is enforced by automated checks downstream).

5. If the score was a close call, or if the document seemed close to a higher score but didn’t quite reach it, write an absence_note explaining the reasoning. This is the single most useful artifact for IRR diagnosis.

**Pass 3 — Cross-element check.** After Pass 2, review your captured evidence. Some passages bear on multiple elements (e.g., a passage about climate corridors bears on Connectivity 1.4, Adaptive Capacity components movement and distribution 1.3, **and** Targeted Range-Shift Actions 4.2). Verify that cross-cutting passages are reflected in all relevant elements. Adjust scores if you discover an element was under-scored because evidence first surfaced under another element.

### Realization by coder type
The three logical passes above are realized differently by human and LLM coders; both are conformant as long as the logical sequence is followed.

**Human coders** work the three passes as distinct reading passes (orient across the whole document, then score element-by-element re-anchoring on each entry, then reconcile cross-cutting evidence), keeping the orientation summary and evidence index as working notes.

**LLM coder** realizes the three passes **within a single structured API call**, not as three separate calls. The model first produces an `orientation` object (the summary plus the evidence index) as the first field of its output, then scores element by element drawing on that index, then performs the cross-element check before emitting the final record. Emitting the orientation first is what makes it function as genuine orientation-before-scoring rather than a post-hoc description. A single call (rather than separate orientation and scoring calls) is used because separate calls break prompt caching and roughly double input cost at corpus scale, with no offsetting quality benefit; the single call realizes the same three-pass logic. See extraction_prompt.md and schema.json for the operational form.

### Why this procedure
Document-major reading (Pass 1) prevents tunnel vision on early evidence. Element-major scoring (Pass 2) prevents codebook drift in working memory — by the time you’ve read 100 pages you have a degraded copy of the codebook in mind, and re-anchoring on the element entry before scoring it counters that. The cross-element check (Pass 3) catches the rich-passage problem where one passage is evidence for multiple elements but was filed under only one during Pass 2.

Without this procedure, coders default to whatever strategy comes naturally, which differs across humans, across LLMs, and across runs of the same LLM. That strategy drift will inflate IRR disagreement. Holding the *logical* procedure constant across coder types — even when the realization differs (three passes for humans, one structured call for the LLM) — is what keeps human-vs-model IRR interpretable.

### Coder metadata
Record on every coded record (the schema enforces this):  
- Coder ID (initials for humans; llm:<model-name> for LLM passes).  
- Codebook version applied.  
- Timestamp of coding completion.  
- Any notes about document quality (OCR errors, missing pages, language) that affected the coding pass.

### Disagreement resolution
Disagreements during pilot/IRR are resolved by **discussion before refining the codebook**, never by ad-hoc score changes. Document the resolution. If the disagreement reveals a codebook ambiguity, draft a refinement and apply it in a new codebook version; do not silently update the codebook between coding runs.

---

## 7. LLM-specific operationalization
When the LLM is the coder, additional rules apply on top of the procedure in §6:

* The LLM receives this codebook as the primary system prompt content, plus a separate operational prompt that specifies output format, the two-pass procedure as concrete instructions, and the JSON Schema as a structured-output constraint.
* The LLM must return JSON conforming to the schema. Free-text reasoning belongs in the absence_note fields, not outside the JSON.
* For documents longer than the LLM’s effective context window, use chunked extraction with retrieval: Pass 1 summary is produced from a downsampled view (TOC + section openings); Pass 2 element-by-element scoring uses retrieval to pull relevant chunks per element’s indicator terms.

### Validation pipeline (run on every coded record)
1. **Schema validation.** Record must conform to the JSON Schema. Reject if not.

2. **Cross-field consistency.** Every non-zero score has ≥1 evidence quote. Every component.present \= true has ≥1 evidence quote. Every present \= false has an empty evidence array.

3. **Quote verification.** Each evidence.text must appear (after Unicode and whitespace normalization) as a verbatim substring of the source document. Any mismatch invalidates the record.

4. **IRR sampling.** A sample of LLM-coded documents (≥10% during pilot, ≥5% during production) is independently coded by a human and κ is computed per element. Target: κ ≥ 0.7 on each element before freeze.

Records that fail steps 1–3 are returned to extraction with the specific failure flagged. Records that pass steps 1–3 but produce IRR disagreement at step 4 surface codebook ambiguities, not extraction errors.

---

## 8. Versioning and freeze
* This document is **v0.3, pre-pilot**. v0.1 was the initial draft; v0.2 incorporated refinements identified during a stress-test coding of the Washington SWAP 2025 draft (see refinement_notes.md); v0.3 introduces the companion concept dictionary (§9).
* Pilot: independently code 5 documents (LLM + 2 humans), review disagreements, revise codebook and dictionary as needed.
* Repeat pilot on fresh 5 documents until IRR meets threshold (κ ≥ 0.7 per element).
* Once frozen, the codebook is immutable. Any change requires re-coding all documents under the new version. The dictionary may be amended independently with minor-version bumps (e.g., adding a newly-encountered synonym) without invalidating prior coding; major dictionary changes (changing a polysemy rule, removing an in-scope synonym) require a codebook minor-version bump.

---

## 9. Concept dictionary (companion file)
The element entries in §5 reference concepts using compact indicator lists (e.g., “climate exposure, climate sensitivity, climate velocity, adaptive capacity” under 1.1). These lists are intentionally short and serve as quick references. The **authoritative** definition of what surface forms count as engagement with each concept lives in the companion file concept_dictionary.md.

The dictionary handles four problems the codebook’s indicator lists cannot handle on their own:

1. **Surface synonyms.** Different terms for the same concept (e.g., “climate vulnerability” vs. “climate susceptibility” vs. “climate risk”).

2. **Hyponyms and hypernyms.** Specific instances of broader concepts (e.g., “MaxEnt” as an instance of species distribution model) and broader terms that count only with caveats.

3. **Periphrasis.** Multi-word descriptions that capture the concept without using a canonical term (e.g., “species moving northward as temperatures warm” as evidence of range shift).

4. **Polysemy.** Same surface form, different meanings (e.g., “migration” can be annual movement, range-shift, or human migration; “resilience” can be climate-adaptive capacity or generic disturbance resilience).

When the dictionary and an element entry’s indicator list disagree, **the dictionary is authoritative**. The codebook’s per-element lists are convenience only.

When coding a document, consult the relevant dictionary entries before scoring each element. The Pass 2 element-by-element procedure (§6) should incorporate dictionary lookup as a routine step. For LLM coders, the dictionary is provided alongside this codebook as part of the system prompt.

**Concept-to-element mapping.** The dictionary’s entry IDs are cross-referenced to codebook elements:

* §5.1.1 Climate Vulnerability → T1.1, T1.1a, T1.1b
* §5.1.2 Adaptive Capacity specificity → T1.2
* §5.1.3 Adaptive Capacity components → T1.3a through T1.3g
* §5.1.4 Connectivity → T1.4, T1.4a, T1.4b, T1.4c
* §5.2.1 Vulnerability Models → T2.1
* §5.2.2 Niche Models → T2.2
* §5.2.3 Climate Models → T2.3
* §5.2.4 Connectivity Models → T2.4
* §5.3.1 Management Scale → T3.1
* §5.3.2 / §5.3.3 Biological Unit → T3.3
* §5.3.4 Partnerships and Funding → T3.4, T3.4b
* §5.3.5 Climate Threat: Habitat Degradation → T3.5
* §5.3.6 Climate Threat: Species Mortality → T3.6
* §5.3.7 Climate Threat: Invasion / Succession → T3.7
* §5.4.1 Priority Habitat → T4.1
* §5.4.2 Range-Shift Facilitation → T4.2
* §5.4.3 Time-bound Actions → T4.3
* *Cross-cutting:* every element relies on C1 (climate change) and C2 (range shift); Tools elements 2.x rely on C3 (focal subject).