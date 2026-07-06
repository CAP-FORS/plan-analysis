# Concept Dictionary
**Version:** 0.5 (draft)  
**Companion to:** codebook v0.5  
**Status:** Pre-pilot. Not frozen.  
**Last updated:** 2026-07-01

> **Integration note (2026-07-01):** Reconciled from the team's v0.2 draft. Formatting restored after a Google Docs round trip. **Illustrative example passages re-sanitized:** the team draft reintroduced verbatim real-document text (specific state agencies, place names, program names, and budget figures) as positive/negative examples. Because the dictionary is in the system prompt on every scoring call, real-document example text leaks into model evidence fields and mis-attributes to unrelated documents (a corpus-wide contamination bug found in pilot). All such examples were replaced with obviously-synthetic equivalents that teach the same scoring distinction; definitional methodology vocabulary (RCP, SSP, CCVI, MaxEnt, SDM, SGCN, HGCN, and legitimate scientific citations) was preserved. **This sanitization must be re-applied to the official team copy before any full run** — see integration_changelog.md.

---

## Purpose
The concept dictionary is the single authoritative reference for what surface forms (words, phrases, periphrases) count as evidence for each underlying concept in the codebook. It exists to make coding **robust to terminological variation**: documents in your corpus use different vocabulary for the same constructs (climate vulnerability vs. climate susceptibility vs. climate risk), use specific terms when the codebook uses general ones (MaxEnt as a species distribution model), and use ambiguous terms that mean different things in different contexts (“migration” can be annual or range-shift).

This dictionary is **referenced by**, not embedded in, the codebook elements. When the codebook says “see Concept Dictionary entry for X,” consult the corresponding entry here. When this dictionary disagrees with an element’s indicator list, the dictionary wins — the element list is convenience only.

## How to use
**For coders (human or LLM).** Before scoring an element, consult the dictionary entries for the concept(s) that element engages. Apply the polysemy disambiguation rules and the excluded-lookalikes rules; without these, terminologically broad matching introduces false positives.

**For codebook revision.** When a pilot disagreement reveals a synonym or polysemy case not covered here, add it to the dictionary and bump the dictionary version. The element entries in the codebook should rarely change for terminological reasons; the dictionary absorbs those changes.

**For pipeline retrieval.** When using LLM extraction in retrieval mode (codebook §7), the per-element retrieval queries should be built from the in-scope synonyms in this dictionary rather than from the codebook’s compact indicator lists.

## Entry structure
Each entry contains:

* **Source** — reference used to inform definition
* **Canonical phrase** — the form used throughout the codebook
* **Codebook elements served** — which scoring elements use this concept
* **Definition** — one-sentence operational gloss
* **In-scope synonyms** — surface forms (single-word, multi-word, periphrasis) that count
* **Hyponyms** — more specific instances that count as the broader concept
* **Hypernyms with caveats** — broader terms that count only under specified conditions
* **Polysemy disambiguation** — same form, different meanings, and how to tell them apart (only when polysemy is real)
* **Excluded lookalikes** — phrases that resemble in-scope terms but don’t count, with reasons
* **Positive examples** — short synthetic passages illustrating in-scope usage
* **Negative examples** — short synthetic passages illustrating out-of-scope usage that could be mistaken for in-scope

Entries are numbered (C# for cross-cutting; T#.# matching the codebook element numbering where applicable). Cross-references within this file use these IDs.

---

# Cross-cutting concepts
These appear across many codebook elements rather than being owned by one.

---

## C1. Climate change
**Canonical phrase:** “climate change,” “anthropogenic climate change.”

**Codebook elements served:** essentially all elements in some way; explicitly required for non-zero scores on Concepts (1.1–1.4), Tools-when-climate-relevant (2.1, 2.3), and all Climate Threats (3.5–3.7).

**Definition.** Long-term, anthropogenically-driven changes in Earth’s climate system, including changes in mean temperature, precipitation regime, sea level, snowpack, storminess, and other climate-system variables. The codebook’s scope is **contemporary** climate change (roughly 1850–present–2100), not paleoclimate.

**In-scope synonyms.**

* “climate change,” “anthropogenic climate change,” “human-caused climate change,” “human-driven climate change”
* “global warming,” “global heating,” “global climate change”
* “climate crisis,” “climate emergency”
* “changing climate,” “a changing climate,” “shifting climate”
* “climate variability and change” (the IPCC umbrella phrase — counts as climate change unless the document explicitly separates variability from change)
* “greenhouse warming,” “greenhouse-gas-driven warming”
* “climate anomaly,” “climate dissimilarity” (when framed as ongoing/projected trend)

**In-scope periphrases.** Discussion of climate-system changes is in scope even without the phrase “climate change” if the document clearly attributes the changes to anthropogenic forcing or to long-term trends rather than short-term variability:

* “warming temperatures” (when framed as ongoing/projected trend)
* “rising temperatures,” “increasing temperatures” (same caveat)
* “altered precipitation regimes,” “changing precipitation patterns”
* “sea level rise,” “rising seas,” , “inundation”, “increased inundation frequency", “saltwater intrusion”, “salinization”
* “ocean acidification”
* “earlier snowmelt and reduced snowpack” (the canonical PNW formulation), “loss of winter,” “winter ice loss,” “sea ice loss,” “glacial retreat”
* “Intensified or altered disturbance regimes” (when attributed to climate)

**Hyponyms that count.** Specific climate-change manifestations: warming, sea-level rise, ocean acidification, ocean deoxygenation, marine heatwaves, increased drought frequency, increased wildfire frequency, glacier retreat, permafrost thaw, snowpack loss.

**Polysemy disambiguation.**

* **“Climate”** alone is ambiguous. “The climate of the Pacific Northwest is wet and mild” is descriptive climatology, not climate change. “The Pacific Northwest’s climate is becoming hotter and drier” is climate change. Decision rule: in-scope only when paired with a change verb (changing, shifting, warming, drying, becoming) or with temporal language indicating trend.
* **“Climate adaptation”** can mean (a) ecological adaptation to climate change (in scope), (b) human/community adaptation planning (in scope when the document is about ecological subjects), or (c) something else entirely in non-climate domains. Default: in scope when the document is a natural-resource or biodiversity document.
* **“Warming”** alone without temporal/spatial framing can refer to many things (a warming dish, geothermal warming). In practice, in ecological and policy documents this is almost always climate warming. Decision rule: in scope unless the context obviously excludes it.

**Excluded lookalikes.**

* **Paleoclimate change** (“during the Pleistocene, the climate shifted…”). Out of scope per codebook §1.
* **Microclimate** changes within a site (e.g., “shade trees create a cooler microclimate”). Not climate change; it’s local microclimate management.
* **Climate variability** when explicitly contrasted with climate change (e.g., “this drought is consistent with natural climate variability rather than climate change”). Out of scope unless the document is using the IPCC umbrella phrase “variability and change” or unless it refers to trends in variability.
* Cultural/social uses of “climate” (e.g., “political climate,” “the climate of distrust”). Trivially excluded.

**Positive examples.**

1. *“Anthropogenic climate change is altering ecosystems across spatial and temporal scales.”* — classic explicit framing; in scope.

2. *“As the climate changes, the interior region of the state is facing even hotter and drier summers than were historically typical.”* — periphrasis with clear trend framing; in scope.

**Negative examples.**

1. *“The temperate maritime climate of the coastal region supports old-growth forests.”* — descriptive climatology, no change framing. Out of scope.

2. *“During the Last Glacial Maximum, climate-driven range contractions left many species in southern refugia.”* — paleoclimate. Out of scope per §1.

---

## C2. Range shift (climate-driven distributional change)
**Canonical phrase:** “range shift,” “climate-driven range shift.”

**Codebook elements served:** central to 1.3 (distribution component), 1.4 (climate-relevant connectivity), 4.2 (range-shift facilitation); meta-concept for the entire codebook.

**Definition.** Contemporary change in a species’ (or population’s, genotype’s, phenotype’s, community’s) geographic distribution that is causally linked to anthropogenic climate change. Includes range expansion, contraction, latitudinal/elevational/depth shifts, and abundance redistribution within the range. See codebook §1 for the full conceptual scope.

**In-scope synonyms.**

* “range shift,” “range-shift,” “range shifts”
* “distributional shift,” “distribution shift”
* “geographic range shift,” “shift in geographic range”
* “shifting distribution,” “shifting range”
* “range expansion” / “range contraction” (when climate-driven)
* “poleward shift,” “latitudinal shift” (northward in Northern Hemisphere)
* “elevational shift,” “upslope shift,” “altitudinal shift,” “uphill movement”
* “depth shift,” “downward shift,” “bathymatric range shifts” (aquatic/marine)
* “shift in range margins,” “range margin shifts,” “range edge shifts”
* “leading edge expansion,” “trailing edge contraction”
* “climate-driven range shifts,” “climate-induced range shifts”
* “range tracking” (of climate)
* “isotherm tracking,” “climate envelope tracking” (older/technical)
* “ecosystem transformation”
* “landward migration,” “inland migration”

**In-scope periphrases.**

* “species moving northward as temperatures warm”
* “expanding into newly suitable habitat”
* “species tracking their climatic niche”
* “moving up in elevation in response to warming”
* “loss from the southern part of the range” (trailing edge)
* “colonizing newly available habitat at higher latitudes/elevations”
* “spatial shift in abundance”

**Hyponyms.** Specific directional shifts (poleward, equatorward, elevational, depth, longitudinal); edge-specific dynamics (leading edge / trailing edge); taxon-specific terminology (“treeline advance” for forests, “fish range shifts,” “bird range expansions”).

**Hypernyms with caveats.**

* **“Biogeographic change”** counts only if the document frames it as contemporary and climate-driven.
* **“Distributional change”** — same caveat.
* **“Ecosystem restructuring”** — does not count alone; counts as range-shift evidence only if the document explicitly attributes the restructuring to species’ range shifts.

**Polysemy disambiguation.**

* **“Migration”** has three meanings:
  * *Annual migration* (e.g., elk between winter and summer range, salmon between ocean and river, neotropical bird migration). **Does not count as range shift.**
  * *Range-shift migration* (e.g., “species migrating north to track climate”). **Counts.**
  * *Human migration*. **Does not count.**
  * *Decision rule:* if the text describes seasonal, round-trip, or breeding/non-breeding movement, it’s annual migration. If the text describes one-way movement tied to climate change (no return implied), it’s range-shift migration. If ambiguous, look at the surrounding two sentences for climate framing.
* **“Shift”** alone is ambiguous (e.g., “phenological shift,” “regime shift,” “shift in management focus”). Counts as range shift only when modifying or modified by terms denoting **geographic distribution** (range shift, distributional shift, latitudinal shift, etc.).
* **“Range”** can mean (a) geographic range — in scope; (b) firearms range, statistical range — trivially excluded.
* **“Expansion”** can mean range expansion (counts when climate-driven), population expansion at a site (does not count), or program/policy expansion (trivially excluded).

**Excluded lookalikes.**

* **Phenological shifts alone.** Earlier flowering, earlier breeding, etc. — these are phenological responses to climate, not range shifts. They count as range shifts only when the document explicitly connects them to spatial distributional change (e.g., trailing-edge contraction due to phenological mismatch).
* **Invasive species range expansion without climate framing.** Human-mediated invasions are out of scope per codebook §1.
* **Historical/paleontological range changes** (e.g., post-Pleistocene recolonization). Out of scope.

**Positive examples.**

1. *“Climate corridors are explicitly designed to connect habitats along a climate gradient allowing altitudinal and latitudinal range shifts.”* — explicit, climate-attributed; in scope.

2. *“Riparian corridors also function as climate corridors, allowing species to move up in elevation in response to warming temperatures.”* — periphrasis with clear climate framing; in scope.

**Negative examples.**

1. *“Salmon migrate from the ocean to their natal streams to spawn each fall.”* — annual migration. Out of scope (polysemy: migration).

2. *“Invasive Burmese pythons have expanded their range across the Everglades.”* — range expansion but human-mediated, no climate framing. Out of scope.

---

## C3. The focal subject(s) of the plan
**Canonical phrase:** “the document’s subject,” “the plan’s focal species/habitats/region.”

**Codebook elements served:** required for distinguishing “referenced” (1) from “applied” (2) in Tools elements 2.1–2.4. See codebook §4 general rule 2.

**Definition.** The species, populations, habitats, ecosystems, or geographic region(s) that the document is *about*. A document that mentions a tool in passing is doing something different from a document that applies the tool to its focal subjects.

**How to identify the focal subject(s).** In a SWAP, the focal subjects are typically the SGCN list (Species of Greatest Conservation Need), the HGCN list (Habitats of Greatest Conservation Need), and the jurisdiction (the state). In a climate adaptation plan, the focal subjects are usually stated in the document’s introduction or scope statement. In a species recovery plan, it’s the named species. In a regional assessment, it’s the region.

**When “applied to focal subject” matters.** Several Tools elements (2.1, 2.2, 2.3, 2.4) score 2 only when the tool is applied to the focal subjects rather than mentioned generically. Per the codebook §4 rule, “applied” means either (a) the document performs new analysis using the tool, or (b) the document substantively incorporates prior tool-based results into management decisions for its focal subjects.

**Polysemy disambiguation.**

* **“Subject”** in this codebook means the *focal subject of the plan*, not the grammatical subject of a sentence or a research subject in a study.

**Positive examples.**

1. *“CCVI scores were calculated for the 50 SGCN identified in this plan.”* — tool applied to focal subjects (the SGCN). Counts as 2.

2. *“The 2015 SWAP vulnerability assessments are incorporated into the 2025 SGCN selection process.”* — prior tool-based results substantively incorporated into management decisions for focal subjects. Counts as 2.

**Negative examples.**

1. *“CCVI is a widely-used framework for assessing climate vulnerability.”* — mention without application to focal subjects. Counts as 1, not 2.

2. *“Future revisions of this plan should develop species distribution models for under-studied focal species.”* — recommendation for future application, not application. Counts as 1.

---

# Theme 1 — Concepts
---

## T1.1 Climate vulnerability
**Canonical phrase:** “climate vulnerability.”

**Codebook elements served:** 1.1.

**Definition.** The susceptibility of species/populations/ecosystems to harm from climate change, conventionally decomposed (IPCC framework) into exposure, sensitivity, and adaptive capacity. See sub-entries T1.1a (exposure), T1.1b (sensitivity), and T1.2 (adaptive capacity).

**In-scope synonyms.**

* “climate vulnerability,” “climate-change vulnerability,” “vulnerability to climate change”
* “climate susceptibility,” “susceptibility to climate change”
* “climate risk” (when applied to species/ecosystems; see polysemy)
* “climate-vulnerable species/habitats”
* “vulnerable to climate change,” “at risk from climate change”

**In-scope periphrases.**

* “Species X is sensitive to projected warming and lacks the capacity to adapt”
* “Habitats X and Y face significant risk from projected climate conditions”
* “Many of our SGCN are imperiled by changing climate conditions”

**Hyponyms / sub-component framings.** When the document discusses exposure (T1.1a), sensitivity (T1.1b), or adaptive capacity (T1.2) explicitly in connection with climate, that is engagement with vulnerability. The codebook’s 1.1 scoring rubric distinguishes documents that engage *generically* (1), engage *exposure or adaptive capacity but not both* (2), and engage *both exposure and adaptive capacity* (3).

**Note on the IPCC three-axis framing.** Some documents use the IPCC AR4/AR5 three-axis decomposition (exposure + sensitivity + adaptive capacity), some use the newer AR6 risk framing (hazard + exposure + vulnerability, where vulnerability subsumes sensitivity and adaptive capacity), and some use ad-hoc framings. For scoring element 1.1, treat the AR4/AR5 three-axis usage as covering both “exposure” and “adaptive capacity” — sensitivity counts as a supporting axis under exposure-side reasoning.

**Polysemy disambiguation.**

* **“Vulnerable” alone** can mean (a) climate-vulnerable (in scope), (b) IUCN-Red-List-Vulnerable status (not the same — refers to overall extinction risk including but not limited to climate), (c) vulnerable to specific non-climate threats (poaching, habitat loss for non-climate reasons), or (d) general susceptibility. Decision rule: in scope only when the threat or stressor named (or strongly implied by context) is climate.
* **“Climate risk”** can mean (a) ecological climate vulnerability (in scope), (b) financial climate risk (out of scope unless the document is ecological), or (c) human/community climate risk (in scope when the document is about ecological subjects; out of scope when purely about human risk).
* **“Sensitivity”** has three meanings:
  * Climate sensitivity in the IPCC physical-science sense (the global-temperature response to CO2 doubling). Out of scope for element 1.1; in scope for T2.3 climate models.
  * Species/ecosystem sensitivity to climate stressors (in scope for T1.1b).
  * General “sensitivity” of a system to disturbance, statistical sensitivity, etc. Out of scope.
  * Decision rule: in scope for T1.1b when the sensitivity is of a biological/ecological subject to a climate stressor.

**Excluded lookalikes.**

* “Vulnerable to poaching” / “vulnerable to overfishing” / “vulnerable to habitat conversion” — out of scope unless the threat is also climate-related.
* “IUCN Vulnerable status” — out of scope as evidence of climate vulnerability per se; it’s a conservation status category. (May be evidence for other elements but not for 1.1.)
* “Climate risk” in financial disclosures or insurance contexts — out of scope.

**Positive examples.**

1. *“Understanding why species and ecosystems are vulnerable or potentially less resilient is a critical first step in developing effective conservation strategies. This vulnerability is based on sensitivity, exposure, and the ability to adapt.”* — explicit framework engagement; supports score 3.

2. *“Species X is highly susceptible to projected warming, with limited dispersal ability to track suitable conditions.”* — exposure (warming) plus adaptive capacity (dispersal); supports score 3.

**Negative examples.**

1. *“Species X is listed as Vulnerable by IUCN due to historical population declines.”* — IUCN status; out of scope for 1.1 unless climate is named as a driver.

2. *“Habitat X is vulnerable to ongoing residential development and road expansion.”* — non-climate vulnerability; out of scope for 1.1.

---

## T1.1a Climate exposure
**Canonical phrase:** “climate exposure,” “exposure to climate change.”

**Codebook elements served:** 1.1 (as sub-component contributing to the score).

**Definition.** The magnitude, rate, and character of climate change a species/population/ecosystem faces. Distinct from sensitivity (intrinsic susceptibility) and adaptive capacity (ability to cope).

**In-scope synonyms.**

* “climate exposure,” “exposure to climate change”
* “exposure to warming,” “exposure to drought,” “exposure to projected conditions”, “exposure to increased inundation”
* “climate velocity” (as an exposure metric — speed at which climate conditions move across the landscape)
* “climate dissimilarity” (in reference to comparisons of current/historical and future conditions)
* “rate of climate change,” “magnitude of climate change”
* “projected climate conditions” applied to a specific subject

**In-scope periphrases.** Discussion of how much/how fast climate is changing at a focal location or for a focal subject: “rapid warming in the high Cascades,” “projected 4°C increase by 2080 at this site,” “the area faces some of the steepest projected temperature increases in the region.” Discussion of altered “disturbance regimes” or “disturbance factors” that are explicitly or implicitly related to climate change.

**Polysemy disambiguation.**

* **“Exposure”** in conservation can also mean exposure to predators, exposure to disease, exposure to pollution. In scope for T1.1a only when the exposure is to climate stressors.

**Excluded lookalikes.**

* “Exposure of substrate” / “bare-soil exposure” / “sun exposure” — physical/horticultural usages, out of scope.
* “Predator exposure” — out of scope.

**Positive examples.**

1. *“Climate velocity is highest in low-relief regions, meaning species there face the greatest rate of change in suitable conditions.”* — climate velocity as exposure metric; in scope.

2. *“Some species are highly sensitive to temperature shifts or struggle with repeated exposure to habitat loss due to altered hydrological cycles, increased fire frequency, or sea level rise.”* — explicit exposure framing; in scope.

**Negative examples.**

1. *“Native bunchgrasses experience increased bare-soil exposure after wildfire.”* — physical exposure, not climate exposure; out of scope.

---

## T1.1b Climate sensitivity
**Canonical phrase:** “climate sensitivity” (in the species/ecosystem sense, not the IPCC physical-science sense).

**Codebook elements served:** 1.1 (treated as supporting exposure-side reasoning under the codebook’s 1.1 scoring rule).

**Definition.** Intrinsic susceptibility of a species/population/ecosystem to climate stressors, independent of how much climate change it faces. A species with narrow niche breadth is sensitive even in a slowly-changing or modestly-changing environment.

**In-scope synonyms.**

* “climate sensitivity,” “sensitivity to climate change”
* “thermal sensitivity,” “thermal tolerance” (when framed as climate-relevant)
* “physiological sensitivity to warming”
* “narrow thermal niche,” “narrow climatic niche” (implying sensitivity)
* “species sensitivity” (when modifying species and the stressor is climate)
* “Salt tolerance”, “salinity tolerance”

**Polysemy disambiguation.** “Climate sensitivity” in the physical-science sense (global-temperature response to forcing) is **a different concept** (model sensitivity, the robustness of outputs to uncertainty in inputs) and belongs under T2.3 (climate models) if discussed at all. In a biodiversity document this usage is rare; default to the ecological sense unless context clearly indicates otherwise.

**Positive examples.**

1. *“Cold-water species in headwater streams show high sensitivity to summer temperature increases.”* — ecological climate sensitivity; in scope.

**Negative examples.**

1. *“Equilibrium climate sensitivity in CMIP6 models ranges from 2.5 to 4.5 K.”* — physical-science climate sensitivity; out of scope for T1.1b. (Belongs under T2.3 if anywhere.)

---

## T1.2 Adaptive capacity
**Canonical phrase:** “adaptive capacity.”

**Codebook elements served:** 1.1 (as the second axis of vulnerability), 1.2 (specificity score), 1.3 (component checklist).

**Definition.** The intrinsic ability of organisms or systems to persist under climate change either by persisting in place (physiological/behavioral plasticity, evolutionary adaptation, demographic resilience), shifting in space (movement, dispersal, range shift), or adjusting in time (phenology). Distinct from exposure and sensitivity.

**In-scope synonyms.**

* “adaptive capacity,” “capacity to adapt,” “ability to adapt”
* “ability to respond” (to climate change, with that framing)
* “ecological resilience” (when framed as adaptive capacity to climate; see polysemy)
* “evolutionary capacity,” “evolutionary potential” (one component — see T1.3d)
* “plasticity,” “phenotypic plasticity” (as an adaptive-capacity mechanism)
* “dispersal ability,” “mobility” (when discussed as adaptive capacity — see T1.3c)

**In-scope periphrases.** Discussion of how species/ecosystems might persist, adjust, or move in response to climate change: “species with broad dietary niches may fare better under changing conditions,” “high genetic diversity in the focal population may buffer against climate impacts,” “the species’ wide thermal tolerance suggests resilience to projected warming.”

**Polysemy disambiguation.**

* **“Resilience”** has three relevant meanings:
  * *Adaptive capacity to climate change* (in scope for T1.2).
  * *Resilience to disturbance generally* (fire resilience, flood resilience). In scope for T1.2 only when climate change is named as one of the disturbances being resilient to.
  * *Community/human resilience* (in non-ecological documents, out of scope).
  * *Decision rule:* in scope when “resilience” is modified by or paired with climate-change framing.
* **“Adaptation”** has three meanings:
  * *Evolutionary adaptation* (the genetic process). Component T1.3d.
  * *Plastic/behavioral adaptation* (within-lifetime adjustments). Component of T1.2 broadly.
  * *Management adaptation* (changing management practices in response to climate). **Not the same as adaptive capacity of organisms**; out of scope for T1.2. Captured by other parts of the codebook (climate-related actions under Theme 4).
  * *Decision rule:* in scope when “adaptation” refers to the organism’s or ecosystem’s response, not the management response.

**Excluded lookalikes.**

* “Adaptation strategy” / “climate adaptation plan” (referring to management response) — out of scope for T1.2 (captured by Theme 4 elements).
* “Resilient to development” / “resilient to harvest” without climate framing — out of scope.

**Positive examples.**

1. *“Species with low adaptive capacity such as those with specialized habitat needs or limited dispersal ability face higher vulnerability to these changes.”* — explicit AC framing; in scope.

2. *“Genetic diversity may buffer trailing-edge populations against warming-driven decline.”* — periphrasis; in scope.

**Negative examples.**

1. *“The agency’s adaptive management framework will be applied to all plan actions.”* — management adaptation. Out of scope for T1.2.

2. *“These streams are resilient to seasonal flooding.”* — resilience to disturbance, no climate framing. Out of scope.

---

## T1.3a–g Adaptive capacity components
These are the seven components in the codebook element 1.3 checklist. Each is short — mostly synonyms + the climate-context requirement (see codebook 1.3 borderline rules).

---

### T1.3a Demography
**Definition.** Population vital rates, age structure, reproduction, mortality, density-dependent processes, viewed as drivers of (or constraints on) adaptive capacity.

**In-scope synonyms.** “demography,” “demographic,” “vital rates,” “population dynamics,” “fecundity,” “survival rates,” “reproductive output,” “age structure,” “size structure,” “population viability”, “recruitment,” “nest success,” “nest survival,” “pregnancy rates,” “seed set”, “pollination,” “establishment,” “maturation,” “growth” (when framed as climate-adaptation-relevant).

**Excluded lookalikes.** Demography mentioned for harvest management without climate framing.

**Positive example.** *“Low reproductive output combined with high adult mortality reduces this species’ demographic capacity to absorb climate-driven losses.”*

**Negative example.** *“Demographic analyses inform the annual harvest quota.”*

---

### T1.3b Distribution
**Definition.** Spatial distribution and range geometry as a dimension of adaptive capacity — particularly the capacity to shift range poleward, upslope, or to track suitable climate.

**In-scope synonyms.** “distribution,” “geographic range,” “range size,” “range shape,” “range boundaries,” “occupancy,” “distributional flexibility”; “poleward,” “elevational,” “altitudinal,” “latitudinal,” “multidimensional” shifts; treeline, depth distribution, latitudinal limits.

**Polysemy.** “Distribution” can also mean statistical distribution (out of scope) or food distribution (out of scope).

**Positive example.** *“Species with broad latitudinal ranges may have greater capacity to track suitable climate than narrowly-ranging species.”*

**Negative example.** *“The distribution of survey effort across ecoregions was uneven.”*

---

### T1.3c Movement / dispersal
**Definition.** Capacity of organisms to move across landscapes, either via active dispersal (own locomotion) or passive dispersal (wind, water, animal vectors), as a mechanism for tracking climate.

**In-scope synonyms.** “movement,” “dispersal,” “dispersal ability,” “dispersal capacity,” “mobility,” “vagility,” “active dispersal,” “passive dispersal,” “seed dispersal,” “larval dispersal,” “natal dispersal,” “movement ecology.”

**Polysemy.** “Migration” is excluded when annual; counts when range-shift (see C2). Movement for foraging within current home range is not adaptive-capacity movement.

**Positive example.** *“Limited dispersal ability constrains this species’ capacity to colonize newly suitable habitat.”*

**Negative example.** *“Daily movements between roosts and foraging areas average 3 km.”*

---

### T1.3d Evolutionary potential
**Definition.** Capacity for evolutionary adaptation to climate via standing genetic variation, mutation, recombination, or hybridization.

**In-scope synonyms.** “evolutionary potential,” “evolutionary adaptation,” “genetic variation,” “genetic diversity,” “standing variation,” “adaptive evolution,” “local adaptation,” “evolvability,” “hybridization potential.”

**Codebook note.** Per the codebook 1.3 borderline rules, “genetic diversity” alone is sufficient to mark this component true when discussed in a climate-adaptation context. Genetic diversity unrelated to climate (e.g., for forensic identification) does not count.

**Positive example.** *“Standing genetic variation in thermal tolerance may allow evolutionary adaptation to projected warming.”*

**Negative example.** *“Genetic diversity at neutral markers was assessed for population assignment.”*

---

### T1.3e Ecological dependencies
**Definition.** Trophic interactions, mutualisms, and dependencies on co-occurring species or specific habitat features that constrain or enable adaptive capacity.

**In-scope synonyms.** “ecological dependencies,” “ecological interactions,” “trophic dependencies,” “mutualisms,” “pollinator dependencies,” “host-specific,” “specialist,” “obligate associations,” “phenological mismatch” (when discussed as an adaptive-capacity constraint), “interaction strength,” “keystone species” (when discussed in relation to the adaptive capacity of an ecosystem)

**Positive example.** *“Specialist pollinators with single host plant species face elevated risk under climate change due to potential phenological decoupling.”*

**Negative example.** *“Ecological surveys documented 47 species at the site.”*

---

### T1.3f Abiotic niche
**Definition.** Physiological tolerances and abiotic requirements (thermal, hydric, salinity, oxygen, pH) that define the climatic envelope a species can persist within.

**In-scope synonyms.** “abiotic niche,” “physiological tolerance,” “thermal niche,” “thermal tolerance,” “thermal limits,” “hydric niche,” “moisture requirements,” “salinity tolerance,” “climatic envelope,” “fundamental niche,” “physiological limits,” “performance breadth”, “flood tolerance”.

**Polysemy.** “Niche” alone is ambiguous — could mean abiotic niche, ecological niche (broader, including biotic interactions — covered under T1.3e), or career niche. In scope for T1.3f when the dimensions named are abiotic.

**Positive example.** *“Species’ physiological limits are tested as shifting temperatures, altered hydrology, and changing seasonal cues affect survival, reproduction, and migration.”*

**Negative example.** *“This species occupies a specialized niche as a cavity-nesting insectivore.”* — biotic/ecological niche framing, not abiotic. (May count under T1.3e instead.)

---

### T1.3g Life history
**Definition.** Life-history traits — generation time, reproductive strategy, longevity, age at first reproduction, semelparity vs. iteroparity — that influence the speed and mode of adaptive response.

**In-scope synonyms.** “life history,” “life-history traits,” “generation time,” “longevity,” “lifespan,” “reproductive strategy,” “semelparous,” “iteroparous,” “fast/slow life history continuum,” “age at first reproduction,” “fecundity-longevity tradeoff,” “r- and k-selected,” “annual/perennial/biennial”

**Codebook note.** Some life-history traits overlap with demography (T1.3a). Default: if the framing is *trait-level* (e.g., “long-lived species with delayed reproduction”), count under T1.3g. If the framing is *rate-level* (e.g., “annual mortality rate of 0.15”), count under T1.3a.

**Positive example.** *“Long-lived, late-maturing species have less capacity to track rapid climate change through evolutionary adaptation.”*

**Negative example.** *“Life-history information was gathered via literature review.”*

---

## T1.4 Connectivity (general)
**Canonical phrase:** “connectivity,” “habitat connectivity,” “ecological connectivity.”

**Codebook elements served:** 1.4.

**Definition.** The degree to which a landscape (or seascape) facilitates ecological flows — movement of organisms, gene flow, propagule dispersal, natural processes — across space.

**In-scope synonyms.**

* “connectivity,” “ecological connectivity,” “habitat connectivity,” “landscape connectivity”
* “structural connectivity” (physical landscape arrangement)
* “functional connectivity” (organism-perceived connectivity)
* “landscape permeability”
* “network connectivity” (in landscape-ecology sense)
* “hydrological connectivity” (for context of coastal ecosystem landward migration)

**Hyponyms / related concepts.**

* Corridors (T1.4b) and refugia (T1.4c) are related concepts, each with their own entry below.
* “Climate connectivity” (T1.4a) is the climate-relevant form.

**Polysemy disambiguation.**

* **“Connectivity”** can mean: (a) ecological — in scope; (b) hydrologic (stream connectivity, fish passage) — in scope only when framed as enabling biological movement, not just water flow; (c) infrastructure/network (road connectivity, internet) — out of scope; (d) social connectivity — out of scope.

**Excluded lookalikes.**

* “Connectivity” in transportation or telecommunications context.

**Positive examples.**

1. *“The regional habitat connectivity plan maps and defines connectivity across the state.”* — explicit ecological connectivity; in scope.

**Negative examples.**

1. *“Road connectivity improvements are scheduled for the next biennium.”* — infrastructure connectivity; out of scope.

---

## T1.4a Climate connectivity
**Canonical phrase:** “climate connectivity.”

**Codebook elements served:** 1.4 (drives the score-2 distinction); 4.2 (structural facilitation).

**Definition.** Connectivity specifically designed or assessed to support species’ tracking of suitable climate conditions, typically along climate gradients (latitudinal, elevational, depth).

**In-scope synonyms.**

* “climate connectivity”
* “climate-gradient connectivity”
* “connectivity for climate adaptation”
* “climate-driven connectivity”
* Periphrasis: “connectivity that supports species shifts under climate change,” “linkages along climate gradients”

**In-scope hyponyms.** “Climate corridor” (T1.4b); a regional plan’s “climate connectivity layer”; “climate-gradient corridors” (Krosby et al. usage).

**Decision rule.** Generic connectivity discussion (T1.4) becomes climate connectivity (T1.4a) when the framing explicitly invokes climate change, range shifts, or shifting climatic conditions as the reason for the connectivity.

**Excluded lookalikes.** Connectivity for daily/seasonal movement (e.g., for ungulate winter range access) — that’s T1.4 generic, not T1.4a, unless climate is also named.

**Positive examples.**

1. *“The Cascades constitute a critical pathway for climate connectivity at a continental scale.”*

2. *“Riparian corridors also function as climate corridors, allowing species to move up in elevation in response to warming temperatures.”*

**Negative examples.**

1. *“Wildlife corridors connect summer and winter range for migratory ungulates.”* — generic connectivity for annual movement, no climate framing. T1.4 yes, T1.4a no.

---

## T1.4b Corridor
**Canonical phrase:** “corridor,” “wildlife corridor,” “habitat corridor.”

**Codebook elements served:** 1.4 (as the most common concrete instance); 4.1 (as a priority-area type); 4.2 (as structural facilitation).

**Definition.** A landscape feature — continuous or stepping-stone — that facilitates movement of organisms between habitat patches.

**In-scope synonyms.** “corridor,” “wildlife corridor,” “habitat corridor,” “migration route,” “movement route,” “movement corridor,” “ecological corridor,” “linkage,” “wildlife linkage,” “stepping stones,” “stepping-stone parcels,” “ecological network,” “habitat patches” (when discussed as connectivity nodes).

**In-scope hyponyms.** “Climate corridor” (climate-relevant — see T1.4a), “riparian corridor” (when functioning as a movement corridor), “elevational corridor.”

**Polysemy.**

* **“Corridor”** can also mean economic corridor, transportation corridor, urban corridor — out of scope unless paired with wildlife/habitat/ecological framing.

**Positive examples.**

1. *“Corridors are the pathways or linkages between habitat cores.”*

2. *“Stepping-stone parcels support dispersal across fragmented agricultural landscapes.”*

**Negative examples.**

1. *“The I-5 corridor between Seattle and Portland is experiencing rapid growth.”* — transportation/urban corridor; out of scope.

---

## T1.4c Refugia / climate refugia
**Canonical phrase:** “climate refugia,” “refugia.”

**Codebook elements served:** 1.4 (related concept), 4.1 (priority area type).

**Definition.** Locations where local biophysical conditions reduce the rate or magnitude of climate exposure relative to the surrounding landscape, allowing persistence of species, populations, or ecological processes that might otherwise decline under climate change. Closely related to but distinct from corridors.

**In-scope synonyms.**

* “climate refugia,” “climate-change refugia”
* “refugia” (when climate-framed; see polysemy)
* “microrefugia”
* “thermal refugia,” “cold-water refugia”
* “bioclimatic refugia”
* Periphrases: “climate-resilient sites,” “areas that buffer against climate change,” “places where conditions remain suitable under projected change”

**Polysemy disambiguation.**

* **“Refugia”** in paleobiology refers to areas where species persisted through glacial periods (paleoclimatic refugia). Out of scope for the contemporary-climate-change codebook unless the document is explicitly using paleoclimatic refugia as analog/lesson for contemporary refugia (rare).
* **“Refuge”** singular often means a protected area (wildlife refuge, fish refuge) — different concept; out of scope unless climate-framed.

**Excluded lookalikes.**

* “National Wildlife Refuge” / “wildlife refuge” as a protected-area designation. Out of scope.
* Pleistocene refugia (paleo). Out of scope.

**Positive examples.**

1. *“Refugia are areas where local biophysical conditions reduce the rate or magnitude of climate exposure relative to the surrounding landscape.”*

2. *“Cold-water refuges maintained by groundwater can buffer fish from thermally stressful conditions during droughts.”*

**Negative examples.**

1. *“The Hanford Reach National Monument includes a wildlife refuge along the Columbia River.”* — protected-area refuge; out of scope.

---

# Theme 2 — Tools
---

## T2.1 Vulnerability model / framework
**Canonical phrase:** “vulnerability model,” “vulnerability assessment framework.”

**Codebook elements served:** 2.1.

**Definition.** Quantitative or semi-quantitative models, indices, or structured frameworks that estimate the risk of decline, extirpation, or persistence for species/populations/ecosystems by combining exposure, sensitivity, and adaptive-capacity-type inputs.

**In-scope synonyms.**

* “vulnerability model,” “vulnerability assessment,” “vulnerability analysis,” “climate vulnerability assessment”
* “vulnerability index”
* “Climate Change Vulnerability Index,” “CCVI”
* “NatureServe CCVI”
* “Population Viability Analysis,” “PVA”
* “species vulnerability assessment”
* “ecosystem vulnerability assessment”
* “trait-based vulnerability assessment”
* “Sensitivity–Exposure–Adaptive Capacity (SEAC) framework”
* “EcoAdapt vulnerability framework”

**Hyponyms.** Specific tools: CCVI (NatureServe), Climate Change Sensitivity Database (CCSD), Climate Wizard, EcoAdapt Cheat Sheet, ICEM (Index of Climatic Exposure to Mammals), AdaptWest vulnerability assessments, IPCC-AR5 risk framework when operationalized.

**Polysemy.**

* **“Assessment”** is generic — many things are assessments (status assessments, threats assessments, monitoring assessments). In scope for T2.1 only when the assessment is specifically about climate vulnerability.

**Excluded lookalikes.**

* “Threats assessment” or “conservation status assessment” without climate-vulnerability framing — out of scope (may be evidence elsewhere).
* “Habitat assessment” / “ecological assessment” generically — out of scope unless climate-vulnerability-specific.

**Positive examples.**

1. *“The agency incorporated vulnerability assessments into a dedicated chapter of the prior plan, considering sensitivity, exposure, and adaptive capacity across most focal species and related habitats.”*

2. *“CCVI scores were calculated for 50 priority species using the NatureServe methodology.”*

**Negative examples.**

1. *“A statewide threats assessment identified roads, agriculture, and residential development as primary threats.”* — threats assessment without climate-vulnerability framing. Out of scope.

---

## T2.2 Niche model / species distribution model
**Canonical phrase:** “species distribution model,” “niche model.”

**Codebook elements served:** 2.2.

**Definition.** Models that predict a species’ potential geographic distribution by relating known occurrence records, physiological traits, or performance to environmental conditions. Often used to project distributions under climate scenarios.

**In-scope synonyms.**

* “species distribution model,” “SDM”
* “ecological niche model,” “ENM”
* “niche model”
* “habitat suitability model” (when used in the SDM sense)
* “climate envelope model” (older terminology, still in use)
* “bioclimatic model,” “bioclimatic envelope model”
* “correlative distribution model”
* “mechanistic niche model”
* “process-based distribution model”

**Hyponyms.** Specific tools/algorithms: MaxEnt, BIOCLIM, DOMAIN, GARP, biomod2, ENMTools, INHABIT, WISDM, RandomForest-based SDMs, GLM/GAM-based SDMs, ensemble SDMs, LANDIS PRO. Tools that collate the results of species distribution models: Climate Change Tree Atlas, Forest Ecosystem Atlas.

**Polysemy.**

* **“Distribution model”** alone could mean a probability distribution model (statistical, out of scope) or a species distribution model (in scope). Decision rule: in scope when the subject of the modeling is a species or habitat.

**Excluded lookalikes.**

* “Range map” — a range map is the product, not a model. A document that displays range maps without underlying distribution modeling does not engage T2.2.
* Stream-suitability models when not framed as distribution models — borderline; usually out of scope unless tied to species distribution explicitly.

**Positive examples.**

1. *“MaxEnt was used to model the current and projected distribution of the focal species under RCP4.5 and RCP8.5.”*

2. *“Develop and document distribution-model methods for under-studied focal species that can incorporate the agency’s institutional data sets.”* — references SDMs even if as a future recommendation; in scope as a 1 (referenced generally).

**Negative examples.**

1. *“Range maps for all SGCN are provided in Appendix D.”* — range maps as product, no SDM framing. Out of scope.

---

## T2.3 Climate model / climate projection
**Canonical phrase:** “climate model,” “climate projection.”

**Codebook elements served:** 2.3.

**Definition.** Models and tools that simulate or project future climate conditions, typically derived from global climate models (GCMs), regional climate models, or downscaled products derived from them.

**In-scope synonyms.**

* “climate model,” “climate models”
* “Global Climate Model,” “GCM,” “General Circulation Model”
* “Regional Climate Model,” “RCM”
* “Earth System Model,” “ESM”
* “downscaled climate projection,” “statistical downscaling,” “dynamical downscaling”
* “CMIP5,” “CMIP6,” “Coupled Model Intercomparison Project”
* “climate scenario,” “emission scenario,” “concentration scenario”
* “RCP4.5,” “RCP8.5,” “Representative Concentration Pathway”
* IPCC scenarios: “SSP1-2.6,” “SSP5-8.5,” “Shared Socioeconomic Pathway”
* “climate analog tool,” “climate analog model”
* Named tools: “USGS National Climate Change Viewer,” “Climate Toolbox,” “Climate Mapper,” “CIG Decision Support Tools” (UW PNW), “WorldClim” (when used as a climate projection product), “CHELSA,” “PRISM” (when projecting forward)
* “climate envelope projection,” “future climate scenario”

**Hyponyms.** Specific GCM names (e.g., CESM2, HadGEM3, MPI-ESM, CanESM5, GFDL CM2, IPSL-CM6A, MPI-ESM1, UKESM1-0), specific downscaling products (e.g., MACA, LOCA, BCSD, Minnesota CliMAT (Climate Mapping and Analysis Tool), specific scenario combinations.

**Polysemy.**

* **“Climate projection”** vs. **“climate prediction”** — both in scope.
* **“Model”** alone could mean any model — in scope for T2.3 only when the modeled subject is climate.
* **“Sensitivity”** — climate sensitivity in the physical-science sense belongs here, not under T1.1b.

**Excluded lookalikes.**

* Qualitative descriptions of climate change (“warming,” “drier summers”) without reference to a model or scenario. These are climate-change evidence (C1) but not climate-model evidence.
* Historical climate records (PRISM historical data, observational records) — observational climatology, not climate modeling, unless the document uses them as inputs to projections.
* “Earth System science” generically — too broad.

**Positive examples.**

1. *“Projections under RCP4.5 and RCP8.5 to 2070 informed habitat suitability mapping for the focal species.”*

2. *“Downscaled CMIP6 outputs from the MACA dataset were used to characterize future thermal regimes.”*

**Negative examples.**

1. *“The interior region of the state is facing hotter, drier summers than were historically typical.”* — climate change yes (C1), but no model reference; out of scope for T2.3.

2. *“Historical PRISM precipitation data informed the baseline.”* — observational climatology, not a projection. Out of scope for T2.3 unless used as input to projections.

---

## T2.4 Connectivity model
**Canonical phrase:** “connectivity model.”

**Codebook elements served:** 2.4.

**Definition.** Models that quantify or map how well a landscape facilitates organism movement, often producing connectivity surfaces, corridor networks, or pinch-point identification.

**In-scope synonyms.**

* “connectivity model”
* “circuit-theory connectivity model”
* “least-cost path model,” “LCP”
* “graph-theoretic connectivity model”
* “resistance surface model”
* “current-flow connectivity”
* “permeability model”
* “corridor model”

**Hyponyms.** Specific tools: CircuitScape, Omniscape, RangeShifter, Marxan (with connectivity penalties), Climate Linkage Mapper, Linkage Mapper, Conefor, SyncroSim.

**Decision rule (per codebook 2.4 borderline).** A document that uses the **output** of connectivity modeling (e.g., “Connected Landscapes of Statewide Significance” derived from such modeling) without naming the underlying software counts as application. The “applied” criterion is about whether modeling output shapes management decisions, not whether the algorithm is named.

**Polysemy.** “Connectivity analysis” without modeling framing — sometimes documents say “analysis” when they mean “discussion.” In scope for T2.4 only when the analysis is quantitative or model-based.

**Excluded lookalikes.**

* Qualitative connectivity discussion without underlying model. (Engagement with connectivity-the-concept is T1.4; T2.4 requires a model.)
* Hydrologic connectivity modeling (stream network connectivity) — in scope only when tied to biological movement, not just water flow.

**Positive examples.**

1. *“A regional habitat connectivity plan provides spatial layers depicting structural connectivity, network importance, landscape permeability, and climate connectivity.”*

2. *“CircuitScape was used to model current flow across the resistance surface, identifying pinch points.”*

**Negative examples.**

1. *“Wildlife corridors are essential for maintaining gene flow.”* — connectivity concept (T1.4), no model. Out of scope for T2.4.

---

# Theme 3 — Context
---

## T3.1 Management scale
**Canonical phrase:** “management scale” (local / regional / landscape).

**Codebook elements served:** 3.1.

**Definition.** The spatial extent at which habitat restoration, management, and connectivity are addressed in the document.

**In-scope synonyms.**

* “jurisdiction” / “administrative unit” (generic but applicable if no other scale descriptor is present)
* “local-scale” / “site-scale” / “site-level” / “parcel-level” / “wildlife management unit” / “game management unit”
* “county” / “section” / “subsection”
* “regional-scale” / “ecoregional-scale” / “landscape-scale” / “landscape-level” / “province”
* “statewide,” “multi-state,” “transboundary”
* “watershed-scale,” “basin-scale” (when these are larger than a single site)
* “landscape conservation,” “landscape-level conservation approach”

**Decision rule (per codebook 3.1).** The scale of the plan itself does not determine the score — what matters is the scale of the proposed *management actions*. A statewide plan that only recommends site-level actions will be scored “yes” for local; a plan that includes both site and landscape actions will be scored “yes” for both components as well as any more specific language used to describe the management scale.

**Polysemy.**

* **“Local”** can mean local in a spatial sense (in scope) or local in an administrative sense (“local government”). Spatial sense is what counts.
* **“Region”** can mean ecoregion, federal region, biogeographic region, or general “region of the country.” In-scope for T3.1 when the framing is spatial conservation scale.

**Positive example.** *“The plan addresses both site-level habitat stewardship and landscape-level connectivity across nine ecoregions.”*

**Negative example.** *“The local government will be consulted on permit applications.”* — administrative “local”; out of scope.

---

## T3.3 Biological unit
**Canonical phrase:** “biological unit” (species, population, habitat, ecosystem, community, genotype/phenotype).

**Codebook elements served:** 3.2, 3.3.

**Definition.** The biological entity or level of organization that range shift science is applied to in the document.

**In-scope component synonyms.**

* *Species* — “species,” “taxon,” “taxa,” “SGCN,” “focal species”
* *Population* — “population,” “subpopulation,” “metapopulation,” “deme,” “stock” (fisheries)
* *Habitat* — “habitat,” “habitat type,” “HGCN,” “natural community,” “vegetation community,” “NVC group” (specific to WA SWAP NVC system)
* *Ecosystem* — “ecosystem,” “ecological system,” “biome,” “Group Ecological Type (GET)”
* *Community* — “community,” “biotic community,” “assemblage,” “guild”, “herd”
* *Genotype/phenotype* — “genotype,” “phenotype,” “genetic lineage,” “evolutionarily significant unit,” “ESU,” “distinct population segment,” “DPS”

**Polysemy.**

* **“Population”** can also mean human population — out of scope.
* **“Community”** can mean human community — out of scope.
* **“Habitat”** is sometimes used loosely to mean “any place an animal lives” — for the codebook, count it as habitat-unit when used in conservation-target sense (specific habitat types are named or categorized).

**Positive example.** *“This plan addresses Species of Greatest Conservation Need (SGCN), their habitats, and the broader ecosystems that support them.”*

**Negative example.** *“The local community has been engaged in plan development.”* — human community; out of scope.

---

## T3.4 Partnerships
**Canonical phrase:** “partnerships,” “collaborations.”

**Codebook elements served:** 3.4.

**Definition.** Inter-organizational relationships — among states, agencies, tribes, NGOs, academic institutions, private landowners — through which conservation actions are implemented.

**In-scope synonyms.** “partnerships,” “partners,” “partnering,” “collaborations,” “collaborators,” “joint ventures,” “MOUs” (memoranda of understanding), “cooperative agreements,” “compacts,” “alliances,” “coalitions,” “networks” (when meaning organizational networks), “interagency coordination,” “intergovernmental coordination,” “tribal partnerships,” “co-management,” “multi-state,” “inter-state,” “intergovernmental coordination,” “transboundary partnership”

**Polysemy.**

* **“Network”** can mean organizational (in scope) or ecological/landscape (out of scope here — T1.4).

**Positive example.** *“Tribes contributed significantly to the content of this plan through briefings, coordination, and First Foods section development.”*

**Negative example.** *“The state highway network bisects priority habitats.”* — infrastructure network; out of scope.

---

## T3.4b Funding
**Canonical phrase:** “funding,” “financial allocation.”

**Codebook elements served:** 3.4.

**Definition.** Monetary resources allocated, requested, or anticipated for conservation action.

**In-scope synonyms.** “funding,” “funds,” “budget,” “appropriation,” “grants,” “grant programs,” “financial allocation,” “investment,” “financing,” “strategic investment,” “fund allocation,” “budgetary support,” “match funding,” “leveraged funding,” “fiscal resources.”

**In-scope periphrases.** “Insufficient resources to implement the plan,” “the agency requested $X but received $Y,” “additional resources will be required.”

**Polysemy.** Mostly unambiguous in conservation documents.

**Positive example.** *“The agency requested $40 million in biodiversity conservation funding in the current operating budget. The agency received partial funding ($20 million for the biennium).”*

**Negative example.** *“Fund the species into the ESA listing process.”* — figurative/legal language, not financial allocation per se.

---

## T3.5 Climate-induced habitat degradation
**Canonical phrase:** “climate-induced habitat degradation.”

**Codebook elements served:** 3.5.

**Definition.** Loss or degradation of habitat caused by climate-driven processes — drought, wildfire, sea level rise, saltwater intrusion, snowpack loss, ocean acidification, etc.

**In-scope synonyms / processes.**

* “climate-induced drought” / “climate-driven drought”
* “increased wildfire frequency/severity/extent” (when climate-attributed)
* “saltwater intrusion” (into freshwater systems, climate-driven via sea level rise)
* “sea level rise impacts on coastal habitat”; "coastal ecosystem loss”
* “snowpack loss,” “earlier snowmelt,” “glacial retreat” (when framed as habitat impact)
* “sea-ice loss” (when framed as habitat impact)
* “altered hydrologic regimes” (climate-driven)
* “ocean acidification” (as habitat degradation)
* “marine heatwaves” (as habitat degradation)
* “coral bleaching” (climate-driven)
* “tundra-shrub transition” / “shrubification” (warming-driven habitat conversion)
* “conifer/juniper encroachment" (when climate-attributed)
* “saline lake water level impacts on migratory bird habitat” (when climate-attributed)

**Decision rule.** The framing must connect climate to the habitat impact, even if briefly. A passage that lists drought and wildfire among general threats without climate attribution is borderline; lean to in-scope if climate change is engaged elsewhere in the document and the threats are well-known climate-driven processes in the region. Lean to out-of-scope if the document treats fire and drought as natural disturbance regimes without climate framing.

**Excluded lookalikes.**

* Habitat degradation from non-climate causes (urban development, agricultural conversion, pollution) — out of scope for T3.5.
* Historical fire/drought without climate framing — out of scope.

**Positive example.** *“As the climate changes, the interior region of the state is facing even hotter and drier summers than were historically typical, with prolonged droughts and heatwaves that place more demand on moisture-limited systems.”*

**Negative example.** *“Residential development is the primary driver of shrubsteppe habitat loss in the basin.”* — non-climate; out of scope for T3.5.

---

## T3.6 Climate-induced species vital rates
**Canonical phrase:** “climate-induced species vital rates.”

**Codebook elements served:** 3.6.

**Definition.** Direct impacts on organism vital rates caused by climate-driven events — for mortality, for example, this includes wildfire-killed individuals, heat-related die-offs, drought-related fish kills, climate-favored emerging pathogens, mass coral mortality from bleaching, etc.

**In-scope synonyms.**

* “mortality from wildfire” / “wildfire-caused mortality”
* “heat-related mortality,” “heat die-off,” “mass mortality from heat”
* “drought-driven fish kills”
* “climate-induced disease,” “emerging pathogens” (when climate-favored framing)
* “marine die-offs” (climate-attributed)
* “coral mortality from bleaching”
* “die-off,” “mass mortality,” “mass die-off”, “die-back” (when climate-attributed)
* “recruitment failure”, “reproductive rates,” “pregnancy,” “nest success” (climate-attributed)

**Decision rule (per codebook 3.6).** The framing must be a direct influence on vital rates — climate-driven events causing organisms to die, reproduction or recruitment events to fail, populations to be extirpated, or die-off events to occur, etc.. Habitat degradation, ecosystem stress, and altered disturbance regimes that affect species indirectly are captured under 3.5 (Habitat Degradation), not here. The chain “climate → habitat impact → eventual species effect” is not sufficient for 3.6; the framing must be “climate event → impact on species vital rate.”Generic disease emergence or pathogen discussion without explicit climate linkage does not count. The pathogen must be framed as climate-favored or climate-emerging.

**Excluded lookalikes.**

* “Habitat loss from wildfire” — T3.5, not T3.6.
* “Population decline” without explicit vital rate framing — does not count.
* Pathogen discussion without climate framing — does not count.

**Positive example.** *“Mass mortality events have been observed in intertidal communities following recent marine heatwaves.”*

**Negative example.** *“Wildfire damages forest habitat critical for cavity-nesting birds.”* — habitat impact (T3.5), not direct mortality.

---

## T3.7 Climate-driven biotic stressors
**Canonical phrase:** “climate-driven invasion,” “climate-driven succession,” “climate-driven phenological change”

**Codebook elements served:** 3.7.

**Definition.** Changes in biotic conditions caused by climate change favoring particular taxa, communities, or processes. This includes invasion (climate-favored expansion of non-native species), successional change in community composition driven by warming, as well as changes in phenology due to growing season expansion which affects species’ interactions with e.g., competitors, mutualists, and food resources.

**In-scope synonyms.**

* “climate-favored invasion,” “climate-favored invasives”
* “range-shifting invasives” (when climate-driven)
* “climate-driven succession,” “succession driven by climate”
* “community composition change” (when climate-attributed)
* “novel communities,” “no-analog communities”
* “shifts in community composition”, “shift in dominant species” (when climate-framed)
* “vegetation conversion,” “vegetation type change” (climate-driven)
* “shifts in spring phenology” / “shifts in greenup timing”
* “Phenological mismatch,” “trophic asynchrony,” “temporal mismatch,” “temporal asynchrony”

**Decision rule.** Discussion of invasive species without climate framing does **not** count. The framing must connect climate to the invasion or successional process or shifts in phenology.

**Excluded lookalikes.**

* Invasive species discussion without climate framing — out of scope.
* Succession in the classical Clementsian sense (post-disturbance recovery) without climate framing — out of scope.

**Positive example.** *“Warming has allowed invasive cheatgrass to expand its range into higher elevations previously dominated by native bunchgrasses.”*

**Negative example.** *“Invasive Burmese pythons threaten native wildlife in the Everglades.”* — invasion without climate framing; out of scope.

---

# Theme 4 — Actions
---

## T4.1 Priority habitat / spatial prioritization
**Canonical phrase:** “priority habitat,” “spatial prioritization.”

**Codebook elements served:** 4.1.

**Definition.** Identification of specific habitat areas as priorities for protection, restoration, or management — particularly when supported by spatial representation (maps, zonation).

**In-scope synonyms.**

* “priority habitat,” “priority areas”
* “conservation opportunity areas,” “COAs”
* “focal areas,” “focal conservation areas”
* “climate refugia” (as a priority area type — see T1.4c)
* “resilient sites,” “climate-resilient sites”
* “sites of concern”
* “core habitat,” “habitat cores”
* “biodiversity hotspots”
* “high-value habitat”
* “zonation,” “conservation zoning”
* “Habitats of Greatest Conservation Need,” “HGCN”
* “Priority Habitats and Species (PHS)” (specific to WA usage)

**Decision rule (per codebook 4.1).** The 0/1/2 distinction depends on whether priority habitat is **spatially represented** (maps, zonation, GIS layers). Narrative-only discussion scores 1; spatially explicit prioritization scores 2.

**Excluded lookalikes.**

* “High-priority actions” without spatial referent — that’s action prioritization, not habitat prioritization.

**Positive example.** *“Figure 12 displays the Statewide Landscape Connectivity Value, integrating cores and corridors into 13 Connected Landscapes of Statewide Significance.”*

**Negative example.** *“Habitat restoration is the highest priority action.”* — narrative without spatial element.

---

## T4.2 Range-shift management
**Canonical phrase:** “range-shift management,” “range shift facilitation,” “preventing range shifts,” “responding to range shifts”

**Codebook elements served:** 4.2.

**Definition.** Conservation actions intended to manage climate-driven range shifts. Includes facilitation either *structural* means (corridors, connectivity, refugia protection) or *direct* means (translocation, assisted migration), prevention, or response.

**In-scope synonyms — structural.**

* “climate corridors” (as facilitation, not just concept)
* “connectivity easements”
* “corridor protection,” “corridor enhancement”
* “refugia protection,” “refugia management”

**In-scope synonyms — direct.**

* “species translocation,” “translocation”
* “assisted migration,” “managed relocation,” “conservation translocation”
* “reintroduction” (climate-motivated)
* “captive breeding for climate adaptation”
* “managed colonization”, “assisted colonization”
* “range-shifting species control,” “range-shifting species eradication,” “range-shifting species suppression”   
* “invasive species control to facilitate native shifts”

**Decision rule (per codebook 4.2).**

* **Structural facilitation** is in-scope; also counted under T1.4 (Connectivity). Both elements can be scored from the same evidence.
* **Direct manipulation** is in-scope only when explicitly motivated by climate or range shifts. Reintroduction or translocation for generic species recovery (e.g., reintroducing extirpated species to historical range) does **not** count.
* Either category alone earns a 1; the scale is binary.

**Excluded lookalikes.**

* Reintroduction without climate framing — out of scope for T4.2.
* Habitat restoration without explicit climate-shift framing — that’s T4.1.
* General invasive species control, unless the range expansion of the species is climate-driven.

**Positive examples.**

1. *“Climate corridors are explicitly designed to connect habitats along a climate gradient allowing altitudinal and latitudinal range shifts.”* — structural facilitation.

2. *“Assisted migration trials are underway for tree species expected to lose suitable habitat at the trailing edge by 2070.”* — direct manipulation, climate-motivated.

**Negative examples.**

1. *“Captive-reared northern leopard frogs are being reintroduced to support population recovery.”* — generic recovery, no climate framing. Out of scope for T4.2.

2. *“Translocations of bighorn sheep have re-established historical populations.”* — historical-range restoration, not climate-shift facilitation. Out of scope.

---

## T4.3 Time-bound action / monitoring
**Canonical phrase:** “time-bound action,” “deadlines,” “effectiveness monitoring.”

**Codebook elements served:** 4.3.

**Definition.** Two distinct dimensions: (a) explicit deadlines or milestones attached to specific conservation actions, and (b) effectiveness monitoring / periodic assessment of action outcomes.

**In-scope synonyms — deadlines/time-bound.** “deadline,” “milestone,” “by [year],” “within [N] years,” “5-year goal,” “10-year target,” “time-bound action,” “scheduled action,” “phased implementation,” “interim target,” “end date.”

**In-scope synonyms — monitoring.** “effectiveness monitoring,” “performance monitoring,” “outcome monitoring,” “adaptive management” (when paired with monitoring), “periodic assessment,” “survey” (as a synonym for monitoring, not a questionnaire), “annual reporting,” “progress tracking,” “implementation tracking,” “evaluation cycle,” “plan-do-check-act,” “iterative review,” “#-year review” (including “3-year review,” “5-year review,” “10-year review”) 

**Decision rule (per codebook 4.3).** Time-binding at the **action level**, not the plan level. A 10-year plan revision cycle without action-level deadlines scores at most 1. Score 2 requires both deadlines AND effectiveness monitoring at the action level.

**Excluded lookalikes.**

* “Implementation timeline” as a generic mention, without specific dates or milestones, is borderline.
* Adaptive management as a stated principle in the introduction, without operationalization at the action level — counts toward score 1 only.

**Positive example.** *“Each action in this section is paired with a 5-year implementation milestone and an effectiveness monitoring protocol.”*

**Negative example.** *“The agency endorses adaptive management as a guiding principle for all conservation work.”* — principle, not action-level operationalization. Score 1 at most.

---

## T4.4 Evidence of efficacy
**Source.** 

**Canonical phrases:** “efficacy,” “success rate,” “basis of evidence” 

**Codebook elements served:** 4.4.

**Definition.** Whether evidence to support the efficacy of an action is presented. This could include references to data, literature, or demonstration projects from other systems or a reflection on monitoring data of the action itself if it has already been implemented. Distinct from plans to monitor the effectiveness of an action (included in 4.3), this element captures the extent to which actions included in plans are supported by existing evidence.

**In-scope synonyms.** 

* “data-driven,” “data-driven,” “science-backed” in reference to an action  
* “lessons learned,” “maladaptation,” “post-action evaluation,” “after-action reflection,” “impact report,” “post-mortem” (in reference to project assessment), “project takeaways,”  
* “success stories,” “case studies,” “proof of concept,” “insights gained,” “key takeaways” (related to the results of a study or prior action)  
* “efficacy testing,” “efficacy evaluation”   
* “best practices” (when presented with reference to evidence), “strategic insights”    

**Decision rules.** 

* When general or vague ecological assumptions are presented as first principles to support an action, this does not count as providing evidence to support specific actions and scores a 1. 
* General references to “best practice” or “science-based strategy” or similar without additional justification or support provide limited evidence and score a 1. 
* “Limited evidence” includes references to studies that have limited applicability rather than applied studies testing efficacy. Studies with limited applicability include ones that are conducted in experimental or unrealistic settings, studies that focus on different locations or taxa than the subject of the plan, studies that test the basic principles underlying an idea but do not directly test an action.
* “Strong evidence” includes evaluations of previously implemented actions (“case studies”) and directly applicable studies (e.g., studies conducted in field or realistic conditions, studies that focus on a relevant location and/or subject, studies that directly test the outcomes of implementing the action in question).

**Positive example.** 

*“Experimental studies in this system have shown that climate-adaptive forest management leads to increased wildfire resilience (citation to study).”* (strong evidence)

## T4.5 Climate adaptation planning frameworks
**Source.** Definitions and terms in this section are drawn from Miller et al. 2025 with slight modifications; https://doi.org/10.1002/fee.70005.

**Canonical phrases:** : ”climate-change adaptation planning process”, “adaptive management,” “adaptation planning approaches”, “climate-informed resource-stewardship planning”

**Codebook elements served:** 4.5.

**Definition(s).** 

Climate adaptation planning frameworks encompass the set of planning processes (systematic and consistent series of steps for developing and implementing a plan) and tools (specific object or method for deriving or applying information) used to inform resource stewardship under climate change. A variety of related planning processes and tools exist, as defined below:

* Adaptive management – a process for decision making under uncertainty that involves an iterative cycle of decision-making, implementation, monitoring and evaluation that may result in adjusting the initial decision or design. 
* Adaptation menu – Set of previously developed strategies and actions that help practitioners consider a range of options and develop a portfolio or suite of strategies for a given area.
* Climate Change Scenario Planning (CCSP) – Development of a manageable set of divergent, challenging, relevant, and plausible descriptions of how climate may change and affect resources and of a plan to address such effects.
* Climate Change Vulnerability Assessment – Evaluation of resource exposure, sensitivity, and (for living resources) adaptive capacity in response to changes in climate.
* Resist–Accept–Direct (RAD) – A conceptual framework that defines the general range of adaptation response options, including resisting ecological change, accepting it, or directing it toward new conditions.
* Resistance–Resilience–Transition (RRT) – A conceptual framework that defines the general range of adaptation response options, including resisting ecological change, fostering resilience(enhancing an ecosystem’s ability to return to prior conditions following disturbance), or facilitating transition to new ecological conditions.
* Response modeling – Quantitative or qualitative approaches to building an understanding of how specific climate drivers affect a resource.
* Scenario-Based Decision Analysis (SBDA) – Defining resource management problems and solutions while evaluating the influence of potential uncertainties.
* Structured Decision Making (SDM) – Framing resource management problems, setting objectives, and analyzing and selecting management strategies.

**In-scope synonyms.** “adaptation menu,” “climate change scenario planning,” “climate change vulnerability assessment,” “CCVA,” “impact evaluation,” “Resist–Accept–Direct,”  “RAD,” “Resistance–Resilience–Transition,” RRT,” “Response modeling,” “Scenario-Based Decision Analysis, “SBDA,” “Structured Decision Making, “SDM” 

**Decision rule.** Planning processes, including adaptive management, are in scope only when they are framed in the context of decision-making under current or future conditions that result from climate change. 

**Polysemy.** **“Planning framework”** is generic — because most of these documents are plans, almost all of them will inherently reflect an implicit or explicit planning framework, but this framework may not be related to planning under climate change. In scope for T2.1 only when the planning is specifically about climate adaptation.

**Excluded lookalikes.**

* “SDM” when referring to species distribution models, rather than structured decision making.

**Positive example.** *“The Scaling Climate Change Adaptation in the Northern Great Plains project synthesizes climate data into 3-5 distinct but plausible climate summaries for the northern Great Plains region; crafts quantitative summaries of these climate futures for focal areas; and applies these local summaries by developing climate-resource-management scenarios through participatory workshops and, where possible, simulation models.”*

**Negative example.** *“The plans are developed, reviewed, and updated on a scheduled basis with teams of experts from the DNR Divisions of Forestry, Fish and Wildlife, and Ecological and Water Resources. These teams also work with partners and the public to write and review the plans and review feedback through webinars, surveys, and open comment periods.” –* This describes an approach to adaptive management, but it is not framed in a climate context. 

---

# Theme 5 — References
---

# Appendix: Maintenance
* **Adding a synonym.** During pilot, if a coder encounters a surface form not listed here, add it to the relevant entry under “in-scope synonyms” (or “excluded lookalikes,” with reasoning). Bump the dictionary patch version.
* **Adding a concept.** If a codebook revision adds an element or sub-construct that isn’t covered here, add a new entry with the standard structure. Cross-reference from the relevant codebook element.
* **Resolving a polysemy.** If a coder encounters a polysemous surface form that’s currently treated as unambiguous, add a polysemy-disambiguation block to the relevant entry.
* **Versioning.** Dictionary version is independent of codebook version, but the codebook header records which dictionary version it was paired with at freeze.