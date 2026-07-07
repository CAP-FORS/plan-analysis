===== DOCUMENT PART: ID_FAP-RA_2020.pdf =====

We greatly appreciate the support and assistance provided by the Idaho Lands Resource Coordination Council (ILRCC) who met regularly to inform, discuss, and guide this process; the members of the Idaho Forest Action Plan Core Assessment Team who rolled up their sleeves and helped identify goals and strategies; and the many folks who gave us helpful and constructive comments.

## Members of the Assessment Team:

• Joe Adamski -USDOI, Bureau of Land Management 

## Introduction Background and Purpose

The Idaho Forest Action Plan Resource Assessment was developed by the Idaho Department of Lands in partnership with many other agencies and organizations. This assessment is a key element in the redesign of the USDA Forest Service's State and Private Forestry and is a requirement within the 2008 Farm Bill for states receiving funding through the US Forest Service for State and Private Forestry programs. Its purpose is to ensure that federal and state resources are focused on landscape areas with the greatest opportunity to address shared priorities and achieve measurable outcomes.
The Forest Resource Assessment provides a geospatial analysis of conditions and trends for all forested lands in Idaho. It delineates rural and urban forest areas that are the highest priority for projects and investments administered through State and Private Forestry programs. Threats to and benefits from forest resources were identified and form the foundation of the analysis. A companion Statewide FAP Resource Strategy will be developed to address the issues and priority areas identified in this assessment. The Resource Strategy will identify activities and approaches for protection, restoration and enhancement of forest resources in priority landscapes.
For more information on the Forest Action Plans, see the national guidance from the National Association of State Foresters:
Who is working on the Idaho FAP Resource Assessment?
Idaho Department of Lands is the Lead Agency. A diverse group of partners is participating, including:
• Idaho Department of Environmental Quality The intent of this geospatial analysis is to:
• Identify areas where invasive plants threaten forest health
• Identify areas where damaging insects threaten forest health
• Identify areas where disease threatens forest health
• Identify areas where climate change may increase stress to forests

## Discussion:

Forests face many different kinds of threats. The purpose of this analysis is to identify the most significant challenges to forest health. These include forest insects and diseases that result in tree mortality; noxious weeds which compromise the health and composition of forest stands; and climate change, which may modify current ranges of forest species and add additional stress to forests. Not only do these factors damage forests ecologically, they have social and economic impacts as well. They impact wildlife habitat, timber markets, recreation, and can exacerbate wildfire. The spatial areas identified in this analysis highlight current problem locations as well as areas likely to experience degraded forest health in the near future. Appropriate forest-management activities in the identified areas can minimize these threats.

## Data Used:

Data used for this issue were divided into seven main categories as follows:

## Bark Beetles

Native bark beetles attack and kill trees by feeding and reproducing in the conductive tissue beneath the bark. The risk of bark beetle-caused tree mortality in the next ten years was estimated by considering risk factors associated with four major bark beetle species in Idaho: mountain pine beetle (Dendroctonus ponderosae) (MPB), spruce beetle (Dendroctonus rufipennis) (SB), western pine beetle (Dendroctonus brevicomis) (WPB), and Douglas-fir beetle (Dendroctonus pseudotsugae) (DFB). For each bark beetle species, risk was modeled to increase with increasing host-type basal area. Proximity to current (2017) infestations also increased modeled risk, although to a lesser extent than host type basal area due to the ephemeral nature of beetle outbreaks. Overall stand basal area, used to represent stand density, was a third factor that increased modeled risk for all four bark beetle species.
Data layers:
a. Host basal area (BA). Layers showing the BAs for lodgepole pine (MPB host), Engelmann spruce (SB host), ponderosa pine (WPB host), and Douglas-fir (DFB host) were obtained as rasters from the USDA Forest Service, Forest Health Assessment & Applied Sciences Team (FHAAST) server using a cell size of 250 were used to represent areas of current infestation for each beetle species. Data for MPB, SB, WPB, and DFB were extracted, merged, and dissolved into a single polygon for each bark beetle species. Each polygon was converted to a raster with a cell size of 50 meters. The Euclidean Distance tool was applied to each raster using a cell size of 250 meters. The output raster was classified into five classes such that areas closer to current infestations were ranked with higher risk values than areas further away from current infestations:
Distance to current infestation (miles) Assigned Class >3 1 1 -3 2 .5 -1 3 0 -.5 4 0 (currently infested) 5
Data were clipped to Idaho and the IDTM 83 projection was used.
c. Overlay of host BA and proximity to current infestation: The raster calculator was used to sum the reclassified host BA raster (0-7 scale) and the proximity to current activity raster (1-5 scale) for each of the four beetle species. In these calculations, host BA was weighted twice as heavy as proximity to current infestation in order to lend more importance to this factor when considering risk over the 10-year time frame. e. Final output: The raster calculator was used to sum the 4 risk rasters associated with each beetle species (MPB risk, SB risk, WPB risk, DFB risk) and the raster showing overall stand BA (0-10 scale). The output from summing these rasters was the overall bark beetle risk raster. Overall bark beetle risk was reclassified into six classes (0-5) using Jenks natural breaks, where 0 = no data and 5 = highest risk.

## Balsam Wooly Adelgid

The balsam woolly adelgid (Adelges piceae) (BWA) is a non-native, invasive sucking insect that infests grand fir (Abies grandis) and subalpine fir (Abies lasiocarpa) in Idaho, causing serious mortality of the latter. BWA has also recently been found infesting white fir (Abies concolor) in northeastern Utah. BWA can be a serious issue, especially in areas where subalpine fir is the primary forest species providing shade for streams. Loss of canopy in these areas can impact water quality and fish populations downstream. Subalpine fir also provides important wildlife habitat and influences snow retention at high elevations. Surveys have been conducted in Idaho since the 1980s, and recently this insect has been found in most locations where the hosts occur and is considered to be widely distributed in Idaho.
Although survey information for BWA presence in Idaho exists, BWA risk was generated using only host type basal area calculations. This is due to the alreadywidespread extent of this insect throughout the state, and its inherent difficulty to detect at low population levels. BWA can be very inconspicuous, therefore it is likely present in areas where hosts are present, even if it has not been officially confirmed in surveys. In addition to considering host type basal area, risk was modeled to be higher in southern Idaho than in northern Idaho. This is because recent observations by entomologists suggest that BWA-caused mortality is more severe in southern Idaho, possibly due to the drier climate conditions. Mortality of grand fir in southern Idaho may be due to the presence of a grand fir/white fir hybrid that is present in southern Idaho. Grand fir mortality in Region 4 is also in areas where grand fir is close to the southern extent of its range.
Data layers:
a. Host type BA: Rasters for grand fir and subalpine fir BA were extracted from the FHAAST dataset using a cell size of 300 meters. Data were clipped to Idaho and converted to the IDTM83 projection. Rasters for grand fir and subalpine fir BAs were summed using the raster calculator. Because subalpine fir has greater susceptibility to BWA-caused mortality than grand fir, subalpine fir was weighted twice as heavily as grand fir in these calculators. The output raster (combined subalpine fir and grand fir basal area) was reclassified to a scale of 0-30 using Jenks natural breaks.
b. Increased risk in southern Idaho: Additional raster calculations were made to increase BWA risk in southern Idaho by 20% in areas where hosts (subalpine fir and grand fir) were present. This data treatment was implemented due to observations by local experts indicating that hosts in southern Idaho succumb especially rapidly to BWA infestations.
c. Final output: The final output layer was reclassified to a scale of 0-5 using Jenks natural breaks where 0 = no data and 5 = highest risk. a. Historic defoliation patterns: This layer was developed by identifying areas that have historically been defoliated by DFTM from aerial detection survey data and historical analog data. For each year, shapefiles showing DFTMcaused defoliation were combined with a shapefile of the state of Idaho such that defoliated areas were represented by polygons with a value of 1 and non-defoliated areas in the state had a value of 0. These shapefiles were then converted to rasters for each year, such that cells with a value of 1 represented defoliated areas in that year, and all other cells (non-defoliated areas) had a value of 0. This process created a unique binary raster for each year where DFTM-caused defoliation was recorded.

## Douglas-fir

b. Raster overlay: Annual defoliation rasters were added together using the ESRI raster calculator tool. The resulting output raster was on a scale of 0-11, such that the value of each cell represented the number of years that DFTMcaused defoliation had been recorded in that area since the mid-20 th century (up to a maximum of 11 years total for some areas).
c. Host BA rasters (Douglas-fir, grand fir, and subalpine fir) were extracted from the FHAAST National Insect and Disease Risk Map (NIDRM) using cell sizes of 250, 300, and 300 meters, respectively. The three host BA rasters were then summed using the raster calculator, and the resulting raster was reclassified into four categories (0 -3) of increasing basal area using Jenks natural breaks.
d. Final output: The host BA raster (0 -3 scale) and historic defoliation raster (0 -11 scale) were added together using the raster calculator. The historic defoliation raster was weighted three times more heavily than the host BA raster in these calculations due to observed patterns of outbreaks recurring in the same or similar areas, despite DFTM hosts occupying much of the state. The resulting DFTM risk raster was reclassified to a scale of 0 -5 for defoliation risk using Jenks natural breaks.

## Root Diseases

Root diseases are a serious forest health issue in Idaho, especially in grand fir, Douglas-fir, and subalpine fir north of the Salmon River (USFS Region 1), though they also do occur in southern Idaho (USFS Region 4). Four root disease fungi cause the most problems in Idaho: Armillaria root disease (Armillaria ostoyae), laminated root disease (Phellinus sulphurascens), annosus root disease (Heterobasidion occidentale), and Schweinitzii root and butt rot (Phaeolus schweinitzii). A root disease model was not included in the 2010 assessment, but based on feedback from the ILRCC, it was included for 2020 assessment because higher resolution data were available from the NIDRM databases. b. Region 4 model: Since root disease is challenging to characterize in southern Idaho (Region 4), based on input from forest pathologists, the subalpine fir basal area raster (FHAAST database, cell size 300 meters) was used as a proxy for root disease in Region 4.
c. Final output: The Region 1 and Region 4 rasters were joined and classified into a 0 -4 scale. A separate binary raster with presence/absence of highly susceptible host type (grand fir and subalpine fir) was created and classified as 0 (fir absent) or 1 (fir present). This host presence raster was added to the combined Region 1/Region 4 raster and reclassified from 0 -5 to create a risk model for the state.

## White Pine Blister Rust

White pine blister rust (Cronartium ribicola) (WPBR) is an introduced fungus that has caused widespread mortality throughout the range of western white pine (Pinus monticola) and other related five-needled pines. This layer was developed from the USFS -FHAAST National Insect and Disease Risk Map (NIDRM) published WPBR models for limber (Pinus flexilis), whitebark (Pinus albicaulis) and western white pines in the Intermountain West 
(Krist et al., 2014)
. Data used in the NIDRM models included incidence of host, climate variables, and in some cases elevation.
Data layers:
a. The three rasters (WPBR risk for limber, whitebark, and western white pines) were reclassified to a 0-5 scale using Jenks natural breaks and summed using the raster calculator tool. The final output was reclassified to a 0-5 scale using Jenks natural breaks where 0 = no data and 5 = highest risk.

## Terrestrial noxious weeds

Noxious weeds can negatively impact forest health by competing with natural forest vegetation, altering resources for wildlife, and in some cases, increasing the risk of wildfire.
Data b. Weeds at the watershed level: The weeds dataset was converted into a 30meter resolution raster grid. Percent coverage of the noxious weeds within each 6 th level hydrologic unit code (HUC) were obtained by taking the total count of noxious weed pixels, converting these pixels into area and dividing by total area of HUC. Percent coverage was then reclassified to a 0 -5 scale using equal intervals, with values from zero to three.

## Climate Change

Climate change was modeled as a forest health threat, even though it is also a factor in several other forest threats and benefits included in the 2020 Idaho FAP (wildfire, water quality, wildlife, etc.). Modeling climate change risk once and incorporating it into the final model prevents double-counting, and climate interactions for all threats can be covered in their respective narrative sections of the Resource Strategy.
Climate change as a threat to forests can be interpreted in a wide variety of ways. In order for this threat to be modeled and included in this 2020 FAP, however, statewide geospatial data is absolutely essential. While there are many climate datasets available, there is a general lack of geospatial (mapped) data that specifically shows how climate will affect forests across the entire state of Idaho.
Because this issue is so complex, we felt that it was important to use peer-reviewed, published datasets that were analyzed and produced by academic experts.
Ultimately, published geospatial data predicting landcover vegetation changes across the state due to climate change was selected. Areas that were predicted to undergo the most frequent and drastic landcover type changes were identified through modeling and used as a proxy to show stress to forests due to climate change. Land cover rasters developed by 
Brown et al. 1998
 b. Magnitude of landcover changes: In addition to capturing the frequency of landcover change for a given pixel, we also thought it was important to capture the magnitude of change for a given pixel. For each raster 
(Brown, 2030
(Brown, , 2060
(Brown, , and 2090) )
 we reclassified landcovers into 2 categories: forest, or non-forest.
Cells were valued to reflect the number of times that cell was projected to be forested throughout the forecasting period. For example: 0 = no change in forest or non-forest landcover type for all projectionsstays either forest or non-forest the whole time 1 = is forest for 3 projections, is non-forest for 1 projection 2 = is forest for 2 projections, is non-forest for 2 projections 3 = is forest for 1 projection, is non-forest for 3 projections Therefore, higher numbers reflect greater climate change risk to forests. It is important to note that this method does not take into account the order of the changes, but we anticipate that this problem can easily be addressed by masking out all current non-forest in final maps.
c. Final output: The two rasters were combined, with magnitude of change (2 nd raster) weighted twice as heavily as frequency of change. The final raster was reclassified using Jenks natural breaks to a scale of 0 -5, with higher numbers indicating greater climate change threat to forests.

## Analysis Process:

Seven threats to forest health in Idaho were identified for the 2020 Forest Action Plan: three insect-related threats (bark beetles, balsam woolly adelgid, and Douglas-fir tussock moth), two pathogen-related threats (root disease and white pine blister rust), terrestrial noxious weeds, and climate change. A statewide geospatial dataset was created for each of the seven forest health threats by combining a series of relevant layers and ranking the final output on a scale of 0 -5, with 0 being no threat and 5 being high threat. Insect and disease-related datasets were developed with input from other local and regional entomologists and pathologists. To create the final Threats to Forest Health layer, all seven datasets were weighted equally and combined. The resulting layer was on a scale of 0 -35, because each output cell represented the sum of the cell values (0 -5) at that location for all seven layers. The final layer was then reclassified from 0 -35 to a scale of 0 -5 (0 being no threat, 5 being high threat) using Jenks natural breaks.
References: 
Brown, D.E.,

## Issue: Relative Fire Risk to Communities and Ecosystems

The intent of this geospatial analysis is to:
• Identify where communities, their infrastructure and associated landscapes are at relative risk from wildfires.

## Discussion:

After a review of the previous modeling efforts associated with the 2010 Forest Action Plan, it was determined that these models did not represent risk as accurately as newer modeling efforts. In an effort to simplify the modeling and to reduce the duplicity inherent to naturalresource models, a linear regression model was developed and vetted through the wildfire technical committee. Unlike other models, this model does not establish a probability curve for fire growth or severity, rather it provides a probability of damage in the event of a wildfire.
All of the data was gathered from open, publicly accessible sources so that if others were interested in recreating similar fire-risk models they would be able to use the same source datasets described below.
Data Used:
1. Slope
Slope was chosen as an input layer because of the influence that it has on fire spread as well as post-fire impacts associated with debris flow and landslides. Though not specifically accounted for in this evaluation, slope can also be a limiting factor in land use development.
The source data for this layer came from a 30-meter pixel dataset, created by the IDL GIS staff. IDL utilized the Slope tool in Spatial Analyst (ESRI ARCMap) and setting the output option as a percent allowed for the creation of the necessary data pyramids that were then reclassified into 3 categories 0-10%, 10.00001-20% and greater than 20%. Each of these were then given the respective values of 1, 2 and 3.

## Aspect

Aspect was chosen as an input layer because of its influence on fire spread due to solar heating and the difference in vegetative communities associated with aspect.
The source data for this layer came from a 30-meter pixel dataset, created by IDL GIS staff. The IDL utilized the Aspect tool in Spatial Analyst (ESRI ArcMap) and the data was reclassified into 3 categories; North (0 to 45 degrees and 315 to 360 degrees), East (45 to 135 degrees), South and West (135 to 315 degrees) and Zero (0) for flat (0 degrees). Each of these were then given the respective values of 1, 2, 3 and 0.

## Vegetation

Vegetation is one of the most significant contributors to fire growth, behavior, intensity and severity. Because the Forest Action Plan is focused on forests, the largest assigned valued is given to tree classifications.
For this layer, IDL used the LANDFIRE vegetation re-gap raster
foot_2
 . The vegetation was classified into 6 categories: grass, grass-brush, grass-tree, brush, brush-tree and tree. Each category was respectively assigned values of 1 to 6. All lakes, rock, agriculture and urban areas were assigned a value of zero (0).

## Fire History

Past fire occurrence can serve as a proxy for future occurrence. This layer was a combination of data from the Integrated Reporting of Wildland-Fire Information (IRWIN) 2 and IDLs Fire Report System. The attribute fields contained within the combined data capture recorded fire event dates, name, agency, size, and locations (fire points and polygons) from 1983 to 2017.
For mapping purposes when a cell (30 meter pixel) had a fire event anywhere within it, that cell's event count was increased by 1. Many cells had a zero-count statewide causing a low resolution attributed to lack of polygon data during the time period which resulted in an in accurately representation of fire density within Idaho. To rectify this issue, a fire-frequency (event occurrences) count was completed and rolled up to the state HUC12 watershed polygons to give greater consistency in fire density across landscapes.
The output polygon layer was classified into three categories, using Jenks natural breaks in the data values, and was assigned 1, 2, and 3 from low fire density to high fire density. This polygon layer of fire density was converted to a 30-meter raster file.

## Wildland-Urban Interface (WUI)

Development in Idaho is largely in the wildland-urban interface. This is in part due to population centers growing outwards and historically isolated communities expanding. Human development, which includes buildings, infrastructure and the surrounding landscapes that provide community services (water, recreation, wildlife, etc.) are impacted by wildfire at a higher frequency in Idaho as population growth continues its upward trend. The inclusion of this layer is intended to be used to show impact of wildfire within the wildland-urban interface.
The WUI layer used was composed of the layers originally developed by the USFS and BLM using a geospatial analysis in 2002 3 . Where counties have defined and mapped their WUI as part of their Community Wildfire Protection Plans (CWPPs), these WUI polygons were substituted in place of the USFS or BLM layers
foot_4
 . The WUI data layer cells were assigned a value of 3 if it was inside the WUI polygon and 1 if outside of the WUI polygon. This polygon layer was also converted to a 30-meter raster file.

## Issue Process:

The ESRI ArcMap Raster Calculation tool was used to sum the values of slope, aspect, vegetation, fire history and WUI. The lowest value in this analysis was 3 -1 for aspect, 1 for slope and 1 for WUI. The highest value in this analysis can be 18. To display the data, Jenks natural breaks were used to delineate low to high risk categories.

## Issue: Potential Loss of Canopy to Development and Urbanization

The intent of this geospatial analysis is to:
1. Identify the areas at greatest risk of conversion from forestland to other usesspecifically development. Often, forested areas are highly desirable for home sites or new subdivisions. With this conversion comes a loss of productive forests, increased wildfire risk to property as more homes are "in the woods", and pressure to reduce or eliminate management on adjacent lands. Also important are those areas that may be converted from one housing density to a significantly higher density within developed areas as this may also lead to loss of canopy and the benefits it provides.
In the 2010 version of the Forest Action Plan, Canopy Loss due to Urbanization and Development, and Recreation Pressure were combined issues. Because of a lack of statewide data, the Recreation Pressure component was dropped from the modeling and instead will be addressed as narrative within the strategies document.

## Data used:

1

## . Development Potential

The National Guidance suggested using the "Forests on the Edge" data developed by Issue Process:
The dataset was stratified into 6 classes (low to high risk, 0-5) using Jenks natural breaks in the data.

## Chapter 2 -Key Issues for which Forests Provide Benefit in Idaho Issue: Relative Potential Benefit to Wildlife and Biodiversity

The intent of this geospatial analysis is to:
• Identify the areas of greatest conservation value for wildlife and their habitats and where forest management can enhance these values.

## Discussion:

To identify the areas of greatest conservation value for wildlife and wildlife habitat related to forest resources, it was decided to use the existing Western Association of Fish and Wildlife Agencies (WAFWA) Crucial Habitat Assessment Tool (CHAT). The WAFWA CHAT was developed to bring greater certainty and predictability to planning efforts by establishing a common starting point for discussing the intersection of management and wildlife. CHAT is designed to incorporate wildlife values into land use planning, particularly at large scale. It is a nonregulatory tool and not intended for project-level approval.
The CHAT provides a continuum of 6 habitat categories across Idaho based on a 1 mi 2 hexagon grid. For those areas where forests overlap with the most crucial habitat categories, it can be assumed that forests play a key role in providing wildlife critical habitat and range, threatened, endangered and rare fish and wildlife habitats and important plant communities. Within the context of the full assessment and response strategy, projects proposed within areas of overall high CHAT priority-which include areas identified as high priority for this issue-should consider activities that will enhance the habitat of the plant, fish and wildlife species listed within those areas.

## Data used:

The state wildlife agencies that developed CHAT agreed to common definitions of crucial wildlife habitat and corridors and issued guidelines to help each state prioritize habitat within its boundaries to meet its specific conservation objectives. The West-wide definitions support compatibility and consistency across state boundaries and address certain discrepancies that may exist in identifying habitat and natural features along state borders. This broad-based, collaborative effort across 16 states provides the West-wide crucial habitat data layer derived from important habitat and connectivity input layers.
The CHAT dataset used represents Idaho's contribution to the WAFWA CHAT. It represents an aggregated measure of crucial habitat categories for species and habitats of interest to the western states' fish and wildlife management agencies. Crucial habitat describes places that are expected to contain the resources necessary for continued health of fish and wildlife populations or important ecological systems expected to provide high value for a diversity of fish and wildlife.
Idaho compiled data encompassing several data types and layers of information (Table 
1
), including habitat for species of concern (terrestrial and aquatic), landscape condition (a summary of native and unfragmented habitat which prioritizes large natural areas and connectivity zones between them), wetlands and riparian areas, and habitat for species of economic and recreation importance (terrestrial and aquatic). Relative priorities within each group were aggregated into a final crucial habitat rank.
Idaho's analysis was completed on October 29, 2013, at a resolution of 3 square mile hexagons.
In April 2015, Western Governors transferred full responsibility for CHAT to WAFWA, and the tool was renamed the Western Association of Fish and Wildlife Agencies CHAT. To be consistent with surrounding states' products, Idaho's information was resampled to 1 square mile hexagons using an area-based mean using the same data as provided in 2013.
The dataset used in the Forest Action Plan is the same product that can be downloaded from the WAFWA CHAT website (accessed on 5/13/2020) and except as updated on 5/23/2019 to include a crucial habitat rank for hexagons that intersect tribal lands that were intentionally masked out on the CHAT website.
The crucial habitats dataset was last reviewed and approved as of August 31, 2018. An update to Idaho CHAT is expected by the end of calendar year 2019. In particular, the Species of Concern input layers will be updated with information reflecting the current list of Idaho's Species of Greatest Conservation Need (SGCN) identified in the 2015 Idaho State Wildlife Action Plan, as the current product was based on species in the 2005 Comprehensive Wildlife Conservation Strategy.
The crucial habitat dataset is a landscape-scale, coarse-resolution dataset not intended to establish specific boundaries for site-specific planning, regulation, or acquisition. It is not intended to determine the exact ecological health or condition of any specific location on the ground. The dataset is based on the best available scientific information and is expected to be updated regularly. The crucial habitat rank of a hexagon may change over time as new information is incorporated. The intent of this geospatial analysis is to:
• Identify the areas of greatest need with respect to water quality and quantity, and where forests can have the greatest benefit.

## Discussion:

Rural forests and urban tree canopy have a tremendous value toward good water quality, aquifer recharge, stormwater mitigation and erosion control. Water is, in fact, one of the biggest issues in the west and is important for fish, wildlife and humans (agriculture, horticulture, industry and for drinking water). Forest canopy shades and cools streamsimportant for healthy fish habitat. Leaves of trees intercept rainfall, lowering the impact of rain on soil. Roots systems help break up compacted ground while stabilizing soil, leading to greater groundwater recharge, reduced stormwater runoff and associated contaminant loads, and less erosion.
This issue focuses forest management efforts in the areas in greatest need for improved water quality/quantity-in both rural and urban environments.

## Data used:

Four data layers informed this issue. The Source Water dataset delineation process "establishes the physical area around a well or surface water intake that will become the focal point of a source water assessment. The process includes mapping the boundaries of the zone of contribution (e.g., the surface and subsurface areas contributing water to the well, or surface water intake) into time of travel zones (e.g., zones indicating the number of years necessary for a particle of water to reach a well or surface water intake). The size and shape of the source water assessment area depend on the delineation method used, local hydrogeology, and volume of water pumped from the well or surface water intake." Additional information can be accessed at: Idaho's Source Water Assessment Plan and Source Water Protection in Idaho.
The boundary of the SVRP aquifer was added to the source water delineation to develop a public drinking water layer. This aquifer was added because it is both a sole source for drinking water for more than 500,000 people AND because it has no bedrock cap overlying it. Due to the latter attribute, it is the only designated Sensitive Resource aquifer in Idaho. This means it receives the highest level of protection, as activities over the aquifer can have a direct and relatively quick impact on water quality within the aquifer. Subwatersheds (Hydrologic Unit Code-or HUC-6th level) were flagged if a part of the aquifer or an area of source water delineation was within them. If the watershed was flagged it was classified with a value of 1. If not, it received a value of 0 indicating it does not contain either a part of the aquifer or an area of source water delineation.

## Priority Watersheds

Priority watersheds are those containing an impaired stream or lake. Subwatersheds that contain an impaired lake or stream were originally classified with a value of 5. Subwatersheds that did not contain an impaired stream or lake are classified with a value of 0. This was changed for draft two such that any sub-watershed in which there is an impaired stream or lake was given a value of one. Those which did not were given a value of 0.
Source data is the 303(d) list of all impaired waters in the state, per Section 303(d) of the Clean Water Act. These data are part of the 2016 303d/305b Integrated Report, collected and maintained by the Idaho Department of Environmental Quality.

## Impervious Surfaces

Impervious surfaces came from the National Land Cover Database (NLCD) 2011 imperviousness layer, produced through a cooperative project conducted by the Multi-Resolution Land Characteristics (MRLC) Consortium, a partnership of federal agencies (www.mrlc.gov). For a detailed definition and discussion on MRLC and the NLCD 2001 products, refer to The NLCD_2011_impervious layer was used where the percent of imperviousness of a 30 meter cell was converted to the impervious area and summed to a 6 th order HUC. Any HUC that had 2% or greater impervious surfaces was counted and given a value of 1. All others received a value of 0.

## Areas with Total Maximum Daily Load (TMDL) Implementation Plans

Areas with TMDLs were derived from the 2016 303(d)-305(b) integrated water quality report by the Idaho Department of Environmental Quality. All subwatersheds in which a TMDL plan was located received a value of 1, all others were given a value of 0.
Analysis Process: Using ESRI's spatial analyst raster calculator, all four datasets are added together giving a range of cell values of 0 to 4. The zero was dropped and the other scores were reclassified with scores of 2 -5.

## Issue: Relative Potential Benefit to Air Quality from Forests and Canopy

The intent of this geospatial analysis is to:
• Identify are the areas of greatest need with respect to air quality and where forests can have the greatest benefit.

## Discussion:

Air quality is impacted, both negatively and beneficially, by forests. Wildfires mobilize a great deal of particulates (from smoke) and carbon into the air. Communities within the airsheds of these fires suffer poorer air quality and commensurate health effects. Certain tree species are also net producers of biogenic volatile organic compounds (BVOCs), which can exacerbate ozone production, especially in urban areas. However, healthy forest canopies can also absorb and filter particulates and pollutants out of the air, improving air quality. Likewise, trees sequester carbon and release oxygen-important for mitigating climate change and for human and animal health. Since temperature is a catalyst for production of volatile organic compounds (VOCs), the cooling effect of tree canopies in urban areas can lower their production. Sources of VOCs include any petroleum product that breaks down (asphalt, plastics, etc.) and parked vehicles (evaporation of fuel in gas tanks). By also cooling buildings and thereby lowering energy use, urban tree canopy can also reduce energy demand. If this energy is produced from the burning of fossil fuels, increased urban canopy cover can result in additional emissions reductions, including carbon.
It makes good sense to manage forests within urban airsheds to increase forest health and fire resiliency, thereby reducing negative impacts on public health. Likewise, increasing canopy cover and forest management within these areas also has a positive public health impact by helping reduce the causes of pollution while filtering out other pollutants and particulates.

## Data used:

There were three principal datasets used in this analysis.

## Non-attainment zones

Non-attainment areas were obtained from the Idaho Department of Environmental Quality. These are areas within Idaho where air pollution levels persistently exceed the national ambient air quality standards (NAAQS), designated "nonattainment." EPA considers any geographic area that meets or has pollutant levels below the NAAQS an attainment area. Under ideal circumstances, all of Idaho would be classified as "attainment." Areas with persistent high pollutant levels are designated as nonattainment areas, meaning these areas have violated federal health-based standards for outdoor air pollution. Each nonattainment area is declared for a specific pollutant, meaning the same area could be "attainment" for one pollutant, but "nonattainment" for a different pollutant. Nonattainment areas for different pollutants may overlap each other or share common boundaries.
This layer was used to select all subwatersheds (Hydrologic Unit Code-or HUC-6th level) that contained non-attainment areas. Subwatersheds that contained a nonattainment area were given a value of 5 and subwatersheds that did not contain a non-attainment area were given a value of 0.

## Smoke impact zones

These data were provided by the Idaho/Montana Airshed Group. Air Impact Zones are areas where smoke from wildfires is likely to be a problem because of local topography, meteorology, and areas with existing air quality problems that smoke from wildfires will exacerbate. Increasing canopy in these areas will help mitigate the impacts of particulates from smoke, improving air quality and public health.

## Canopy cover relative to impervious surfaces

Data used were two products of the National Land Cover Dataset (NLCD) 2011-Impervious surfaces and Tree Canopy. These data were produced through a cooperative project conducted by the Multi-Resolution Land Characteristics (MRLC) Consortium, a partnership of federal agencies (see www.mrlc.gov). A detailed definition and discussion on MRLC and the NLCD 2011 products can be found at these links: Land cover, urban imperviousness.
As noted in the issue discussion above, impervious surfaces have a negative impact on air quality for a variety of reasons. Research has demonstrated the significant positive impact of tree cover in such areas by filtering particulates, absorbing CO2 and other pollutants, and lowering ambient air temperature while reducing the impact of ultraviolet radiation. With these data, we are identifying areas that have a high percentage of impervious surfaces but lack significant canopy cover in the surrounding area. Identified then, are areas where additional canopy can have a substantial impact in mitigating poorer air quality to which impervious surfaces contribute.
The NLCD_2011_impervious layer was classified on the percent imperviousness value by Jenks natural breaks into 5 classes and weighted as follows: Then, the Impervious surface weight was lowered by the mean percent canopy cover weight.

## Class

## Analysis Process:

The map is created additively from areas that did not attain air quality standards, are within smoke impact zones, and have a high percentage of impervious surfaces with low percentages of surrounding canopy cover. The additive result was reclassified into 5 classes based on Jenks natural breaks giving resulting values of 0 -5.

## Issue: Relative Potential Benefit to Sustainable Forest-Based Wood Products Markets

The intent of this geospatial analysis is to:
• Identify the forested areas most beneficial to existing sawmill, biomass and pulp facilities and associated economic benefits.

## Discussion:

In many areas of the state, communities are economically and culturally dependent upon forestlands. The benefits and products of forestlands include timber, biomass, recreation, hunting/fishing and ecosystem services. The Idaho Lands Resource Coordinating Council (ILRCC) identified the loss of forest infrastructure (mills, markets, etc.) as a key issue (threat to forests and local economies). This threat is greater than simply loss in jobs or income. When mills shut down or markets for particular forest products go away, active forest management becomes more expensive which can lead to an increase in forest insect and disease problems, fire risk, and a decline in overall forest health.
Rather than seeking to resurrect recently shuttered markets and infrastructure, the ILRCC favor an approach that focuses on existing markets and mills which currently benefit Idaho's local economies. The ILRCC believes this best enhances the economic potential of forests as a benefit, and positions Idaho's forests and forest industry best for continued success in a global economy.
The datasets used in this analysis are the locations of current sawmill, pulp, and biomass facilities. These were combined with road network data and the proximity to mills within these markets.

## Data used:

## Sawlog Facilities Travel Distance

This layer includes known mill locations and the time and cost needed to haul timber to them. Procurement zones for existing sawmill facilities uses existing roads and speed limits, assumes an average delivered log price of $356.58/MBF for all species across all regions of Idaho, an average logging cost of $135/MBF between groundbased and cable-based harvest systems , and an average of 4.5 MBF/truck. The net revenue per truck was divided by $100/hr. transportation cost to develop a travel budget and again by 2 to account for roundtrip travel. This provides a value for a load of logs in hours and the break-even point for net revenue.

## Pulp Facilities Travel Distance

This layer includes known pulpwood-using facilities and the time and cost needed to haul pulp logs to them. Procurement zones for existing pulpwood-using facilities uses existing roads and speed limits, assumes an average delivered price of $75/bone dry ton (BDT) for pulp logs across all regions of Idaho, an average harvest cost of $27/BDT and an average of 19 BDT/truck. The net revenue per truck was divided by $100/hr. transportation cost to develop a travel budget and again by 2 to account for roundtrip travel. This provides a value for a load of pulpwood in hours and the break-even point for net revenue.

## Woody Biomass Facilities Travel Distance

This layer includes known biomass facilities and the time and cost needed to haul chips to them. Procurement zones for existing biomass facilities uses existing roads and speed limits, assumes an average delivered price of $50/BDT for chips across all regions of Idaho, an average harvest cost of $27/BDT and an average of 19 BDT/truck. The net revenue per truck was divided by $100/hr. transportation cost to develop a travel budget and again by 2 to account for roundtrip travel. This provides a value for a load of pulp in hours and the break-even point for net revenue.

## Analysis Process:

The composite map is the combination of sawmill, pulp, biomass layers equally weighted. Only these layers are used in the final assessment map.

## Economic Contribution:

Additionally, the economic contribution of Idaho's forest industry is represented below. While this data was not used in the final assessment, this data represents associated economic benefits related to wood products in Idaho.
County Economic Multipliers: The economic contribution of Idaho's forestry industry includes both the primary products manufacturers such as sawmills, pulp, and paper mills and the secondary forest product manufacturers such as furniture and paper products manufacturing industry using the end products from primary forest products manufacturers.
Multipliers based on the economic impact analysis software IMPLAN were used to express the economic contributions of the forest products industry. Multipliers are ratios of direct contribution (money invested in a forest products facility/sawmill to operate a business) + supporting contributions (money generated from e.g. logging or trucking, restaurants that feed workers) divided by the direct contribution. Multipliers are developed for each county.
The output multiplier describes the total output generated as a result of a one dollar investment in sawmill industry. If an output multiplier is 2.25, for every additional dollar of production in the sawmill industry, $2.25 of activity is generated in the local economy: the original dollar and an additional $1.25.
The labor income multiplier describes the amount of labor income generated as a result of one dollar of labor income in the forest products industry. A labor income multiplier of 2.2 indicates that for every dollar of direct labor income in the forest products industry generates another additional $1.20 of labor income in the local economy.
The employment multiplier is a metric of how many indirect jobs are created from adding an additional job in the forest products sector. An employment multiplier of 2.33 can be interpreted as every direct job creates 2.33 jobs in the total economy; the direct job and another 1.33 additional jobs.
For this analysis, the IMPLAN employment, labor income and output multipliers were used. It is important to recognize that while multipliers measure how much impact a single dollar or employment creates in a county they do not provide information on the magnitude of that impact.

## Citation:

IMPLAN Group LLC. IMPLAN System (data and software). 16905 Northcross Dr., Suite 120, Huntersville, NC 28078. www.IMPLAN.com Washington, Chad. Identifying Priority Landscape Areas in Idaho for Funding Assistance Programs. M.S. Thesis. University of Idaho.
The 25 unique cell values represent a combination of threat values and benefit values, and are grouped into four categories of priority. The lowest priority areas are those that are low threat and low benefit. The highest priority are those areas which are both high threat and high benefit. From this point, stakeholders can make decisions on the relative priority of various combinations of low to high threats coupled with combinations of low to high benefit. The example above is one possible way cells can be grouped into one of four categories of priority. Priority areas in which to focus resources and management efforts will be those corresponding heat-map cells colored red, orange and potentially yellow.

## Final Idaho Forest Action Plan Resource Assessment Map

As explained in the Methodology section on page 43, each of the subwatersheds carries with it both a benefits score (1 through 5) and a threats score (1 through 5). A subwatershed, then, can have one of 25 combinations of these threats and benefits scores. These scores were reclassified from 1-lowest risk, lowest benefit to 25-highest risk, highest benefit. It must be stressed that these are relative values using the best available data for the identified issues. An area identified as lowest risk does not mean there are no risks, or even that risks are not significant. Rather, it means that the data and methodology used in the assessment indicates that area has lower risks relative to other areas in the state. The purpose of the assessment is not that all areas are identified as high priority, but that it serves as a tool to help us better understand where we should consider targeting limited resources, focused on multiple specific issues to affect change on a landscape scale. This approach differs from the historic approach of providing assistance and investing resources based on requests, which may or may not be in areas of greatest need or benefit.
The matrix approach, yielding the 25 unique values (shown in the map on page 50), allows some manipulation of the results. Each color in the matrix has a three-digit number. The first digit represents the potential benefit, and the third digit represents the threat (i.e., 105 is low benefit-high threat, where 501 is high benefit-low threat). Areas that are high benefit and high threat, for instance, will be a higher priority than areas of low benefit and low threat. Taking this a step further, stakeholders agree that areas which have high benefit but low threats are still important for project work, as maintaining those benefits is important. On the other hand, areas that are high threat, but low benefit are not as critical. If those should succumb to threats, the loss isn't as high as areas that have greater benefit.
As we consider the results, it is our intent that the proposed activities and operations described in the Resource Strategy will focus on areas of Very High (red), High (orange) and, in some cases Moderate-High (yellow) priority categories. Areas that are green or blue will not be considered high-priority unless by adjacency to the other areas, projects make sense in these areas, or where unique situations exist that were not adequately captured by the available data. These will be described in the Response Strategy.
From this map, another spatial analysis was developed denoting Priority Landscape Areas (page 51). These are generalized areas in which goals and strategies will be developed. In addition to information derived from the geospatial assessment-trends, conditions, issues and opportunities for collaboration will be identified locally and become part of the overall Forest Action Plan Resource Strategy. Boundaries on the Priority Landscape Areas map are meant to be pliable and adjustable to fit developing strategies/actions. The Forest Action Plan Resource Strategies are meant to be dynamic and modified as conditions change, new information is obtained and work is completed.
The map on page 50 shows the results of combining threats and benefits as defined by the matrix. When development of the Priority Landscape Areas (PLAs) started, northern Idaho was rated high while the southern portion of the state had few if any watersheds that could be used to identify PLAs. Further review of the state analysis revealed that "hotter" colors (reds and oranges) were concentrated in the north primarily due to higher concentration of industrial forestland, insect and disease issues, and projected timber markets. The state was divided into northern and southern sections using the Salmon River as the dividing boundary. This allowed for the statistical comparison of threats and benefits values within each area to be done respective to only the northern or southern section of the state-allowing southern-Idaho issues to fall into "red" and "orange "prioritized categories irrespective of northern Idaho's overwhelming higher threats and benefits values. After completing the analysis, discernable watersheds of higher importance in both the north and the south became evident. The analysis was performed using the Forest Service regions boundary (Region 1-north of the Salmon River and Region 2-south of the river).
After presenting the results to the ILRCC advisory committee and getting approval, the parts were combined to start the next phase of analysis to develop the PLAs. Some of the PLAs have portions that extend into other states. For example, the Idaho Panhandle PLA includes portions of the Kaniksu National Forest in eastern Washington and western Montana as well as a large portion of the Spokane Valley-Rathdrum Prairie aquifer. The Bitterroot, Salmon-Challis and Teton-Yellowstone PLAs also have acreage in adjacent states. The threats and benefits (fire, forest health, wildlife, etc.) in these cross-border areas are similar, as are the management strategies.

## Appendices

Appendix A -Sub-Issue maps 

[FIGURE: Acknowledgements ............................................................................................................... Introduction Background and Purpose ............................................................................................................ Chapter 1 -Key Issues Which Threaten Forests in Idaho Issue: Relative Threats to Forest Health ..................................................................................... Issue: Relative Fire Risk to Communities and Ecosystems ........................................................ Issue: Potential Loss of Canopy to Development and Urbanization ......................................... Chapter 2 -Key Issues for which Forests Provide Benefit in Idaho Issue: Relative Potential Benefit to Wildlife and Biodiversity ................................................... Issue: Relative Potential Benefit to Water Quality and Quantity from Forests and Canopy ... Issue: Relative Potential Benefit to Air Quality from Forests and Canopy ............................... Issue: Relative Potential Benefit to Sustainable Forest-Based Wood Products Markets ......... Chapter 3 -Final Maps Methodology for Developing Final Assessment Priority Maps ................................................. Appendix A -Sub-Issue maps ................................................................................................... For additional information, visit the Idaho Forest Action Plan web page.]

[FIGURE: 1 model: The NIDRM published root disease model for northern Idaho (Region 1) (Krist et al., 2014) was used in this analysis to represent root disease risk in the Idaho panhandle.]

[FIGURE: were used as a baseline, and projected land cover rasters for 2030, 2060, and 2090 developed by Rehfeldt et al. 2006. a. Frequency of landcover changes: A raster was created comparing the Brown et al., 1998 land cover raster with the predicted land cover in 2030, 2060 and 2090. Cells were classified from 0 -3 based on the number of changes in land cover (0= no landcover type change, to 3= three landcover type changes throughout the forecasting period). Higher numbers reflect greater climate change stress to forests.]

[FIGURE: Dr. David Theobald, Colorado State University. These data use the SERGoM v3 model, described in the research paper Watersheds at Risk to Increased Impervious Surface Cover in the Conterminous United States, to predict housing density in tenyear increments from 2000 to 2030. By subtracting 2000 housing densities from 2030 predicted housing densities, we can express the potential areas of new development. The Theobald data broke out housing density into ten classes; we modified these to eight classes as follows: 1. No Development or >80 acres per unit (rural) 2. 40-80 acres per unit (rural 1/built up (commercial, industrial, transportation) When considering the movement from one density class to another, we wanted to make some judgment about the relative impact of that change. IDL Staff developed the following matrix showing values from 0 (no change) and 1 (low impact change) to 5 (highest impact change) and classified the data accordingly. The numbers in the colored boxes represent the housing density classes shown above. So, movement from density class 2 (one unit per 40 -80 acres) in 2000 to density class 4 (10-20 acres per unit) by 2030 is considered a very high impact (value of five), A movement from density class 2 (one unit per 40 -80 acres) in 2000 to density class 3 (one unit per 20-40) acres in 2030, on the other hand, is considered a high change (value of 4). --= no or negative change 1 = low impact change 2 = low-moderate impact change 3 = moderate impact change 4 = high-moderate impact change 5 = high impact change]

[FIGURE: These are: 1. Public Drinking Water comprised of: a. Source water delineations from Idaho Department of Environmental Quality's Source Water Protection program. (Note that these data are used with permission and not available for public release) b. Spokane Valley-Rathdrum Prairie (SVRP) Aquifer boundary for the Idaho portion of the aquifer from Idaho Department of Water Resources.]

[FIGURE: Issue: Potential Benefit to Water Quality and Quantity o Map of Public Drinking Water Sources ................................................................. o Map of Priority Watersheds (303d impaired watersheds) ................................... o Map of areas with Total Maximum Daily Load (TMDL) Plans ............................... o Impervious Surfaces Map ..................................................................................... • Issue: Potential Benefit to Air Quality from Forests and Canopy o Map of Non-Attainment Areas ............................................................................. o Map of Smoke Impact Zones ................................................................................ o Map of Relative Canopy Cover to Impervious Surfaces ....................................... • Issue: Potential Benefit to Sustainable Forest-Based Markets (Models are proprietary and used in the assessment with the permission of the Idaho Department of Lands.) Map of Saw Log Haul Distance/Time. ................................................................... o Map of Pulp Log Haul Distance/Time. .................................................................. o Map of Woody Biomass Haul Distance/Time. ......................................................]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[TABLE: Table of Contents: ]

[TABLE]
* • Ara Andrea -Idaho Department of Lands, Chief, Bureau of Forestry Assistance • Norris Boothe -Coeur d'Alene Tribe • Gina Davis -USDA Forest Service, Forest Health Protection -Region 1 Idaho Farm Bureau • Ed Koch -Idaho Forest Owners Association • Tim Maguire -Ecosystem Science Foundation • Robyn Miller -The Nature Conservancy • Andrew Mock -Idaho Department of Lands GIS Analyst Sr. • Jennifer Russell -Idaho Department of Lands; Grants Coordinator • Chris Schnepf -University of Idaho Extension Forestry • Knute Sandahl -Idaho State Fire Marshal • Kirk Sehlmeyer -Natural Resources Conservation Service; Forester • Greg Servheen -Idaho Department of Fish and Game (Retired) • David Stephenson -Idaho Department of Lands; Urban Interface/Planning Program Manager (Retired) • Bob Unnasch -The Nature Conservancy • Janet Valle -USDA-FS State & Private Forestry, Regions 1 & 4 • Mike Wolcott -Inland Forest Management Special thanks to our GIS Staff for all their help and expertise-Tom Kearns, Andrew Mock and Kent Allen.*

| Project Leads: | Tyre Holfeltz & Tom Eckberg |
| --- | --- |

[/TABLE]

[TABLE]
*Key Issues Which Threaten Forests in Idaho Issue: Relative Threats to Forest Health *

| Chapter 1 - |  |
| --- | --- |
|  | • Coeur d'Alene Tribe |
| • Idaho Department of Fish & Game | • Nez Perce Tribe |
| • Idaho Department of Parks & Recreation | • The Nature Conservancy |
| • Idaho Lands Resource Coordinating Council | • University of Idaho |
| • Idaho Forest Owners Association | • USDA Forest Service |
| • USDI Bureau of Land Management | • USDA Natural Resource Conservation Service |

[/TABLE]

[TABLE]
* meters. Each raster was clipped to Idaho and converted to the IDTM83 projection. Basal areas were reclassified into seven classes:*

| Host Basal Area (ft 2 /acre) Assigned Class |  |
| --- | --- |
| 0 | 1 |
| 1-50 | 2 |
| 51-100 | 3 |
| 101-150 | 4 |
| 151-200 | 5 |
| 201-250 | 6 |
| 251-300 | 7 |

[/TABLE]

[TABLE]
* Data were clipped to Idaho and converted to the IDTM 83 projection. Basal area values were reclassified into 10 classes, with increasing values associated with higher stand density:*

| Total Basal Area (ft 2 /acre) Assigned Class |  |
| --- | --- |
| 0 | 1 |
| 1-50 | 2 |
| 51-100 | 3 |
| 101-150 | 4 |
| 151-200 | 5 |
| 201-250 | 6 |
| 251-300 | 7 |
| 300-350 | 8 |
| 350-400 | 9 |
| >400 ft 2 | 10 |
|  | These calculations yielded four output rasters (MPB |
| risk, SB risk, WPB risk, DFB risk), showing the risk associated with each bark |  |
| beetle species. |  |

[/TABLE]

[TABLE]
*Tussock Moth *

| Douglas-fir tussock moth (Orgyia pseudotsugata) (DFTM) is a native defoliator of |
| --- |
| Douglas-fir and true firs that is capable of killing trees if outbreaks cause multiple, |
| consecutive years of heavy defoliation. Populations tend to be cyclic, building to |
| significant levels in predictable locations every 8-12 years, then crashing after a few |
| years of activity. Southern Idaho experienced an outbreak in 2018 and 2019 in |
| vicinity of the Boise and Payette National Forests, with heavy defoliation occurring in |
| 2019. Populations in northern Idaho are currently building, with outbreaks expected |
| in 2020 or 2021. Annual USDA Forest Service aerial detection survey digital data |
| from 1996 -2018 was used in the analysis of DFTM risk, along with historical analog |
| data, sporadically dating back to the 1940s, that was digitized by USDA Forest |
| Service, Forest Health Protection personnel. Host BA data for Douglas-fir, grand fir, |
| and subalpine fir from the FHAAST dataset were also used in the model. |
| Data layers: |

[/TABLE]

[TABLE]
*Table 1 . Data and data definitions compiled for WAFWA Crucial Habitat Assessment Tool (CHAT) representation of Idaho crucial habitats 1-6 at 1 mi 2 hexagon scale. Species of Concern: Species of state and/or national conservation importance, including those vulnerable to extinction or those undergoing regional decline or other species requiring special management attention. Idaho defined their Species of Concern list using State Wildlife Action Plan "Species of Greatest Conservation Need" and NatureServe conservation status rankings, and other criteria in some cases. Individual species are not depicted but the resources section of this site contains information specific to the Greater Sage Grouse and the Lesser Prairie Chicken.Landscape Condition: A measure of land cover impacted by human activities. WGA Landscape Integrity Workgroup used a NatureServe landscape condition model to identify Large Intact Blocks and Important Connectivity Zones.Large Natural Areas: Large Intact Blocks or other dataset that identifies large areas of native habitat that are relatively intact or have low levels of anthropogenic impact.Natural Vegetation Communities: Dataset mapping natural vegetation communities of conservation concern, which may include clusters or patches of a natural community. States may have their own datasets mapping natural communities, or may have used the WGA Landscape Integrity Workgroups' Ecological Systems of Concern map.*

| Riparian and Wetland Habitat Distribution: Areas that represent unique and/or sensitive |
| --- |
| environments and function to support animal and plant diversity with respect to wildlife objectives |
| and connectivity. |
| Species of Economic and/or Recreational Importance: These may include game or sportfish species |
| especially if habitat needs are not already covered by mapping "Species of Concern". |
| Aquatic Species of Economic and/or Recreational Importance: Sportfish, especially if habitat needs |
| are not already covered by mapping "Species of Concern". |

[/TABLE]

[TABLE: and Quantity from Forests and Canopy ]

[TABLE]
* % Impervious Weight 0................ 0 -6 .......................... 0 1................ 7 -17 ........................ 1 2................ 18 -30 ...................... 2 3................ 31 -46 ...................... 3 4................ 47 -65 ...................... 4 5................ 66 -100 .................... 5 The NLCD_2011_canopy layer was classified on the percent canopy cover value. A neighborhood mean canopy cover was created from the canopy cover data by taking the mean value of the 25 (5 by 5) neighboring cells for every cell. The mean canopy cover value is a measure of the canopy cover surrounding impervious areas. The mean canopy cover was grouped by Jenks natural breaks into 5 classes and weighted as follows: -17.431 ....................... 0 2........... 17.432 -38.349 .............. 1 3........... 38.50 -59.267 ................ 1 4........... 59.268 -78.690 .............. 2 5........... 78.691 -100 ................... 3*

| Class | Mean % Canopy | Weight |
| --- | --- | --- |
| 1........... 0 |  |  |

[/TABLE]

[TABLE: Table of Contents: • Issue: Forest Health Risks o Bark Beetle Risk Map ............................................................................................ o Balsam Woolly Adelgid Risk Map. ......................................................................... o Douglas-fir Tussock Moth Risk Map ..................................................................... o Root Disease Risk Map. ......................................................................................... o White Pine Blister Rust Map ................................................................................. o Terrestrial Noxious Weeds Risk Map .................................................................... o Climate Change Risk Map ..................................................................................... • Issue]
[TABLE: : Risk to Communities and Ecosystems from Uncharacteristic Wildland Fire o Wildland Urban Interface Map ............................................................................. o Idaho Vegetation Map ..........................................................................................]
This page is intentionally blank
Return to T.O.C.
LANDFIRE, 
2016, Existing Vegetation Type Layer, LANDFIRE 2.0.0, U.S. Department of Interior, Geological Survey. Accessed 6 December 2017 at http://landfire.cr.usgs.gov/viewer/. 2 IRWIN, 2019, Wildland Fire Locations, IRWIN Version 1, National Wildfire Coordinating Group, Accessed 5 November 2019 at https://www.nwcg.gov/ 3 Data Developed for and in behalf of the Idaho Wildfire Working Group. Layers were accessed from the IDL GIS network drives.
Data Developed by the IDL in cooperation with County Wildfire Working Groups. Layers are house within the IDL GIS network drives.

## Acknowledgements

## Chapter 3 -Final Maps Methodology for Developing Final Assessment Priority Maps Threats/Benefits Matrix

The key forestry related issues identified by the Assessment stakeholders and further refined by the Core Assessment Team are categorized into two groups. The first included those issues which threaten forests-Forest Health Threats, Wildland Fire Risk to Communities and Ecosystems, and Potential Loss of Forests and Canopy from Development. The second major group includes those issues for which forests and trees provide benefit-Wildlife and Biodiversity, Water Quality and Quantity, Air Quality, and Sustainable Forest-Based Markets. Each of these issues is considered equal and all have scores that range from 0 through 5, from no threat to high threat, and from no benefit to high benefit.
The values for each 30-meter cell in each of the "Threats" issues are added together. The scores for all cells are then stratified into five classes using Jenks natural breaks in the data values. This composite-threats map identifies the least threatened through the most threatened per the issues and sub-issues examined in the assessment.
The same is done for the "Benefits" issues to develop a composite-benefits map. This map shows areas with the least benefit through those with the greatest benefits as identified in the issues and sub-issues used in the assessment.
The Final Priority Map is developed by adding the composite threats data scores to the composite benefits map. This is done is such a way that 25 unique values are calculated, resulting in a five by five matrix. The cells were assigned a 3-digit number from 101 to 505, with the first digit denoting relative benefit, and the third digit representing relative threat. Thus, the cell value of 105 indicates low benefit (1) and high threat (5), whereas the cell value of 501 indicates high benefit (5) and low threat (1).


===== DOCUMENT PART: ID_FAP-S_2020.pdf =====

## Table of Contents: Acknowledgments

We greatly appreciate the support and assistance provided by the Idaho Lands Resource Coordination Council (ILRCC) who met regularly to inform, discuss, and guide this process; the members of the Idaho Forest Action Plan Resource Strategy Core Team who rolled up their sleeves and helped identify goals and strategies; and the many folks who gave us helpful and constructive comments.

## Members of the Strategy Team:

• Joe Adamski -USDOI, Bureau of Land Management 

## Introduction Background and Purpose

Developed collaboratively, first in 2010 and revised in 2015, with many different agencies and organizations, Idaho's Forest Action Plan -herein referred to as the Forest Action Plan or FAP -is a key element in the redesign of the USDA Forest Service's State and Private Forestry (S&PF) Branch; a requirement within the 2008 Farm Bill for states receiving funding through the US Forest Service for S&PF programs. The US Forest Service provides funding and other support to states for programs to improve the health, productivity, benefits, and extent of state, private, and urban forests. Programs supported by this funding-including Forest Health, State Fire Assistance, Rural Fire Capacity, Forest Stewardship, Urban and Community Forestry, Conservation Education, and Forest Legacy-are referred to as S&PF Programs. The FAP's purpose is to ensure that federal and state resources focus on landscape areas with the greatest opportunity to address shared priorities and achieve measurable outcomes.
A broad group of stakeholders identified threats to and benefits from forest resources that form the foundation of the Assessment. The assessment provides a geospatial analysis of conditions and trends for all forested lands in Idaho. Using the Assessment and local/regional factors, Priority Landscapes Areas (PLAs) in urban and rural forested landscapes were delineated. The PLAs are used by Idaho Department of Lands (IDL) as the areas where S&PF programs are focused. This FAP Strategy document provides broad strategies to protect, restore and enhance forest resources in priority landscapes by addressing the issues identified in the assessment. A primary purpose of the Strategy document is to guide S&PF investments in Idaho to ensure that resources are focused on landscape areas with the greatest opportunity to address shared priorities and achieve measurable outcomes.
A parallel purpose is to help landowners and land managers in Idaho better recognize and support opportunities where working together and leveraging limited resources can address multiple critical issues of statewide importance in the areas where doing so will have the greatest impact. Stakeholders can use this plan to support requests and proposals for resources necessary to implement strategies and to develop local and statewide collaborative frameworks.

## It is important to recognize that the FAP does not replace existing strategic or management plans for any agency, organization or individual, nor is it implied that any lands not included in a Priority Landscape Area (PLA) or the listed strategies are unimportant. The plan contains large-scale strategies not intended to identify all the issues or actions any land manager may feel are most important on the lands they manage. Rather, they identify opportunities for willing partners to align their plans, leverage resources, and work together within the PLAs and per the strategies to gain the greatest value from limited resources in areas that contain multiple high-priority issues of statewide importance.

## Idaho Lands Resource Coordinating Council (ILRCC)

In late 2011, the three program-specific groups advisory to the Idaho Department of Lands 
1
 were dissolved, and the ILRCC was created as a single S&PF advisory group, integrating all S&PF programs and focusing on addressing the critical issues identified in the FAP. This change was per the recommendation of an Oversight Group, comprised of 2-3 members of each of the three advisory groups and IDL staff, leading to the implementation of a key strategy with the 2010 document.
Prior to making this change, IDL consulted with and received approval from USDA Forest Service S&PF leadership in Regions 1 and 4 as well as the Washington Office. ILRCC will meet legal requirements outlined in the Cooperative Forestry Act, the most current Farm Bill, and S&PF Program requirements. This structure will help Idaho achieve the principles of S&PF Redesign; addressing Idaho's most critical forestry related issues through an integrated suite of S&PF programs at a scale where significant positive changes are realized. A white paper describing the genesis of the IRLCC and its function is located in Appendix F, starting on page 79.

## Forest Action Plan: Resource Assessment

The Idaho Resource Assessment -a geospatial analysis -identifies seven main issues affecting Idaho forestlands (threats and potential benefits). Threats to forests include wildfire, forest health decline, and development pressure. Potential benefits include sustainable wood-based forest resource markets, water quality & quantity, air quality, and wildlife habitat & biodiversity. Statewide data and local knowledge identified areas in Idaho where these threats and benefits pointed to the highest need for investment and work. These areas of multiple high priority concerns and potential benefits are designated as PLAs and include urban, rural, and wildland urban-interface (WUI) lands.
Note that the assessment utilized the best available statewide data. Because the assessment is statewide in scale, it does not identify every area in which an issue may exist. Local geospatial data may present a different characterization of the issues.
A full Idaho FAP Resource Assessment report-including detailed descriptions of each issue, data used, models used for each issue, issue maps, a description of the final methodology and assessment maps, and the maps developed for each of the sub-issues and issues-can be found on the Idaho FAP website at 
https://www.idl.idaho.gov/forestry/forest-action-plan/
.
Stakeholders can also use the individual issue maps from the assessment to identify where a particular issue or issues are highest priority, and to inform and support specific strategies, resources or actions necessary to address them.

## Forest Action Plan: Resource Strategy

The FAP Resource Strategy is a long-term, comprehensive, coordinated strategy for investing state, federal, and leveraged partner resources. It addresses the issues and PLAs identified in the Resource Assessment. The Idaho FAP is statewide in scope. It is not a site-specific plan.
The Idaho FAP will help provide focus to landowners, agencies, collaborative groups, and partnership efforts in identifying projects and activities to reduce threats to and increase the benefits from Idaho's forestlands. From "Main Street to mountaintop", focusing work in the priority areas allows leveraging of funds and coordination across ownerships as a highly effective way to address the most critical forest resource issues in Idaho at a scale where significant, positive changes can be realized.

## Process

The Idaho Department of Lands (IDL) led the effort to develop a comprehensive resource assessment and accompanying FAP through a collaborative process involving representatives from federal and state agencies, counties, non-governmental organizations, S&PF program advisory groups, tribes, interest groups, and private citizens. A core team of the ILRCC members and technical experts convened to review and update the Assessment. The Assessment was presented to the full committee (ILRCC) for consideration where recommendations were given and incorporated where appropriate. The Goals and Strategies from the 2015 revision were also reviewed by ILRCC and updates were made based on feedback and changes to the Assessment.
It is imperative to recognize that the FAP is an iterative document and a dynamic process. Resources and priorities evolve as new information becomes available and conditions in Idaho's forests change. This document will be updated periodically to reflect adjustments and remain relevant and useful, and full FAP updates, including the assessment and strategy development, will be completed at ten-year intervals. • Additional definitions added to the glossary (Appendix A) 

## Summary of changes in the May 2012 revision

## Summary of changes in the September 2015 revision

## Summary of Changes in the June 2020 update

• Changes were made in the assessment modeling (Forest Economics, Wildfire, Forest Health and Wildlife), that led to changes in the Strategies and Goals. Specifically, recreation data was not available at a statewide scale so the impact of recreation is now captured in narrative form. Fire modeling was simplified to probability of damage, while Forest Health incorporated additional data about current and future insect threats not previously available and used a statewide climate change model to replace the previously used species change modeling. For Wildlife the State Wildlife Action Plan was completely redone by Idaho Department of Fish and Game, which provided a more robust set of data than was used in the forest assessment modeling.
• Shared Stewardship is a national initiative intended to increase the pace and scale of forest management throughout the country. As part the initiative a modeling exercise was completed in Idaho by USFS researchers. This modeling and that completed within the Forest Action Plan Assessment were used to identify two priority landscapes. Additional details about Idaho's Shared Stewardship can be found in Appendix I.
• The 2015 chapter order was changed for the 2020 revision, providing for a better flow of the document. The number of goals was reduced from six to five because of redundant goal descriptions. Additionally, the specific issue and strategy details associated with each PLA were removed in chapter 5 in favor of using the tables now found at the end of chapter 3. All changes were approved by ILRCC after presenting the changes for consideration and discussion.
• Due to policy changes within the Forest Service, Focal Areas had to be identified where the Forest Stewardship Program would focus the expenditure of federal grant funds. Additional details about the process used to identify those areas can be found in Appendix J. 

## Return to

## State and Private Forestry Programs

## Forest Stewardship Program

The purpose of the Forest Stewardship Program is to promote the long-term stewardship of nonindustrial private forestlands by assisting landowners in more actively managing their forest and related resources. In Idaho, the IDL administers this program collaboratively with state and private partners. The Idaho Forest Stewardship Program provides assistance to owners of forests where good stewardship, including agroforestry, will enhance and sustain the long-term productivity of multiple forest resources. Special attention is given to landowners in the early stages of managing their land using multi-resource stewardship principles. The program provides landowners with the professional planning and technical assistance they need to keep their land in a productive and healthy condition. 

## Forest Health Program

The 

## Urban & Community Forestry Program

Urban forests are dynamic ecosystems that provide needed environmental services by cleaning air and water, controlling stormwater, and conserving energy. These ecosystems add form, structure, beauty, and breathing room to urban design. They also reduce noise, separate incompatible uses, provide places to recreate, strengthen social cohesion, leverage community revitalization, and add tremendous economic value to our communities. The rate of Idaho's urban population growth is among the highest in the nation, signaling an increase in the impact that comes with this growth, and the opportunity to address these issues in part by preserving, enhancing and managing tree canopy.
The Urban and Community Forestry Program focuses on the stewardship of urban natural resources and provides technical, educational, and financial assistance to local governments, organizations, and others to maximize the value, function, and health of the urban forest ecosystem. Through these efforts, the program encourages and promotes the creation of healthier, more livable and economically vibrant urban environments across Idaho.
Using a ten-year planning horizon based on the FAP, the Urban and Community Forestry Program relies on the ILRCC to act in an advisory capacity to assist in proper delivery of assistance and educational programs. This committee serves as the principal advisory group for urban and community forestry efforts.

## Conservation Education Program

The Conservation Education program helps people of all ages understand and appreciate Idaho's natural resources and learn how to conserve those resources for future generations. Through structured educational experiences and activities targeting a range of age groups and populations, the Conservation Education program enables people to realize how natural resources and ecosystems affect each other and how resources can be used wisely.
Through the Conservation Education program, people develop the critical thinking skills they need to understand the complexities of ecological problems. The Program also encourages people to act on their own to conserve natural resources and to use them in a responsible manner by making informed decisions.

## State Fire Assistance (National Fire Capacity & Hazard Fuels)

The 

## Introduction

Using the 2020 updated assessment, priority landscapes were identified throughout Idaho in areas where management actions that address benefits and risks are most likely to have a higher return on investment value. The identified Priority Landscape Areas (PLA) will be the primary focus of the State and Private Forestry (S&PF) Programs as well as to serve partner's focal efforts to achieve measurable outcomes within Idaho's forests and associated ecosystems.
It is important to recognize that, because the scale is large and the purpose of the Forest Action Plan (FAP) is to capture priority areas statewide, locally significant areas or issues may not be explicitly captured. These areas or issues are important to address and encourage the use of the concepts, principles and practices found within the FAP.

## Key Issues (Threats and Benefits) Identified in SAFR

The issues identified in the Idaho State Assessment of Forest Resources (SAFR) are shown in diagram form on page 21 More detailed information on the data used and the models used for each issue, subissue, and the overall assessment are described in the document titled Idaho Forest Action Plan, Part One: Resource Assessment.

## Issue: Relative Threat to Communities and Ecosystems from Wildland Fire

Uncharacteristic wildland fire is defined as an increase in wildfire size, severity, and resistance to control compared to that which occurred prior to European settlement. The threat of wildfires has increased due to changes in climate, additional mortality from insects and disease, increasing human population across landscapes (ignition sources and more development at risk), fuel accumulation from decades of aggressive fire suppression, and forest management practices. The purpose of this issue is to identify damage probability from wildland fire to resources and infrastructure in Idaho.

## Issue: Relative Threats to Forest Health

Forests and urban tree canopies face many different kinds of threats. The purpose of analyzing this issue is to identify the most significant statewide biological threats. These include forest insects and diseases that result in tree mortality, noxious terrestrial weed species that can compromise the health and composition of forest stands, and climate change, which may modify current ranges of forest species, adding additional stresses to forests. Not only do stresses from these factors damage forests, they have an ecological, social, and economic impact as well. They affect markets, recreation, and wildlife habitat, and can exacerbate uncharacteristic wildfire. The critical areas identified for this issue represent where hazards or problems currently exist or are likely to exist in the near future, and where management activities can be used to minimize the hazards or threats.
Other issues within the assessment address areas where forests and tree canopy can help mitigate the causes of some of these threats.

## Issue: Relative Potential Loss of, or Damage to Canopy from Development Pressure

The intent of this issue is to identify areas at greatest risk of conversion from forestland to other uses, specifically development. Often, forested areas are highly desirable for home sites or new subdivisions. With this conversion comes a loss of productive forests, increased wildfire risk to property as more homes are "in the woods," and pressure to reduce or eliminate management on adjacent lands. Also important are those areas that may be converted from one housing density to a significantly higher density as this may also lead to loss of canopy and the benefits it provides.
Additionally, recreation pressure, specifically that of Off-Highway Vehicles (OHV) used on forests, increases as populations expand. However, this was not modeled due to a lack of statewide available data. It is acknowledged that this is a critical element of consideration as pressure from OHV use in undesignated areas can lead to degradation of forested areas such as increased erosion, user conflicts, spread of invasive species, damage to cultural sites, disturbance to wildlife, destruction of wildlife habitat, and risks to public safety.
While OHV use in undesignated areas is a threat, it should be emphasized that forests provide recreational value for many uses, including OHVs. Managing the areas where impact or potential impact on forests is greatest, creating and maintaining designated OHV use areas, and providing education to OHV users, will help alleviate this threat.

## Issue: Relative Potential Benefit to Sustainable Forest-Based Wood Products Markets

The purpose of this issue is to identify the forested areas most beneficial to existing and planned mills and biomass-utilization facilities. In many areas of the state, communities are economically and culturally dependent upon forestlands. The benefits and products of forestlands include timber, biomass, recreation, hunting and fishing, and ecosystem services. When markets and mills shut down, incentives to manage forests are significantly diminished, leading to an increase in forest insect and disease infestations, fire risk, and a decline in overall forest health.
Identified in the assessment are those areas within established distances from existing mills and existing or planned biomass utilization facilities-both within and outside of the state-where treatments can help support the wood products industry.

## Issue: Relative Potential Benefit to Water Quality and Quantity from Forests and Canopy

The purpose of this issue is to identify the areas where forests can have the greatest benefit for water quality and quantity. Rural forests and urban tree canopy offer tremendous value toward good water quality, aquifer recharge, stormwater mitigation and erosion control. Water is one of the most critical resources in the West, especially important for fish, wildlife, and humans. Forest canopy shades and cools streams, which is important for healthy fish habitat. Leaves of trees intercept rainfall, lowering the erosive impact of rain on soil. Root systems help break up compacted ground while stabilizing soil, which leads to greater groundwater recharge, reduced runoff and associated contaminant loads from snowmelt and rainwater, and less erosion. This issue focuses forest management efforts on areas in greatest need of improved water quality and quantity in both rural and urban environments.

## Issue: Relative Potential Benefit to Air Quality from Forests and Canopy

The purpose of this issue is to identify the areas where an increase in and management of forests and tree canopy can have the greatest benefit to air quality. Forests have both a positive and negative impact on air quality. Forest canopies absorb and filter particulates, greenhouse gases, and pollutants out of the air, improving air quality while sequestering carbon and releasing oxygen. However, wildfires, especially large uncharacteristic ones, contribute a great deal of particulates (from smoke) and carbon into the air. Communities within the airshed of these fires suffer reduced air quality and commensurate health impacts.
Since temperature is a catalyst for the production of volatile organic compounds (VOC)-the components of smog-the cooling effect of tree canopy in urban areas can lower VOC production. Urban tree canopy can also lower energy consumption through the shading and cooling of buildings resulting in the reduction of energy. When this energy is produced from fossil fuels, less consumption means less production and a corresponding reduction of emissions at the source.

## Issue: Relative Potential Benefit to Wildlife and Biodiversity

This issue identifies the areas of greatest conservation value for wildlife habitat and plant and animal biodiversity, and where management can enhance these values. Areas where forests play a key role in wildlife critical habitat and range; threatened, endangered, and rare fish and wildlife habitat; and ecologically important plant communities, are highlighted. Within the context of the FAP, projects proposed within areas of overall high priority should consider activities that will enhance the habitat of the plant, fish, and wildlife species listed within those areas.

## Development of Priority Landscape Areas

Upon completion of the resource assessment, the Idaho Department of Lands' (IDL) Technical Team reviewed the model values produced for sub-watersheds along with geographic, ecological, social, and other local and regional considerations. Using this process, they identified PLAs as a way to break the state into smaller, local areas where strategies would most effectively address identified threats and potential benefits and provide a framework for multiple complimentary efforts (See maps on pages 18-20). The assessment process was not able to capture all issues across Idaho, so the 2020 draft PLAs were presented to the Idaho Lands Resource Coordinating Council (ILRCC) for discussion and consideration.
Adjustments were made to PLAs based on the ILRCC member's advice, expertise, and experience.
The designation of the PLAs should not be viewed has hard lines across Idaho's landscapes; rather they are "fuzzy" because natural and human systems often impact or interact with areas not found within the PLA delineations. Additionally, PLA boundaries reflect current and modeled future conditions but are not able to capture future opportunities that may weigh into a particular watershed or landscape being included within a PLA. With this in mind, the PLAs will be regularly reviewed by the IDL and the ILRCC to ensure they are appropriately aligned with current and emerging issues.
Some of Idaho's PLAs fall outside of the state border into neighboring states because an issue or issues within the PLAs warranted expansion of the particular PLA to capture a more meaningful scale of the issue(s). Having PLAs that go beyond the Idaho border provides opportunities to align, coordinate, and collaborate with neighboring states on projects and management actions to protect, conserve, and enhance forest resources at ecological, economic, and socially appropriate scales.

## Sage-Steppe Special Landscape Area

Sage-Steppe is the most widespread ecosystem type in the United States covering 111 million acres of the arid Intermountain West. It supports abundant wildlife and other economically important natural resources. In Idaho, it covers an area across southern Idaho from the Snake River Plain to the Nevada border. Vegetation is comprised primarily of grasses and shrubs, such as sagebrush, and Pinion and Juniper woodlands.
Sage-Steppe is also one of the most imperiled ecosystems in the United States. 150 years of fire exclusion and domestic livestock grazing have dramatically altered this landscape including significant expansion of native juniper into the ecosystem. Since the late 1800s, occurrence of western juniper in these areas has grown ten-fold, crowding out sagebrush and native grasses that cannot survive under a closed canopy. The result is fragmented and degraded native wildlife habitat for species such as the greater sage-grouse, currently in danger of being listed under the Endangered Species Act (ESA).
Wildfires fueled by juniper burn at greater intensities, decreasing understory vegetation, increasing soil erosion, and facilitating spread of invasive plants such as cheatgrass and medusahead rye. These nonnative annual plants further alter the fire regime as they create a continuous fuel bed in which repeated wildfires cause wholesale loss of the sagebrush component in the landscape. In some areas, fire occurrence has gone from once every 60 to 100 years, to once every 3 to 5 years.
Agencies and private landowners within the Sage-Steppe are engaged in land management activities to restore native ecosystems. Doing so provides forest-based markets biomass to utilize; protects and preserves key habitat for more than 350 species of plants and wildlife; and increases the value and resiliency of landscapes for grazing livestock.
Stakeholders guiding development of Idaho's 2010 FAP made a conscious decision early on to only include areas where conditions supported the growth of trees and forests, defined as receiving more than 10" of rainfall per year (an amount felt necessary to support growth of commercial forests). However, many stakeholders felt land management issues in the sage steppe, especially as they affect wildlife, water, air quality, and wildfires, warranted inclusion in the FAP. 

## Since completion of

## Priority Landscape Areas Chapter 3 -Goals and Strategies for Idaho Introduction

The Idaho Lands Resource Coordinating Council (ILRCC) reviewed the previously established goals and made changes to align with the new assessment and forest management trends. The 2020 goals and strategies are intended to effectively reduce threats and/or protect, conserve, and enhance the benefits of Idaho's forests. Below is a list of these goals and the strategies to help achieve them. Strategies are categorized by type-Treatments, Partnerships, etc., as a way to more easily understand and characterize their purpose.. 

## Goals and Strategies

## The table below indicates how the goals and strategies from the previous two pages-and their descriptions-correlate to the threats and benefits issues. For example, implementing actions based on the Managed Fire strategy listed under goal 1 will help address forest health, wildfire, wildlife/biodiversity and water quality & quantity issues

## ISSUES ADDRESSED

## Goals and Strategies

Inventory & Analysis        Treatments       Partnerships         Education        
Goal 2: Forestlands that provide the highest ecosystem benefits are identified, maintained and enhanced The Idaho Department of Lands (IDL) will continue to work with key stakeholders and Idaho Lands Resource Coordinating Council (ILRCC) members to prioritize strategies statewide and within each Priority Landscape Area (PLA). This allows for an approach for selecting prospective projects to implement and/or identify project-specific funding opportunities throughout the state. Additional collaborative work will be conducted as needed to further refine strategies and address the issues and needs identified in the PLAs.
Inventory & Analysis       Planning         Treatments         Education         Access         Forest Conservation        
Where there are potential conflicts between goals and strategies, projects developed from the strategies should be balanced as appropriate for the site: e.g. defensible space/fire risk planning versus preservation of wildlife habitat and tree canopy; or the need to balance the economic benefits of the forest for mills and biomass facilities with sustainable forests. Otherwise, success toward one goal could be a detriment to another; a benefit could become a threat.

## Use of the Forest Action Plan (FAP) by the Idaho Department of Lands

State Forest Action Plans are integral to State and Private Forestry (S&PF) Redesign and required of states as an amendment to the Cooperative Forestry Assistance Act (CFAA) as enacted in the 2008 Farm Bill. That is, as a condition of future Federal funding for S&PF programs, completion and utilization of these documents is required.
The FAP will guide future S&PF program work. This document serves as an integrated 10-year plan for the IDL programs described in Chapter 1. The FAP as updated includes the Legacy Assessment of Need (AON) and will be used to further identify opportunities and priorities for acquiring easements.
Each S&PF program will consult the FAP, the ILRCC, and associated sub-committees and program partners on programmatic decisions that result in the most beneficial, on-the-ground impact to Idaho's urban and rural forestlands. The FAP will be key in the S&PF programs delivery to implement projects that address national priorities, target program objectives, and result in meaningful outcomes. Wherever possible, efforts will address the identified issues through an integrated approach utilizing the suite of the S&PF programs.
To ensure their effective use, the Idaho S&PF programs will utilize the FAP when:
• Applying for competitive grant projects Idaho's S&PF Programs will develop a process to engage as needed the ILRCC and other stakeholders to review and adjust the FAP as forest conditions and management objectives change. This review will serve as an opportunity for the stakeholders to continue 1) incorporating new and relevant data, and filling data gaps within the Resource Assessment; 2) incorporating additional stakeholder input; 3) identifying and improving statewide strategies; and 4) developing annual implementation and action plans.
The FAP emphasizes collaborative work and incorporates input of partners and organizations at the state level and locally across the state. While it is a central objective of FAP development that these strategies be constructively used by agencies, organizations, individual landowners, and land management entities, it is recognized that the IDL is the only entity obligated to use these tools.

## Use of the Forest Action Plan by Stakeholders and Collaborative Groups

The FAP can and should serve as a springboard toward a more comprehensive and coordinated approach to forest management that addresses critical forest issues. Specifically, the FAP is a tool for leveraging and prioritizing projects across ownerships to include national forest lands and other federal ownerships. Projects on non-private lands that align with the goals and strategies of the FAP should receive stronger support from partners and publics during National Environmental Policy Act (NEPA) planning and implementation. Broader support for federal projects will result in an increase of on-theground activities and promote a landscape scale or "all lands" approach to management of forest resources.
Idaho's S&PF programs will maintain contact with stakeholders and work collaboratively to identify projects and generate ideas on marketing and dissemination of the FAP. Together, they will identify additional organizations that can work collaboratively to implement cross-boundary projects and most effectively enhance forest benefits and mitigate forest threats across the landscape.

## COHESIVE STRATEGY

In 2009, Congress passed the Federal Land Assistance, Management, and Enhancement Act (FLAME Act), which directs the U.S. Department of Agriculture (USDA) and the Department of the Interior (DOI) to develop a comprehensive national cohesive wildland fire management strategy to address wildland fire management across all lands in the United States.
The Cohesive Strategy is incorporated into this document as an important addition toward addressing the FAP goals. Focusing on the three main tenets-resilient landscapes, resilient communities and strengthened response-addresses not only wildland fire management, but also improves the health, resilience and overall benefits of Idaho Forests. All actions that we take as land managers will directly affect these directives. Cohesive strategy is truly an "all hands/all lands" approach to natural resource management.
The National Strategy recognizes and accepts fire as a natural process necessary for the maintenance of many ecosystems and strives to reduce conflicts between fire-prone landscapes and people. By simultaneously considering the role of fire in the landscape, the ability of humans to plan for and adapt to living with fire, and the need to be prepared to respond to fire when it occurs, the Cohesive Strategy takes a holistic approach to the future of wildland fire management.
The challenges for fire management are formidable and growing more complex. Large blocks of publicly owned land comprise more than half the West's total land area. Fires that start on public lands and move onto private land, threatening communities, are a major problem, compounded by finite fire protection resources. To combat escalating risks posed by wildfire, thorough understanding of resource needs and opportunities by all is required. Additionally, the efficient and effective allocation and use of finite resources is essential. Continued collaboration among stakeholders remains a key to success.
The Western Region's diverse landscapes which include expanding wildland urban interface, steep terrain, access limitations, changing climate conditions, invasive species, and extended drought challenge wildland fire managers. The continued expansion of human development into previously "wild" areas adds considerable complexity to wildfire management. Development codes largely are lacking that address natural hazards to include wildfire, while local fire departments are providing more services with fewer resources.
Stressors such as drought increase forest susceptibility to infestations of insects, pathogens, and disease. In some areas of the West, these stressors have left millions of acres of dead, standing trees. Add to this a century plus of widespread fire exclusion and a decrease in active forest management, resulting in a buildup of surface fuels and forests overstocked with trees and ladder fuels. Compounding these issues, non-forested areas have experienced an increase in fire frequency, contributing invasive species expansion, further altering fire regimes and impacting other ecosystem services.
The forest and rangeland health issues in the West are widespread and increasing, affecting wildlife habitat, water quality and quantity and long-term soil productivity, while providing conditions for uncharacteristically large, severe, and costly wildfires, with ever increasing threats to human life and property.
The West needs large landscape-scale changes in vegetative structure and fuel loadings to significantly alter wildfire behavior, reduce wildfire losses, ensure firefighter and public safety, and improve landscape resiliency. Active management of public and private lands, including harvesting and thinning operations, when coupled with building standards regulations are critical to meeting the tenants of the strategy.
The Wildland Fire Leadership Council adopted the following vision for the next century 
4
 :
To safely and effectively extinguish fire, when needed; use fire where allowable; manage our natural resources; and as a Nation, live with wildland fire.
The three national goals identified as necessary to achieving the vision are:
Restore and maintain landscapes: Landscapes across all jurisdictions are resilient to fire related disturbances in accordance with management objectives.
Fire-adapted communities: Human populations and infrastructure can withstand a wildfire without loss of life and property.
Wildfire response: All jurisdictions participate in making and implementing safe, effective, efficient risk-based wildfire management decisions.

## Shared Stewardship

In August 2018, Shared Stewardship was shared as a conceptual idea by the U.S. Secretary of Agriculture, Sonny Perdue, and the USDA Forest Service Interim Chief, Vicki Christiansen, as a way to increase the pace and scale of forest management across federal land.
Shared Stewardship will play a critical role in cross-boundary project identification and management in Idaho. As agencies align efforts and resources to create 'meaningful' impacts at landscape scales, ecosystems, in all their parts, will become more resilient to disturbances. The Idaho Shared Stewardship Initiative will focus on treating prioritized landscapes by promoting cross-boundary work on state, private, tribal, and Federal lands to protect communities from wildfire, improve forest and watershed health, and sustain jobs and local economies in Idaho.
The need to coordinate strategies across boundaries becomes ever more imperative as more communities are established in the wildland urban interface, while financial assistance to improve forest conditions stagnates or falls. The opportunity to align budgeting, planning and implementation has never been stronger than at the authoring of this update. The silo's that have been in place between agencies are beginning to come down, thus allowing for the blurring of lines, invigorating the enthusiasm to get the 'work' done. To this end in December 2018 an agreement was signed between that State and the Forest Service to reduce wildfire risk, improve forest health, and support jobs through additional, coordinated active land-management projects that are implemented across ownership boundaries. Following the signing of the agreement Idaho's Governor designated two priority landscapes in July 2019 that will serve as proving grounds to create tools for use throughout Idaho.
The Shared Stewardship initiative has brought to light many opportunities to coordinate and collaborate to meet the Shared Stewardship agreement. Specifically, the Idaho Department of Lands has committed financial and staff resources to ensuring the continued expansion of Shared Stewardship throughout Idaho. This same commitment is occurring with the USDA Forest Service and is expanding to other partners within the priority landscapes.
The FAP has been and will continue to be a critical tool in the continued development and entrenchment of Shared Stewardship in Idaho. The FAP serves as a foundational document to guide decision makers and strategies to address forest management needs in Idaho. For additional information about Shared Stewardship please refer to Appendix I.

## Return to Table of Contents

Chapter 5 -Priority Landscape Areas

## Introduction

In this chapter the reader will find a general description of each Priority Landscape Area (PLA), a zoomed in map of each PLA, the individual modeled issues within each PLA, and a list of partners or groups with each PLA. To identify which strategies are of highest priority to address issues or increase benefits from forests, the reader is encouraged to reference the table in Chapter 3 on page 24. 

## Bitterroot Priority Landscape Area

The Bitterroot PLA includes the headwaters of the St. Joe and North Fork of the Clearwater along the Montana border, south to the Highway 12 corridor. There are no incorporated towns in this PLA.

## Resource Groups

Clearwater Basin Collaborative 

## Clearwater Priority Landscape Area

The Clearwater PLA extends from Dworshak Reservoir in the north to Riggins in the south. It includes the Highway 12 corridor, the upper Clearwater River and its main tributaries, as well as a portion of the Salmon River. Orofino, Kamiah, Kooskia, Grangeville, and Whitebird are the main population centers. 

## Resource Groups

## Boise River Priority Landscape Area

The Boise River PLA borders the West Central PLA to the north, the Snake River to the south, the Oregon border to the west, and Lowman to the east. It includes the cities in the Treasure Valley (most populated area of the state); a portion of the Boise, Payette, and South Fork of the Payette Rivers; and the mouth of the Deadwood River and Mores Creek.

## Resource Groups

County Wildfire Working Groups 

## Teton Yellowstone Complex Priority Landscape Area including SW Montana and W Wyoming

The Teton West Slope PLA encompasses the area along the Idaho and Wyoming border.

## Caribou Priority Landscape Area

The Caribou PLA encompasses an area of the Snake River drainage from Palisades Reservoir to Bear Lake. The primary population centers are Pocatello, Soda Springs and Montpelier.

## Resource Groups

Henry 

## Chapter 6 -Statewide Goals for the Long-term Health of Idaho's Forests

In Chapters 3, we identified strategies that address specific issues in the Priority Landscape Areas (PLA). The purpose of Chapter 6 is to identify issues that are affecting all or most of the PLA's as well as many other forested areas in the State. We'll also discuss the broader, causal factors that are affecting forested areas in the State-such as changing environmental and social factors that increase stress on forest systems (stressors).

## Statewide Goals and Strategies

Several common strategies that could be applied to numerous PLAs were identified by the Stakeholders and Core Strategy Development Team. 

## STATEWIDE Key Strategies include:

## Managing Stressors and Long-Term Health of Idaho's Forests

An important overarching goal is to manage for reduced stress and the long-term health of forest systems throughout Idaho. The threats identified in the Forest Action Plan Resources-forest health, uncharacteristic wildfire, development and recreation-are driven by changes in climate, economic conditions, demographics, and other environmental conditions and social values. The benefits-wood products markets, water quality and quantity, air quality, and wildlife and biodiversity-depend on maintaining ecological integrity and sustainable use of forests. Looking at the first level of these factors and working down can provide a framework for strategic, integrated approaches to restoration and protection.

## Strategy

Within the next five years, as part of the FAP revision, convene a group of partners to look more broadly at causal factors and stressors to Idaho forests and identify even longer-term strategies to address these. These factors include changes in climate, demographics, economics, and social values. This effort can be looked at as a "Research and Development" arm of the FAP. The goal is to gain understanding of the higher-level "drivers" of forest stress and change and to be "out in front" with strategies for adaptation to these changes and mitigation of the impacts.

## S&PF Programs: All

Stakeholders: All (a small group to take the lead with this effort and report to all Stakeholders)

## Return to Table of Contents

Ecosystem Services -Benefits people obtain from ecosystems. These include provisioning services such as food, water, timber, and fiber; regulating services that affect climate, floods, disease, wastes, air, and water quality; cultural services that provide recreational, aesthetic, and spiritual benefits; and supporting services such as soil formation, photosynthesis, and nutrient cycling.
Environment -The complex surroundings of an item or area of interest, such as air, water, natural resources, and their physical conditions (temperature and humidity).
Erosion -The wearing away of the land surface by water, wind, ice or other geologic agents and by such processes as gravitational creep.
Forest -A large area where trees grow close together. Forests can be in rural and urban areas.
Forest Action Plan (FAP) Forest Resource Assessment -A geospatial analysis of the conditions and trends of forests in Idaho, based upon seven key issues and 24 sub-issues categorized into threats to and potential benefits from forests. The assessment uses best available data for informing these issues and is an objective method for identifying areas within the state where focusing resources will have the greatest opportunity to address shared priorities.
Forest diversity -Different types of forest communities and numbers of species within forests.
Forest health -A measure of the robustness of forest ecosystems. Aspects of forest health include biological diversity; soil, air, and water productivity; natural disturbances; and the capacity of the forest to provide a sustained flow of goods and services for people.
Forest loss -The conversion of forestland to some other land use.
Forest structure -The complexity of the vertical and horizontal forest.
Forest Stewardship Council (FSC) -An independent, non-governmental, not-for-profit organization established to promote the responsible management of the world's forests. FSC certification is a voluntary, market-based tool that supports responsible forest management worldwide. FSC certified forest products are verified from the forest of origin through the supply chain.
Forestry -The practice of creating, managing, using, and conserving forests for human benefit.
Fragmentation -The process by which large continuous tracts of forestland are broken into smaller, disconnected units.
Greenhouse gasses (GHGs) -Gasses, including methane, chlorofluorocarbons and carbon dioxide, which act as a shield that traps heat in the earth's atmosphere and thought to contribute to global warming.
Habitat -The area or environment where an organism or ecological community normally lives or occurs.
Hardwoods -Dicotyledonous trees, usually broadleaf and deciduous.
Harvesting -Felling, loading and transporting forest products, round wood or logs.
Hazard fuels reduction -Any treatment of living and dead fuels that reduces the potential spread or undesirable effects of fire.
Herbaceous -A non-woody type of plant that grows along the forest floor and has leaves and stems which die down at the end of the growing season to the soil level.
Herbicide -Any substance or mixture of substances intended to prevent the growth of or destroy terrestrial or aquatic weeds.
Hydrologic Unit Code -A series of numbers in a nested hierarchy that are used to identify a watershed size and location. The greater number of digits in the identification number, the smaller the area. The first two digits identify the region of the United States. An eight-digit hydrologic unit code typically identifies a basin and averages around 703 square miles. A 14-digit code is typically the smallest watershed identified.
Impervious -Surface that is not passable for water.
Invasive species -Species, which is often non-native, whose introduction causes or is likely to cause economic or environmental harm or harm to human health.
Landowner Forest Stewardship Plan (LFSP) -A multi-resource plan that lays out strategies for achieving unique landowner objectives and sustaining forest health and vigor.
Landscape scale -The scale which is relevant to the phenomenon under consideration and which is of sufficient size where actions have a real, meaningful and persistent affect.
Native species -A species that is a part of the original fauna or flora of the area in question
Noxious weeds -The 64 different species of weeds which are designated noxious by Idaho state law
Off-highway vehicles (OHVs) -As used in this report, any type of vehicle which is capable of driving on and off paved or gravel surfaces for recreation. OHV used in designated areas is a popular and supported form of recreation. OHV use in undesignated areas can degrade forests.
Ozone -As used in this document, an unstable, poisonous allotrope of oxygen (O3) produced in the lower atmosphere by the photochemical reaction of certain pollutants such as volatile organic compounds.
Parcelization -The change in ownership patterns when larger forested tracts are divided into smaller parcels owned by several owners.
Prescribed fire -Controlled application of fire to wildland fuels in either their natural or modified state, under specified environmental conditions that allow the fire to be confined to a predetermined area. The application produces the fire behavior and fire characteristics required to attain planned fire treatment and resource management objectives.
Priority Landscape Area -For this document, an area within which significant portions rated as high and very high priority by the Idaho Forest Action Plan Resource Assessment, and which share similar vegetative, geographic and management characteristics.
Regeneration -Process of replacing old trees with young through harvest or other means.
Restoration -The process of assisting the recovery of an ecosystem that has been degraded, damaged, or destroyed. Thinning and prescribed fire are examples of vegetation management tools used to accomplish forest restoration.
Riparian -Pertaining to the banks of a stream, river or pond.
Runoff -Portion of precipitation that flows from a drainage area or in open channels.
Sedimentation -process that deposits soils, debris and other materials in bodies of water.
Seedling -A small, young tree, less than 3 years old.
Silviculture -The science and art of controlling the establishment, composition, and growth of forests.
Stakeholders -With respect to this document, Federal, state and local agencies, organizations and individuals that influence or are otherwise interested, involved, or affected by an Idaho statewide forest resource management strategy.
Stand Structure -A description of the distribution and representation of stand age and stand size classes within a stand. The distribution of trees in a stand, which can be described by species, vertical or horizontal spatial patterns, size of trees or tree parts, age, or a combination of these.
State and Private Forestry -An organization of the USDA Forest Service that partners with states to deliver technical and financial assistance to landowners and resource managers to help sustain the Nation's state, tribal, non-industrial and community forests.
Softwood -Coniferous trees, usually evergreen, having leaves that are needles or scale like.
Soil -Unconsolidated mineral and organic material on the immediate surface of the earth, serving as a natural medium for the growth of plants.
Stream -A body of concentrated flowing water in a natural low area of land.
Sustainability -The capacity to meet the needs of the present without compromising the ability of future generations to meet their own needs; integrates environmental, social, and economic concerns and outcomes.
Sustainable forest management -Management in an attempt to attain balance between society's increasing demands for forest products and benefits, and the conservation and maintenance of forest health and diversity.
Sustainable Forestry Initiative (SFI) -An independent, non-profit organization responsible for maintaining, overseeing and improving a sustainable forestry certification program. The standard for certification is based on principles and measures that promote sustainable forest management and consider all forest values.
Thinning -Cutting or removing certain trees to allow those remaining to grow faster. Usually a commercial operation in younger stands that brings an income to the landowner while improving a forest.
Treatments -Management or harvesting activities applied to a forest stand to alter the condition of the stand. Treatments may or may not generate revenue.
Tree -Woody plant having one erect perennial stem or trunk at least 3 inches diameter at breast height, a more or less definitely formed crown of foliage, and a height of at least 13 feet (at maturity).
Uncharacteristic wildland fire -An increase in wildfire size, severity, and resistance to control compared to that which occurred prior to European settlement.
Urban and Community Forestry -The care and management of tree populations in communities (urban and Community forests) as a critical part of the urban infrastructure and for the purpose of improving the urban environment.
Volatile organic compounds (VOCs) -Organic chemical compounds which have significant vapor pressures, and which can affect the environment and human health. Higher temperatures and sunlight are factors that increase the production of VOCs.
Watershed -Area within which all runoff collects into a single stream or drainage system, exiting through a single mouth or outlet.
Wetland -Transitional area between aquatic and terrestrial ecosystems that is inundated or saturated with water for long enough periods to produce hydric soils and support hydrophytic vegetation.
Wildland Urban Interface (WUI) -areas where structures and other human development meet or intermingle with undeveloped wildland.
Wildfires -Uncontrolled fires occurring in forestland, brushland and grassland.
Wood products -Materials developed from use of the hard, fibrous substance (wood) which makes up the greater part of the trunks and limbs of trees. Solid wood products include lumber, veneer and plywood, furniture, poles, piling, mine timbers, and posts; and composite wood products include laminated timbers, insulation board, hardboard, and particleboard. Woody biomass (see biomass) is also considered a wood product. To address the strategic opportunities identified in the FAP, and in light of fiscal and programmatic changes, the Director of IDL asked agency staff to review their program delivery methods and consider opportunities to integrate resources and optimize program outcomes. Coordination of three separate advisory councils requires considerable staff time and fiscal resources, so IDL staff was tasked with investigating a more efficient and collaborative model for seeking input from partners. An IDL Oversight Group, consisting of representatives from each of the three advisory councils and IDL staff, was assembled to address the Director's request. To ensure federal program requirements are being addressed, IDL has discussed this effort with regional and national level FS S&PF managers. Formed in the early 1990s, this group's primary focus was outreach to cities of all sizes and included providing advice to IDL regarding cost-share programs that were available to cities statewide. These cost-share programs have been eliminated due to reduced federal program funding. Currently, this group's primary focus is communication and information sharing within the committee, Arbor Day and Tree City USA promotion and recognition for cities statewide and encouraging projects that demonstrate and promote the value of urban trees.

## Appendix B -Acronyms

## Current Advisory Council Structure in Idaho

## Recommended Changes: Idaho Lands Resource Coordinating Council

An IDL Oversight Group consisting of representatives from each of the three advisory councils and IDL staff was assembled to review how these groups currently operate and provide recommendations for how the groups might work more cooperatively to address FAP priorities. After reviewing the purpose of each existing advisory council and discussing the new direction of S&PF program delivery mandated through S&PF Redesign, the Oversight Group determined that the focus points of these three groups have a great amount of overlap and that there is great potential to achieve effective statewide program outcomes more strategically through consolidation into a single Coordinating Council. All three groups place a high priority on communication and information sharing, and this can continue to be achieved through including representation from each group in the single Coordinating Council structure. This concept closely follows the strategy identified in the FAP.

## Coordinating Council Representation

The Oversight Group recognizes the importance of being strategic about the number of Coordinating Council members that can function efficiently and effectively. The following representation from the existing advisory councils is recommended with the understanding that additional interest groups may be represented through appointment to subcommittees. • Subcommittees will be appointed as needed but will not be "standing." Forest Legacy applications and grants review (Competitive and Western Fire grants) may be handled by the full Council.
• IDL staff (program managers and bureau chief) will participate in meetings but will not serve as voting members.
• A simple charter outlining Council purpose and operating procedures will be developed by the Coordinating Council membership.
• IDL will follow the current nomination process used for advisory councils to appoint members from identified interests.
• 6-12 months after formation, IDL will review the effectiveness of the Coordinating Council to assure program needs are being addressed.
Specifically, the Oversight Group identified the following focus areas to be addressed:
Assist the State Forester with multi-objective strategic planning through prioritization and implementation of the FAP. This includes developing annual and long-term statewide action plans focusing on priority resource issues rather than individual programs, monitoring and reviewing accomplishments, refining and prioritizing actions, informing and involving stakeholders, and incorporating new information and filling data gaps. 

## Criteria for Ranking Individual Project Proposals:

Eligible project proposals (see Project Eligibility Requirements above) will be ranked independently by the Idaho Lands Resource Coordinating Council (ILRCC) and/or Idaho Forest Legacy subcommittee
foot_4
 members according to the criteria outlined below. These criteria generally reflect those used by the National Review Panel.
1. Importance: These criteria evaluate the economic, environmental and social impacts potentially conserved by the project. Higher scores are given to projects that possess a majority of the attributes listed below and at a broad scale of significance: a. Forestry: Are the forest resources managed for sustainability? Does the property contain characteristics to sustain a productive forest? b. Economic Benefits: Does the project provide timber and/or non-timber revenue to the local, regional or national economy? c. Threatened or Endangered Species: Does the site have threatened or endangered species and/or designated habitat? d. Fish, Wildlife, Plants, and Unique Forest Communities: Does the site contain unique forest communities and/or important fish or wildlife habitat? e. Water Supply and Watershed Protection: Does the property have a direct relationship with protecting the water supply or watershed? Does the property contain important riparian area, wetlands, shorelines, river systems, or sensitive watershed lands? f. Public Access: Will protection of the property maintain or establish access by the public for recreation? g. Scenic: Is the site located within a viewshed of a government designated scenic feature or area? h. Historic/Cultural/Tribal: Does the site contain features of historical, cultural, and/or tribal significance?
2. Threatened: These criteria evaluate the likelihood of a project's conversion to non-forest uses. Project's that demonstrate a greater threat of conversion are scored higher.
Legal Protection: What is the degree of legal protection that currently exists on the property? Land/Landowners Circumstances: What are the land and/or owner circumstances (property held in an estate, aging landowner, future property by heirs is uncertain, property is up for sale or has a sale pending, landowner has received purchase offers, land has an approved subdivision plan, etc.)? Adjacent Land Use: What are the adjacent land use characteristics such as existing land status, rate of development growth and conversion, rate of population growth, rate of change in ownership, etc.? Ability to Develop: Are there physical attributes of the property that will facilitate conversion, such as access, buildable ground, zoning, slope, water/sewer, electricity, etc.?
3. Strategic: These criteria evaluate a project's relevance or relationship to conservation on a broader scale.
Projects that significantly enhance conservation strategies at a broad scale are scored higher. a. Conservation Strategy: How does the project fit within a larger conservation plan, strategy, or initiative? b. Compliment Protected Lands: Is the project strategically linked to already protected lands (past FLP projects, Federal, State, other conservation lands, etc.)?
4. Prior FLP funding: Has the landowner been awarded FLP funding (regardless of amount) for two consecutive years? An owner that has been awarded FLP funding for two consecutive years, cannot be ranked the #1 project the third year unless it is the sole application recommended for funding from the State of Idaho. Additionally, the following criteria will enhance application rating: a. Completing five or more of the following items will significantly affect a project's score:
preliminary appraisal, signed option or purchase and sales agreement, cost-share commitment, held by a third party at the request of the State, draft Conservation Easement, LFSP, mineral survey and title report. b. A 50% or greater non-federal match c. Letters of support from various public and private entities (NGO's, non-profit, government officials, etc.)

## Project Prioritization

Individual Forest Legacy applications go through a rigorous and highly competitive review process. First, the above criteria are used to score and develop a prioritization list. Proposals with higher scores rank higher. The State's priority list, with approval from the ILRCC 7 , is then forwarded to the Forest Service regional committee. This regional committee uses similar ranking criteria, the national core criteria, to score and rank project applications from the Western United States. Projects are then submitted to the Washington Office where the National Review Panel will use the same national core criteria to develop a prioritized national project list. The regional and National Review Panels are not bound by a State's priority ranking of projects and may rank projects out of a State's priority order. Finally, the outcome from the National Review Panel will be a ranked and prioritized list of FLP projects for submission to the Office of Management and Budget for consideration in the President's Budget. Projects highest on the list will receive top priority for funds as they become available.

## Comparison of Priority Landscape Areas and Legacy Assessment of Need Areas

The original Idaho Legacy Program Assessment of Need (AON) was developed without a geospatial analysis. Rather, within the latitude provided by the National Forest Legacy Program, the state adopted a broad definition of forests and considered threats to and values from them. Legacy eligible areas were selected on a county scale, and only included counties with more than 10,000 acres of non-federal forestlands. However, included within the map of final legacy eligible areas are ineligible lands (Federal and State lands) and areas that are not forested or which cannot support forests. The areas included as "Legacy eligible" were divided into six regions at a county scale. These were prioritized through a numerical process using information representing acres of private forestland, population change, land use change, threatened and endangered species candidates, dispersed recreation, and information on forest markets.
The Idaho Statewide Forest Resource Assessment-described in detail in the Idaho Forest Action Plan, part 1-used a geospatial analysis of these same issues, but also included the additional critical issues of water quality, air quality, and uncharacteristic wildland fire risk. The assessment was completed on a HUC 6, or sub-watershed scale using 30-meter or finer data. Through a far more robust stakeholder involvement process than occurred during development of the original AON, the statewide datasets that best informed these issues were selected and an analytical methodology developed which led to the identification of Priority Landscape Areas-areas in which focusing federal and partner resources will address multiple high-priority issues. It should be emphasized that the resulting map only determines those areas in which Legacy projects are eligible. As has been done from the start of Idaho's Legacy Program, an in-depth review, analysis and ranking of specific projects as described above will continue.
The Forest Legacy Areas map (from the original AON) and the map of Priority Landscape Areas look quite different at first glance (see next page). Yet both maps contain lands that are ineligible for Forest Legacy Projects. These include state and federal lands, and areas that lack or are incapable of supporting forests. To compare the two maps, these ineligible areas must be excluded. The two maps on page 87 represent a more accurate comparison. In both maps, ineligible lands by ownership, non-forested areas and areas that receive less than 10" annual precipitation (unable to support forests) have been masked out. Even though the process for developing these maps was different, the maps themselves are remarkably similar.
With the integration of the Legacy Program into the Idaho Forest Action Plan, the six original Legacy Areas identified in Idaho's September 2002 Assessment of Need are being dissolved and replaced by the 12 Priority Landscape Areas identified in the 2010 Idaho Forest Action Plan. Priority Landscape Areas Legacy Eligible Lands will be the working map for determining initial Legacy project eligibility. It is our belief that the areas identified on this map best reflect statewide priorities.
# # # Similar meetings were then initiated with the Payette and Boise National Forest managers and District Rangers, along with IDL, to define smaller, focused focal areas within the southern Idaho Shared Stewardship Priority Landscape. Inter-agency collaboration yielded two Shared Stewardship Focal Areas within the larger south Idaho SSPL.

## Identification of Stewardship Focal Areas

With emphasis put on the delivery of programs administered by the IDL within the Forest Action Plan designated Priority Lands Areas (PLAs) it was determined that using these same PLA designations would be appropriate to use as the Stewardship Focal Areas. To ensure that no more than 50% of non-industrial private forest lands would be included as provided in guidance from the USDA Forest Service, the Forest Action Plan PLAs were used to clip the Non-Industrial Private Forest Lands layer which allowed the IDL to count the acres within the PLAs of non-industrial private forest lands. 2,153,640 acres of non-industrial private forested lands were identified or 47.07% of the 4,575,264 acres of private forested lands in Idaho.
Using the PLA designations also captures those lands that have been converted to other uses but still have potential to be forested, thus allowing Forest Stewardship Program services to be delivered to landowners desiring to re-establish or conduct afforestation management on their ownership.

[FIGURE: Palouse-St. Joe Priority Landscape AreaThe Palouse-St. Joe PLA extends from Moscow and the Washington border in the west to the Montana border on the east and encompasses the upper St. Joe River valley, the Palouse River, Hangman Creek and portions of Dworshak Reservoir south to Highway 12 A portion of the State-owned Floodwood Forest is in their PLA, as is most of the Coeur d'Alene Indian Reservation. The primary population centers include Moscow, Deary, Troy, and Potlatch. Resource Groups Waters of the West at the University of Idaho • Palouse Basin Aquifer Committee • Clearwater Basin Collaborative • Clearwater Economic Development Association • Palouse Clearwater Environmental Institute • Friends of Moscow Mountain • Latah Trail Foundation • Moscow Area Mountain Bike Association • Moscow Mountain Cedar Grove Steering Committee • Waters of the West • County CWWGs • Watershed Advisory Groups • Soil and Water Conservation Districts • Shoshone County Forest Health Collaborative • Shoshone-Benewah Forest CollaborativeReturn to Tableof Contents]

[FIGURE: Federal land management agencies (required) .......................................................... Yes  No ❑ The USDI Bureau of Land Management, USDA Forest Service (State and Private Forestry and the National Forest System) and USDA Natural Resources Conservation Service are the primary Federal forestland management agencies in Idaho. Each had representatives who actively participated on the Core Assessment and Strategy teams. Other Plans Incorporated in Statewide Assessment and Strategy: Community wildfire protection plans (required) ........................................................................ Yes  No ❑ Community wildfire protection plans (CWPPs) are integrated into strategies within each of the PLAs. State wildlife action plans (required) ......................................................................................... Yes  No ❑Data from the Comprehensive Wildlife Conservation Strategy (CWCS)-including key wildlife and fish habitat and State Wildlife Focal Areas were included in the geospatial FAP Resource Assessment. A detailed description of the modeling used is included in the Assessment document.The CWCS is incorporated herein by reference. It is one of many plans that should be consulted as actions and projects are developed from the listed strategies for each PLA. It is directly referenced in many strategies throughout the PLAs. Other ..................................................................................................................................]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[FIGURE: ]

[TABLE:  • Ara Andrea -Idaho Department of Lands; Chief, Bureau of Forestry Assistance • Gerry Bates -Forty Solutions City of Pocatello; Science and Environment Division Manager • Kirk Sehlmeyer -Natural Resource Conservation Service; Forester • Chris Schnepf -University of Idaho Extension Forestry • Greg Servheen -Idaho Department of Fish and Game (Retired) • David Stephenson -Idaho Department of Lands; Urban Planning Program Manager (Retired) • Janet Valle -USDA Forest Service, State & Private Forestry, Regions 1 & 4 • Mike Wolcott -Inland Forest Management]
[TABLE: • The State Assessment of Forest Resources and the Statewide Forest Resource Strategy are now collectively called the Idaho Forest Action Plan (FAP). This name change is reflected throughout both documents. • The Idaho Lands Resource Coordinating Council (ILRCC)-an advisory group representing all Idaho S&PF program areas-replaces the three-program specific advisory groups. Discussion is found on page 26 and in Appendix F: 79-81.]
[TABLE:  This standalone document highlights accomplishments based on the strategies within this Plan, summarizes statewide, multi-state, and Priority Landscape Area projects, and links these to the National Priorities listed in the 2008 Farm Bill. IDL began implementing FAP strategies before the plan was finalized and is the reason the Accomplishment Report covers project work starting in 2008.]
[TABLE: Table of Contents Chapter 1 -State and Private Forestry Programs Introduction Idaho ]
[TABLE:  The Idaho Forest Stewardship Program promotes forest landowner participation in the development of Landowner Forest Stewardship Plans, Natural Resource Conservation Service (NRCS) Forest Conservation Activity Plans, and American Tree Farm System Management Plans. The IDL foresters assist landowners with the development of these management plans; an important first step in practicing sound silviculture. The planning assistance offered through the Idaho Forest Stewardship Program also provides landowners with enhanced access to other U.S. Department of Agriculture (USDA) funding assistance, conservation programs, and forest certification programs. Within Idaho's Forest Stewardship Program, the IDL in cooperation with other state partners, delivers multiple in-the field educational sessions for landowners and land managers, focusing on issues, problems and opportunities, and the appropriate stewardship activities to address these.]

[TABLE]
*The FAP replaces the original Forest Legacy Program's Assessment of Need *

| Rural Fire Capacity |
| --- |
| Funding though the Rural Fire Capacity Program supports fire management training and equipment for |
| Volunteer Fire Departments throughout Idaho. The Fire Departments receiving funding service a |
| community or other population area(s) of less than 10,000 people. |
| Priority is given to fire management training. With safety being the number one priority in fighting |
| wildland fire, personnel require adequate training in not only structure, but also wildland fire control |
| techniques. Funds are also used to equip fire districts with priority personal protective safety equipment |
| and gear. |
| Forest Legacy Program |
| The Forest Legacy Program -a federal program in partnership with states-supports state efforts to |
| protect environmentally important forestlands. The Idaho Forest Legacy Program is funded through a |
| percentage of federal receipts from oil and gas drilling on the outer continental shelf, to purchase |
| conservation easements on private lands that might otherwise be developed and converted to non- |
| forest uses. The Idaho Forest Legacy Program is a voluntary program designed to protect forests and the |
| economic and ecological benefits they provide. Those landowners wishing to participate in the program |
| are provided with tools and the potential to receive funding to assure their forestland remains a working |
| forest in perpetuity. The Idaho Forest Legacy Program conservation easements are legally binding |
| agreements that transfer a negotiated set of property rights from the landowner to the State of Idaho |
| without removing that property from private ownership. In general, the Idaho Forest Legacy Program |
| conservation easements restrict development and mineral extraction, require sustainable forestry |
| practices, and protect other values such as water, cultural resources, and fish and wildlife habitat. |
| State of Idaho has 12,592,000 acres of state and private land that qualify for protection under the |
| State Fire Assistance Program of the Cooperative Forestry Assistance Act. Of these acres, ~6.4 million The Idaho Forest Legacy Program completed a Forest Legacy Assessment of Need (AON) in 2002 receive protection by either State or federal agencies. The IDL uses State Fire Assistance funds to hire, (updated in 2010 and again in 2020). The AON, a requirement for states participating in the Program, is train, and equip interagency firefighters, a resource that can be ordered and used by any state, federal, a detailed analysis of the issues pertinent to the Program and prioritizes areas within the state for Forest or local unit. Legacy Program funding. The Idaho State Assessment of Forest Resources (SAFR)-a comprehensive |
| Idaho developed a formal structure and strategy to implement the National Fire Plan (NFP) component review of the threats and benefits that affect Idaho forests-identified priority areas for forest |
| of the State Fire Assistance Program in 2001. With the role-out of the Cohesive Strategy in 2009, the conservation and management. The FAP addresses the criteria necessary to update and replace the |
| need to further collaborate and coordinate was highlighted in the Three National Goals: Fire-Adapted original AON, including incorporating comments and input from many organizations, agencies, and |
| Communities; Fire Resilient Landscapes, Safe and Effective Response. To address these tenants, the members of the public. |
| Idaho Department of Lands administers the NFP through local cooperators to assist landowners in the Beginning in 2012, Idaho's Forest Legacy Program, with oversight from the ILRCC, began using the FAP as management of vegetation to reduce wildfire risk and education programs to empower people with Idaho's Forest Legacy Program AON to guide implementation of the program. A Forest Legacy information. subcommittee of the ILRCC consisting of ILRCC members, agency representatives, and other interested |
| All 44 counties in Idaho have County Wildfire Protection Plans (CWPP) which identify projects to reduce parties, performs evaluation and scoring of project applications. Appendix G (page 82-85) provides |
| risk, expand education and increase response capacity. The maintenance of the CWPPs is done locally additional information detailing Idaho's Forest Legacy Program including goals and objectives, project |
| by the County Wildfire Working Groups (CWWG), which are made up of county emergency managers eligibility criteria, project evaluation and prioritization, and a comparison of prior and current Forest |
| and local, state and federal partners. Through NFP grants most Idaho counties have been able to Legacy eligible areas. |
| complete projects listed in their CWPP that emphasize fire prevention and education, hazardous fuels |
| reduction, assistance to firefighters, and woody biomass utilization. Additionally, the State Fire |
| Assistance Program relies on the ILRCC to act in an advisory capacity to assist in proper delivery of |
| assistance and educational programs. |
| State Fire Assistance activities focus on areas identified in both the FAP and CWPPs as high priority, |
| further guided by strategies within this document. |

[/TABLE]

[TABLE:  Idaho's 2010 FAP, these issues have gained greater attention, and the restoration of Sage-Steppe areas to reduce wildfire risk is now a national priority. After extensive discussion during the ILRCC's summer 2015 meeting, Council members voted to include Idaho's Sage-Steppe areas in the 2015 FAP Revision as a Special Landscape Area (SLA) rather than a PLA.]
[TABLE: Goal 1: Idaho's Forests are diverse and resilient to climatic changes and other threats (fire, insects, disease, noxious weeds, etc.) ]

[TABLE]
*Forestlands that provide the highest ecosystem benefits are identified, maintained and enhanced Inventory & Analysis - *

| Goal 3: |
| --- |
| Education -Provide education leading to understanding and support of |
| ecosystem services |
| Access -Maintain and enhance public access and recreation opportunities |
| Forest Conservation Incentives -Use conservation actions to effectively protect and enhance high |
| priority forestlands |

[/TABLE]

[TABLE]
*Forest ecosystems are more resilient to human activities (development, harvest operations, etc.) Inventory and Analysis - Develop systems for early detection, rapid response and enforcement capacity for early and effective action to minimize adverse impacts to forest ecosystems*

| Treatments -Implement urban and rural forest practices to mitigate adverse |
| --- |
| impacts to forest systems and monitor/adapt |
| Education -Provide education for target audiences leading to understanding and |
| support of forest ecosystem goals (developers, planners, landowners, |
| loggers, realtors, recreationists, others) |
| Regulation/Policy -Develop land use best management practices (BMPs), which may |
| include rules, ordinances, and/or laws to protect and enhance forests |
| and their ecosystem services and products |
| Goal 4: |

[/TABLE]

[TABLE: Forest-based wood products markets are economically vibrant and sustainable Inventory and ]
[TABLE: Idaho has a framework for implementing the Forest Action Plan, to guide project prioritization across boundaries. ]

[TABLE]
*Idaho's Forests are diverse and resilient to climatic changes and other threats *

|  |  | Threats |  |  |  |  | Benefits |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Strategies | Forest Health | Wildfire | Development | Pressure | Wildlife/ | Biodiversity | Water Quality & | Quantity | Air Quality | Sustainable Wood Product Economics | Connecting People to Forests |
| Goal 1: |  |  |  |  |  |  |  |  |  |  |  |

[/TABLE]

[TABLE]
*Goal 3: Forest ecosystems are more resilient to human activities Inventory & Analysis *

|  |    |     |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- |
| Treatments |    |  |  |  |  |  |
| Education |    |    |  |  |  |  |
| Regulation/Policy |    |     |  |  |  |  |
| Goal 4: |  |  |  |  |  |  |

[/TABLE]

[TABLE]
*Forest-based wood products markets are economically vibrant and sustainable *

| Inventory & Analysis |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Treatments |    |  |  |  |  |  |  |  |
| Marketing |  |  |  |  |  |  |  |   |
| Goal 5: |  |  |  |  |  |  |  |  |

[/TABLE]

[TABLE]
*Idaho has a framework for implementing the Idaho FAP to guide project prioritization across boundaries *

|  Inventory & Analysis |  |   |  |     |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Partnerships |  |  |  |  |  |  |  |  |

[/TABLE]

[TABLE]
*following table emphasizes the goals using the same color ramp that was used in the Final Priority map found in the Forest Assessment section of the plan, where cooler colors represent low priority and warmer colors represent higher priority. When used in combination with the previous table the appropriate strategies can be applied to increase forest benefits or address forest threats within the Priority Landscape Areas (PLA). *Please note that Goal 5 is not included in the below table because of the emphasis of it being primarily at a statewide scale. *

| Goals | 1 | 2 | 3 | 4 |
| --- | --- | --- | --- | --- |
| Panhandle |  |  |  |  |
| Palouse-St. Joe |  |  |  |  |
| Bitteroot |  |  |  |  |
| Hells Gate |  |  |  |  |
| Clearwater |  |  |  |  |
| West Central |  |  |  |  |
| Boise River |  |  |  |  |
| Salmon Challis |  |  |  |  |
| Wood river |  |  |  |  |
| Snake River Complex |  |  |  |  |
| Forest Island Complex |  |  |  |  |
| Teton-Yellowstone |  |  |  |  |
| Caribou |  |  |  |  |
| Sage-steppe |  |  |  |  |
| Statewide |  |  |  |  |
|  | Return to Table of Contents |  |  |  |

[/TABLE]

[TABLE: Chapter 4 -Implementation of Strategies Introduction The information within this document provides a long-term, comprehensive approach for coordinating state, federal, and leveraged partner resources to address landscape priorities. The completion of this document re-emphasizes stakeholder and partner engagement to implement strategies across all ownerships.]
[TABLE:  • Determining priorities for use of Consolidated Payment Grant dollars • Collaborating with ILRCC and other partners to implement strategies • Working with forestry agencies to develop projects that address mutual priorities • Developing integrated program action plans]
[TABLE: Priority Landscape Areas including NW Montana, NE Washington and Spokane Valley Rathdrum Prairie Aquifer Resource Groups Clark Fork Management Committee • Grizzly Bear Subcommittee-Boundary • Smith WMA Management Committee • Selkirk/Cabinet -Yaak IGBC Subcommittee • Pend Oreille Basin Commission • Kootenai Valley Resource Initiative partners • Kootenai Tribe • North Idaho Renewable Energy Coalition (NIREC) • Tri-State Water Quality Council • Panhandle Area Council • Watershed Advisory Groups • Ponderay Water Watchers • Priest Community Forest Connection • Winter Knights • Scotchman Peaks Group • Salmon Recovery Funding Board • County CWPP Committees • Sandpoint Kinnikinnick Native Plant Society • Panhandle Backcountry Horsemen • Selkirk Conservation Alliance • Priest Lake Sportsmen • Boundary County Sportsmen • Soil and Water Conservation Districts • Coeur d'Alene Chamber Natural Resources Committee • Coeur d'Alene Forestry Coalition • Shoshone County Forest Health Collaborative • Friends of Rathdrum Mountain • NIREC • Spokane Valley Rathdrum Mountain Aquifer Atlas Group • Coeur d'Alene Sports Coalition • Kootenai Metropolitan Planning Organization]

[TABLE]
*Hells Gate Priority Landscape Area Including Montana Bitterroot The Hells Gate PLA extends from the Kendrick in the north to Craig Mountain in the south and from the Washington state line east to Dworshak Reservoir. It includes the lower Clearwater and Potlatch Rivers. The main population centers are Lewiston, Lapwai, Winchester, and Culdesac. Winchester State Park is within this PLA.*

| Resource Groups |
| --- |

[/TABLE]

[TABLE]
*Central Idaho Priority Landscape Area The West Central PLA borders the Clearwater PLA to the north and extends south to Payette, Emmett and Horseshoe Bend and from the Oregon border in the west to the Middle Fork of the Payette River in the east. It includes Payette and Cascade Lakes, the Weiser River drainage, the Middle Fork of the Payette River, and the southern portion of the Little Salmon River. The primary population centers include the cities of Council, Cascade, Emmett, New Meadows, McCall, and Weiser.*

| Resource Groups |
| --- |

[/TABLE]

[TABLE]
* The Wood River PLA encompasses Sun Valley to the north, US Highway 20 to the south, the east slopes of the Smoky Mountains in the west, and the Little Wood River Valley to the east, and significant parts of the Big and Little Wood Rivers. Primary population centers include the cities of Ketchum, Hailey, and Bellevue.*

| Resource Groups |
| --- |

[/TABLE]

[TABLE:  Pheasants Forestry • Mountain Home RFPA • Owyhee RFPA • Saylor Creek RFPS • Three Creek RFPA • Black Canyon RFPA • Woody Biomass Utilization Partnership • Southern Idaho Counties • County Wildfire Working Groups • Watershed Advisory Groups • Soil & Water Conservation Districts • BLM Fire and Invasive Species Assessment Teams (FISAT) • Owyhee RFPA • Saylor Creek RFPA • Three Creek RFPA • Shoshone Basin RFPA • Mountain Home RFPA • Henry's Creek RFPA • Camas Creek RFPA]

[TABLE]
*Goals 1, 2 and 3: Education - Use local groups and partnerships to develop and implement strategies for individual Priority Areas. Idaho Lands Resource Coordinating Council (ILRCC) will work with local groups or partners to Improve information, identify and implement projects, identify and fill data gaps, explore/develop new tools and strategies for assessing conditions. Assess, design and implement effective education and outreach efforts to reach targeted audiences-forestry professionals, forest landowners, community residents, and non-forestry stakeholders. Utilize existing conference, workshop, and demonstration events and explore new technologies to increase efficiency and effectiveness. Incorporate assessment tools that measure changes in behavior. Educational needs include youth education, conserving working forests for the future, forest benefits, and technical training for professionals.*

| Develop and utilize a framework for continual dissemination of information to all partners in education. |
| --- |
| S&PF Programs: Forest Health, Forest Stewardship, Urban &Community Forestry, State Fire Assistance, |
| Forest Legacy, Conservation Education |
| Stakeholders: Other states, Idaho Tribes (Coeur d'Alene, Kootenai, Nez Perce, Shoshone-Bannock, Sho- |
| Pai), IFPC, targeted agencies, organizations and groups, universities and state extension programs, UI |
| Extension, others |

[/TABLE]

[TABLE]
*STATEWIDE Key Strategies include: Goal 1: Inventory & Analysis and Treatments -Develop a statewide strategy to address climate change and anticipated impacts to forest conditions in Idaho. Include statewide inventory and analysis of conditions and targeted strategies across ownerships to improve resilience and to adapt to changing conditions. Continue strong partnership with County wildfire working groups. This current structure for implementing the National Fire Plan, Cohesive Strategy and Shared Stewardship efforts in Idaho is working well and will continue to facilitate effective planning and implementation of hazardous fuels treatments and restoration projects and enhance firefighting resources and public education. Partner with the Idaho Forest Products Commission on statewide marketing to aggressively promote Idaho forest products within and outside of the state. Develop a culture where Idaho products are a preference with consumers (similar to potatoes).*

| S&PF Programs: Forest Health, Forest Stewardship, Urban & Community Forestry, State Fire Assistance, |
| --- |
| Forest Legacy |
| Stakeholders: Associated Logging Contractors (ALC), Bureau of Land Management (BLM), IDL, NRCS, |
| Idaho Resource Conservation & Development (RC&D) organizations, Idaho Universities, S&PF Advisory |
| Groups, USFS, UI, UI Extension, other partners & groups |
| Goal 1: Inventory & Analysis, Treatments, Partnerships, Managed Fire, Education - |

[/TABLE]

[TABLE]
*Goals 2 and 3: Education, Planning and Regulation/Policy - Educate local governments, planning and zoning commissions, and insurance companies about the implications of location and types of development on forest resources. Emphasis should include the ramifications of development on wildland fire fighting, wildlife, long-term timber supplies, and true costs to local governments.*

| S&PF Programs: Forest Health, Forest Stewardship, Urban & Community Forestry, State Fire Assistance, |
| --- |
| Forest Legacy, Conservation Education |
| Stakeholders: BSCI, Cities, Counties, IDL, IFPC, PLT, targeted agencies, organizations and groups, UI |
| Extension |
| Goals 2 and 3: Education, Planning and Regulation/Policy -Work collaboratively to strengthen community |
| commitment to a healthy urban forest by encouraging the strategic planting of trees to mitigate |
| stormwater runoff and increase energy savings. Educate local governments about the qualitative |
| and quantitative benefits community forestry can provide and promote species diversity. |
| S&PF Programs: Forest Health, Forest Stewardship, Urban & Community Forestry, State Fire Assistance, |
| Forest Legacy, Conservation Education |

[/TABLE]

[TABLE]
*Key Strategies include: Goals 1, 2 and 3: Treatments, Partnerships, and Education -Capitalize on potential partnership efforts or funding opportunities for community forest health improvement. For example, transportation enhancement landscaping grants, a potential tree planting grant program through the Small Business Administration, an Energy Conservation Tree Planting grant program through the Department of Energy, and others. Continue to establish programs and funding mechanism designed to manage OHV use to help improve forest resources and provide for public access to forest lands. Work collaboratively to provide public education for responsible Off-Highway Vehicle (OHV) use and develop projects that effectively develop, maintain, improve and manage recreational OHV activities. Partner with land trusts and agencies to work collaboratively whenever possible to develop conservation efforts. Create economic incentives that increase hold values over sell values of priority forest areas.*

| S&PF Programs: Forest Health, Urban & Community Forestry, Conservation Education |
| --- |
| Stakeholders: Appropriate state and federal agencies, Arbor Day Foundation, Cities, Association of |
| Idaho Cities, Association of Landscape Architects (ID/MT Chapter), ICFAC, Idaho Nursery and Landscape |
| Association, International Society of Arboriculture (PNW Chapter), utilities, and others |
| Goals 2 and 3: Access, Education, and Regulation/Policy -S&PF Programs: Forest Legacy, Urban & Community Forestry, Forest Health, Forest Stewardship, and |
| State Fire Assistance |
| Stakeholders: BLM, Cities, Counties, Collaborative groups, IDL, Idaho Tribes, Land Trusts, NRCS, private |
| landowners, USFS, and many others |
| N - |

[/TABLE]

[TABLE: Identifies new strategies within the 2020 update Statewide Existing Plans and Resource Groups Existing Plans Idaho Comprehensive Wildlife Strategy Idaho Fire Plan • Forest Asset Management Plan • Forest Legacy Assessment of Need • County Wildfire Protection Plans • NRCS Rapid Watershed Assessment • Cumulative Watershed Effects Plans • DEQ Sub Basin Assessments and Total Maximum Daily Load Implementation Plans • Idaho Roadless Rule • Resource Conservation and Development Council Area Plans • Coordinated Resource Offering Protocol (CROP) • State Natural Hazard Mitigation Plan Resource Groups Idaho State Technical Committee • Idaho Departments of Fish and Game, Lands, Commerce, Parks and Recreation, Water Resources, Environmental Quality, Office of Energy Resources • US Forest Service • Natural Resources Conservation Service • US Fish and Wildlife Service • US Bureau of Land Management • US Corps of Engineers • Association of Idaho Cities • Idaho Counties Association • Idaho Coalition of Land Trusts • State and National Professional Associations • Idaho Forest Products Association • Associated Logging Contractors • Intermountain Forest Association • Local Governments]

[TABLE]
*State and Private Forestry Performance Measures Goal 2: The ecosystem benefits that Idaho forests provide are identified, maintained and enhanced Stakeholder Groups Coordinated with for the Statewide Assessment and Strategy: Note: this could be identified in the body of the documents or as an appendix.*

| State | ALC -Associated Logging Contractors AON -Assessment of Need (Forest Legacy National Goals & Priority Strategies Addressed | IFOA -Idaho Forest Owners Association IFSAC -Idaho Forest Stewardship Advisory |
| --- | --- | --- |
|  | Program) | Committee |
|  | ATFS -American Tree Farm System | ISFPWG -Idaho State Fire Plan Working Group |
|  | BLM -Bureau of Land Management | LFSP -Landowner Forest Stewardship Plan |
|  | BSCI -Building Sustainable Communities | NEPA -National Environmental Policy Act |
|  | Initiative | NFP -National Fire Plan |
|  | CFAA -Cooperative Forestry Assistance Act | NIPF -Non-Industrial Private Forestlands |
|  | CROP -Coordinated Resource Offering Protocol | NRCS -Natural Resources Conservation Service |
|  | CWCS -Comprehensive Wildlife Conservation | OHV -Off-Highway Vehicle |
|  | Strategy | PLA -Priority Landscape Area |
|  | CWPP -County Wildfire Protection Plan | RC&D -Resource, Conservation and Development |
|  | CWWG -County Wildfire Working Group | Council |
|  | ESA -Endangered Species Act | RFPA -Rangeland Fire Protection Associations |
|  | FAP -Forest Action Plan | S&PF -State and Private Forestry |
|  | FSC -Forest Stewardship Council | SLA -Special Landscape Area |
|  | ICFAC -Idaho Community Forestry Advisory | T&E -Federally listed threatened and |
|  | Council | endangered species |
|  | IDFG -Idaho Fish and Game | USDA -United States Department of Agriculture |
|  | IFPC -Idaho Forest Products Commission | USDOI -United States Department of Interior |
|  | IDL -Idaho Department of Lands | USFS -United States Forest Service |
|  | IDC -Idaho Department of Commerce | VOC -Volatile Organic Compound |
|  | IDPR -Idaho Parks and Recreation | WUI -Wildland Urban Interface |
|  | IFA -Intermountain Forest Association |  |

[/TABLE]

[TABLE]
*Forest Stewardship Coordinating Committee (required) .................................................... Yes  No ❑ Forest Stewardship representatives from the Idaho Lands Resource Coordination Council actively participated in subcommittees and group reviews provided technical expertise, data and editorial review of the FAP Assessment and Strategies documents. See appendix F for additional details. Gregg Servheen, Wildlife Program Coordinator with the Idaho Department of Fish and Game represented this agency on both the Core Assessment and Strategy Development Teams. His assistance was invaluable in providing the best available wildlife data and how best to model these data to identify areas in the state where forestry actions will have the greatest benefit to wildlife, and in developing appropriate strategies. A number of State Technical Committee members participated in the development of the State Forest Assessment and provided valuable feedback on formulation of the Strategies document.*

| State Wildlife Agency (required) ................................................................................................ Yes  No ❑ |
| --- |
| State Technical Committee (required)........................................................................................ Yes  No ❑ |
| Lead |

[/TABLE]

[TABLE: agency for the Forest Legacy Program (if not the state forestry agency) (required) ............. Yes  No ❑ The Idaho Department of Lands is the lead agency for the Forest Legacy Program. Legacy Program Specialist Karen Neorr participated as a member of both the Core Assessment and Core Strategy Development teams.]

[TABLE]
*Legacy Assessment of Need (check the one box below that applies)  Previously approved AON remains unchanged and is incorporated by reference ..... Yes  No ❑ Process for identification of Forest Stewardship Program priority areas is included as appendix j.*

| Forest The Legacy Assessment of Need (AON) is incorporated by reference |
| --- |
| OR |
|  Required AON |

[/TABLE]

[TABLE]
*components are included in the Assessment and Strategy (Note: AON elements will be evaluated outside the assessment and strategy certification process) It was the intent of the Idaho Department of Lands that the Idaho Forest Action Plan will serve as the Legacy Assessment of Need, all AON components are included in the Assessment and Strategy.Throughout the development of the Idaho Forest Action Plan, the Idaho Department of Lands engaged a broad group of stakeholders in addition to the Core Assessment and Strategy Teams. The larger stakeholder committee met many times over the past two years to provide guidance, review progress and recommend changes or modifications. The result is an Idaho Forest Action Plan that represents a broad array of stakeholders committed to working together to protect, conserve and enhance Idaho's forests.*

| Appendix F - |
| --- |

[/TABLE]

[TABLE]
*Moving to a Single Idaho Lands Resource Coordinating Council Structure (White Paper) The last few years have brought about a considerable change in state funding and program direction for Idaho Department of Lands (IDL) private forestry and fire bureau programs. State general fund reductions of 25% have required IDL to reduce bureau staffing levels, and to revisit how program assistance is delivered throughout Idaho. The 2008 Farm Bill formalized a shift in direction for USDA Forest Service (FS) State & Private Forestry (S&PF) programs (Forest Stewardship, Forest Legacy, Urban Forestry, Forest Health, State Fire Assistance and Volunteer Fire Assistance) that IDL delivers in partnership with the FS. Every state has been directed to prepare a State Assessment of Forest Resources and Statewide Forest Resource Strategy, collectively referred to as the state Forest Action Plan (FAP), with an emphasis on combining local, state and federal program resources to address forestry concerns collaboratively in identified Priority Landscape Areas. The Idaho FAP will help landowners and managers better recognize and support opportunities where working together and leveraging limited resources can address multiple critical issues of statewide importance. It is an objective of the FAP to serve as a springboard toward a more strategic, comprehensive and coordinated approach to forest management that addresses critical forest issues.*

| December 12, 2011 |
| --- |
| Issue Overview |

[/TABLE]

[TABLE]
* Historically, S&PF programs have operated independently, with specific program staff hired to oversee each, and program-specific advisory councils for Forest Stewardship (Idaho Forest Stewardship Advisory Committee), Fire-National Fire Plan (Idaho Fire Plan Working Group) and Urban Forestry (Idaho Community Forestry Advisory Council). The advisory councils are in a transition between focusing on what the original program direction mandated and the new direction as discussed above. The primary focus, past and present, of the three IDL advisory councils in supporting IDL program efforts follows:Formed in 2002, this group's primary focus to date has been hazard fuels reduction across all ownerships statewide. There has been an evolution from working with individual landowners to working with county government to coordinate county-wide activities. ISFPWG efforts have included extensive time working with counties to develop Community Wildfire Idaho Lands Resource Coordinating Council Protection Plans. ISFPWG currently focuses on coordinating different state and federal agency funding for hazardous fuels treatment (HFT) work. The group works with all lands that have potential for wildfire, not just forestlands. Communication and coordination amongst various local, state and federal agencies and organizations are key focus areas for this group. to Natural Resources Conservation Service (NRCS) funded programs with IDL involvement being primarily as a Technical Service Provider. Currently, this group's primary focus is information sharing within the committee, and outreach to non-industrial forest landowners, encouraging active management of private forestlands. They also provide project review and funding recommendations for the Idaho Forest Legacy Program.*

| Idaho Community Forestry Advisory Council (ICFAC) |
| --- |
| Idaho State Fire Plan Working Group (ISFPWG) |

[/TABLE]

[TABLE]
* USDA Forest Service -S&PF, USDI Bureau of Land Management, USDA National Forest Systems (fire staff), Natural Resources Conservation Service, Idaho Department of Fish and Game, Idaho Fire Chiefs, State Fire Marshal, Bureau of Homeland Security, University of Idaho Extension Forestry, University or College -urban planning or arborist program, Idaho Association of Counties, Association of Idaho Cities, Idaho Chapter -American Planning Association, Tribes, private forest landowners (Idaho Forest Owners Association), Idaho Tree Farm Committee, Idaho Coalition of Land Trusts or a conservation organization, Association of Consulting Foresters -Inland Empire Chapter, City forester, Idaho Nursery and Landscape Association or green industry, and a utility company representative.*

| Coordinating Council Operating Protocol |
| --- |
| • Council Leadership. A "Co-Leader" concept is recommended, consisting of an IDL staff member and a |
| Council member. The Council member serves as Chairperson and leads meetings. The IDL staffer |
| coordinates agendas, meeting arrangements, etc. |

[/TABLE]

[TABLE]
* Overarching focus should be "Healthy Forests for all Idahoans." Facilitate sound land management across all land ownerships through enhanced interaction between communities, private landowners, and local, state and federal agencies and related interest groups. Clarify roles of partners and collaborative groups.The goals and objectives outlined above provide a framework for Idaho's Forest Legacy Program and will be achieved through continued and effective implementation of the program. Furthermore, they can be used as a tool to measure Idaho's success in meeting its overall purpose, to maintain forested landscapes.To be eligible for Idaho's Forest Legacy Program, submitted applications must meet all of the following requirements:1. Project must meet one or more of Idaho's FLP goals. 2. Project must be within an Idaho Priority Landscape Area as identified in FAP. 3. Project must be sponsored by a state agency or a land trust organization. 4. Project must be privately owned (non-federal, State, or local government). 5. Project must be at least five (5) acres in size. 6. Project must include a minimum 25% cash or in-kind, non-federal match. The FLP will fund up to 75% of total program costs (acquisition costs plus other allowable expenses). A landowner that does not meet the match percentage as stated in their application by the closing date of a Forest Legacy acquisition will not be eligible to apply for FLP funding until the non-federal match has been met. 7. Project must be 75% forestland (defined as land with trees that has at least 10% canopy cover or formally had such tree cover and is not currently developed for non-forest use). 8. Landowners agree to follow federal FLP requirements and implementation rules including: a. Accepting an appraisal that meets standard federal appraisal guidelines. b. Managing the property by means of a Landowner Forest Stewardship Plan (LFSP) approved through the Idaho Forest Stewardship Program. c. Signing a perpetual conservation easement with the State of Idaho, with the stated purposes of maintaining, enhancing, and/or conserving in perpetuity the forestland and conservation values of the property. d. Allowing annual monitoring for conservation easement (CE) compliance.*

| Project Eligibility Requirements |
| --- |

[/TABLE]

Idaho Community Forestry Advisory Council, Idaho Forest Stewardship Advisory Committee, and Idaho National Fire Plan Working Group
USDA Forest Service. 2010. "State and Private Forestry Redesign". Washington, D.C. Available online at https://www.fs.usda.gov/about-agency/state-private-forestry
The guiding principles and core values for wildland fire management embodied within the Cohesive Strategy are listed in Appendix H on page 88.
Return to Table of Contents
The Idaho Lands Resource Coordinating Council (ILRCC) will assume advisory responsibilities for all of Idaho's State and Private Forestry Programs beginning in 2012. See page 26 and Appendix F on pages
79-81 for more information.
Acknowledgments 
....................................................................................................................
.

## Introduction

and 
Recreation IFA -Intermountain Forest Association IFOA -Idaho Forest Owners Association IFPC -Idaho Forest Products Commission PLT -Project Learning Tree NRCS -Natural Resource Conservation Service S&PF -State and Private Forestry UI -University of Idaho USFS -US Forest Service USFWS -US Fish and Wildlife Service WUI -Wildland Urban Interface
Ara Andrea ............................ 
Idaho Department of Lands Ann Bates
 .............................. 
Idaho Nursery and Landscape Association Gerry Bates
............................ 
South Idaho Community Forestry Assistant Michael Beaudoin………………..Idaho Department of Lands Norris Boothe………………………Coeur d' Alene Tribe
, 
Tribal Forester Bill Bosworth………………………..Idaho Department of Fish and Game Randy Brooks
 ........................ 
University of Idaho Extension Rita Chandler……………………….US Forest Service, Co-Op Fire Region 1 Eileen Clegg
 ........................... 
Association of Idaho Cities Susan Cleverly
 ....................... 
Idaho Office of Emergency Management
G. Kirk David .......................... Idaho Tree Farm Association Gina Davis ............................. USDA Forest Service John DeGroot ........................ Nez Perce Tribe Tom Eckberg .........................
. 
Idaho Department of Lands Amanda Eagan…………………….US Forest Service, Community Forestry Craig Foss
 .............................. 
Idaho Department of Lands Mary Fritz
 .............................. 
Idaho Department of Lands (Retired)
Janet Funk ............................. Idaho Tree Farms David Groeschl .....................
. 
Idaho Department of Lands, Asst
. Director-
Forestry & Fire (Former) Jeff Handel……………………………Nez Perce Tribe Fire Management Tyre Holfeltz
 .......................... 
Idaho Department of Lands Bob Howard………………………...Bonner County, Emergency Management Corrie Ivey
 ............................. 
Idaho Department of Lands Ken Knoch
 ............................. 
City of Ammon Parks and Forestry Ed Koch………………………………..Idaho Forest Owners Association Maurie Knott………………………..Idaho American Planners Association Don Major……………………………Bureau of Land Management Tim Maguire
 .......................... 
Ecosystem Sciences Foundation Robyn Miller
 .......................... The 
Nature Conservancy Andrew Mock……………………….Idaho Department of Lands Karen Neorr………………………….Idaho Department of Lands Lorrie Pahl…………………………….Idaho Office of Emergency Management Diana Rauschenbach
 ............. 
Idaho Department of Lands Knute Sandahl
 ....................... 
Idaho Fire Marshal Gordon Sanders
 .................... 
Idaho Forest Owners Association Hannah Sanger…………………….City of Pocatello Science and Environment Division Chris Schnepf
 ........................ 
University of Idaho Forestry Extension Greg Servheen
 ....................... 
Idaho Department of Fish and Game (Retired) David Stephenson
 ................. 
Idaho Department of Lands (Retired) Bob Unnasch
 ........................ The 
Nature Conservancy Janet Valle
 ............................. 
US Forest Service
, S&PF Regions 
1&4 Mike Wolcott ........................ Inland Forest
 Management
....................................................................................................................
Recreation IFA -Intermountain Forest Association IFOA -Idaho Forest Owners Association IFPC -Idaho Forest Products Commission PLT -Project Learning Tree NRCS -Natural Resource Conservation Service S&PF -State and Private Forestry UI -University of Idaho USFS -US Forest Service USFWS -US Fish and Wildlife Service WUI -Wildland Urban Interface
G. Kirk David .......................... Idaho Tree Farm Association Gina Davis ............................. USDA Forest Service John DeGroot ........................ Nez Perce Tribe Tom Eckberg .........................
Janet Funk ............................. Idaho Tree Farms David Groeschl .....................
Forestry & Fire (Former) Jeff Handel……………………………Nez Perce Tribe Fire Management Tyre Holfeltz
1&4 Mike Wolcott ........................ Inland Forest

## This page is intentionally blank

## Salmon-Challis Priority Landscape Area including SW Montana

The Salmon-Challis PLA includes the headwaters of the Salmon and Lemhi Rivers. The main population centers are Salmon, Challis and Stanley. The Beaverhead area of Montana is included in this PLA.

## Snake River Complex Priority Landscape Area

The Snake River Complex PLA encompasses the urban areas along the Snake River in central Idaho including Mountain Home, Gooding, Glenns Ferry, Jerome and Twin Falls.

## Forest Island Complex Priority Landscape Area

The Forest Island Complex includes the isolated forested areas of the Owyhees and the Sawtooth National Forest southeast of Twin Falls. 

## Resource Groups

Portneuf

## Return to Table of Contents

## Sage-Steppe Special Landscape Area

The Sage-Steppe Special Landscape Area (SLA) includes much of the rangeland areas in southern Idaho. While not included in the first iteration of FAP, issues surrounding the potential loss of this valuable ecosystem have gained increased attention. The boundaries of the Sage-Steppe SLA primarily follow the "core" and "important" habitat designation for the greater sage-grouse and include adjacent areas with significant departure from historic fire regimes and very high populations of invasive annual grasses.

## Appendices Appendix A -Definitions

Agroforestry -An integrated approach of using the interactive benefits from combining trees and shrubs with crops and/or livestock. It combines agricultural and forestry technologies to create more diverse, productive, profitable, healthy and sustainable land-use systems.
American Tree Farm System -A network of more than 83,000 woodland owners sustainably managing 26 million acres of forestland. It is the largest and oldest sustainable family woodland system in America, internationally recognized, meeting strict third-party certification standards.
Anadromous fish -Fish that live in the ocean mostly, and breed in fresh water (i.e. species of salmon).
Aquifer -An underground bed or layer of permeable rock, sediment, or soil that yields water.
Best management practices (BMPs) -A method or combination of methods that is an effective and practical way (technologically and economically) to prevent undesirable results.

## Biodiversity -

The number and variety of species of plant and animal life within a region.

## Biomass (woody) -

The trees and woody plants, including limbs, tops, needles, leaves, and other woody parts, grown in forest, woodland, or rangeland environments that are the byproducts of forest management.
Carbon sequestration -The process by which atmospheric carbon dioxide is absorbed by trees and other plants through photosynthesis and stored as carbon in biomass (trunks, branches, foliage, and roots), soils, and wood products. Adopting certain agricultural and forestry activities can reduce greenhouse gas (GHG) emissions to the atmosphere and sequester additional carbon.
Collaboration -A recursive process where two or more people or organizations work together in an intersection of common goals.
Collaborative group -A cooperative advisory group representing diverse interests organized to address land management issues and resolve conflicts within an identified area.
Conservation easement -A legally binding agreement that limits certain types of uses or prevents development from taking place on the land in perpetuity while the land remains in private hands.

## Coordinated Resource Offering Protocol (CROP)

-A projection of wood product offerings within and between agencies within an investor landscape.

## Development -

The increase in the density of residential, commercial or industrial structures on the landscape. Loss of productive urban and rural forests to development is a critical issue in Idaho.
Ecological restoration -The process of assisting the recovery of an ecosystem that has been degraded, damaged, or destroyed. The concept of ecological restoration is forward-looking. Restoration focuses on reestablishing composition, structure, and ecological processes to maintain or increase resilience of terrestrial and aquatic ecosystems in a dynamic, continually evolving world.
Ecosystem -An interacting system of living organisms, soil and climatic factors. Forests, wetlands, watersheds, ponds, prairies and communities are ecosystems. 

## Appendix C -2020 Stakeholders / Contributors

## Goals & Strategies

## National Priority Addressed

## State and Private Forestry Performance Measures Goal 1: Idaho's Forests are diverse and resilient to climatic changes and other natural and unique stresses

## Program Goals and Objectives:

In accordance with the federal Forest Legacy Program, the purpose of Idaho's Forest Legacy Program is to protect environmentally important forest areas and the public values they provide. Within this broad context, specific goals for the program are identified below.

## Goals

• Identify high priority forestlands in Idaho
• Maintain the cultural and economic stability of rural communities by conserving working forest landscapes
• Conserve and/or enhance water quality
• Maintain unique forest habitats
• Protect and provide habitat for native fish, wildlife and plants
• Protect the social values that forests provide such as public recreation, scenic, cultural and historical values
To achieve program goals and further leverage Idaho's conservation efforts, the following objectives will be used to direct the Forest Legacy Program in Idaho.

## Objectives

• Promote wildlife connectivity between undeveloped areas
• Focus efforts on projects with large areas of contiguous forest (>100 acres)
• Promote sustainable forest management practices (Landowner Forest Stewardship Plan (LFSP), Sustainable Forestry Initiative, Forest Stewardship Council (FSC), American Tree Farm System (ATFS), etc.)
• Contribute to a large-scale organized conservation plan (Yellowstone to Yukon, Idaho's Comprehensive Wildlife Conservation Strategy, etc.)
• Protect Threatened and Endangered (T&E) species habitat

## • Complement previous investments in forestland conservation

## Appendix H -Cohesive Strategy Guiding Principles and Core Values

Early in the planning process, stakeholders involved in developing the Cohesive Strategy collaboratively established the following guiding principles and core values for wildland fire management to guide fire and land management activities:
• Reducing risk to firefighters and the public is the first priority in every fire management activity.
• Sound risk management is the foundation for all management activities.
• Actively manage the land to make it more resilient to disturbance, in accordance with management objectives.
• Improve and sustain both community and individual responsibilities to prepare for, respond to and recover from wildfire through capacity-building activities.
• Rigorous wildfire prevention programs are supported across all jurisdictions.
• Wildland fire, as an essential ecological process and natural change agent, may be incorporated into the planning process and wildfire response.
• Fire management decisions are based on the best available science, knowledge, and experience, and used to evaluate risk versus gain.
• Local, state, tribal, and federal agencies support one another with wildfire response, including engagement in collaborative planning and the decision-making processes that take into account all lands and recognize the interdependence and statutory responsibilities among jurisdictions.
• Where land and resource management objectives differ, prudent and safe actions must be taken through collaborative fire planning and suppression response to keep unwanted wildfires from spreading to adjacent jurisdictions.
• Safe aggressive initial attack is often the best suppression strategy to keep unwanted wildfires small and cost down.
• Fire management programs and activities are economically viable and commensurate with values to be protected, land and resource management objectives, and social and environmental quality considerations.

## Appendix I -Idaho Shared Stewardship

## Idaho Shared Stewardship Agreement

On December 18, 2018, the State of Idaho executed a Shared Stewardship Agreement with the US Department of Agriculture (USDA) and the Forest Service Northern and Intermountain Regional Foresters. In alignment with the USDA's Shared Stewardship initiative, the purpose of this agreement was to foster collaborative work, between the State and the USDA Forest Service (USFS) to accomplish mutual goals, further common interests, and effectively respond to the increasing suite of challenges facing western forested landscapes-including the implementation of hazardous-fuels-reduction projects and efforts to improve forest-health conditions across broad Idaho landscapes. Specifically, this agreement stated goals of 1) identifying two meaningful landscape-scale project areas (priority landscapes), one in north Idaho and one in south Idaho; and 2) working together to double the annual acres treated through active management on national forests and promote cross-boundary work on other lands within priority landscapes.

## Idaho Shared Stewardship Priority Landscapes

The foundation of defining Idaho's first two Shared Stewardship Priority Landscapes (SSPLs) were the risk analyses depicted in this updated Forest Action Plan's (FAP) geospatial resource analyses. These composite heat maps provided a starting point for the Idaho Department of Lands (IDL) and USFS leaders to begin discussions on where these two SSPLs would be located. Integrated into this decision were additional similar forest-health, fire-risk and vegetation-condition geospatial data from the USFS and focused, fire-risk modeling outcomes from the USFS Rocky Mountain Research Station. These larger, two-million acre SSPLs were then spatially defined collaboratively by leadership at IDL and at the USFS Regional Offices and National Forest Supervisor Offices.

## Idaho Shared Stewardship Focal Areas

After the two larger SSPLs were geospatially defined, a series of meetings transpired to help define smaller, more focused Shared Stewardship Focal Areas where cross-boundary work would initially be planned and implemented. These meetings first took place in the north Idaho SSPL, with land managers and fire-management officers with the Idaho Panhandle National Forests (IPNF) meeting with bureau chiefs, operations chiefs, and program managers from the IDL as well as NRCS District Conservationists in the northern panhandle region-to focus on areas of forestland where forest-management and fuelsreduction treatments on federal, state and private lands were planned in the near future, and where these types of treatments had recently occurred and could be expanded on to create a more meaningful landscape-level effect of fire-risk mitigation. Fire-management personnel revealed where forest conditions could most benefit from treatments and where cross-boundary fuel-break treatments were already occurring. These discussions led to the decision to initiate the first "focal area" in north Idaho in Southwest Bonner County, adjacent to the planned Scattered Lands projects in the Sandpoint Ranger District of the IPNF.

## Idaho Shared Stewardship Action Plan

The Idaho Department of Lands (IDL) and the USFS are collaborating with willing private landowners to define and implement cross-boundary projects. Projects focus on the use of prescribed fire, fuel reduction, harvesting and thinning treatments. These methods are part of a holistic approach to reduce threats of wildfires and improve the health of Idaho's forests, rangelands and watersheds.
On October 3, 2019, Governor Little appointed a 19-member Shared Stewardship Advisory Group. The role and functions of the committee include:
• Identify process, policy, funding, and capacity barriers that impede implementation of Shared Stewardship in Idaho;
• Problem-solve and find creative solutions to the challenges identified;
• Act as a voice for various interests not on the Advisory Group;
• Develop metrics of success and a common set of Shared Stewardship principles; and 

## Idaho Shared Stewardship Cross-Boundary Projects

Strategic planning and implementation of cross-boundary projects within these three Shared Stewardship Focal Areas is starting in 2020, working towards the goals developed from multiple meetings consisting of "on-the-ground" land managers including the Idaho Department of Lands operational foresters, Good Neighbor foresters, and landowner-assistance foresters, as well as NRCS District Conservationists, county cooperators, USFS Ranger District staff, and county wildfire planning groups.

## Appendix J -Forest Stewardship Focal Area Designation Process

During federal fiscal year 2020 there was a change in policy as it relates to the delivery of the Forest Stewardship Program requiring the designation of specific focal areas where services will be provided.
To address this change, the Idaho Department of Lands (IDL) used the following process to delineate private forest acres and potential forested acreage lands within Idaho where Forest Stewardship Program services will be delivered to non-industrial private landowners.

## Private Forested Lands

To identify Forested Lands in Idaho, the IDL used the Landfire vegetation re-gap raster * . The vegetative type was consolidated to 'forest', 'brush', 'grass' and 'rock/barren/water'. The combinations of these types were further defined as 'forest-forest', 'forest-brush', 'forest-grass', 'brush-brush', 'brush-grass' and 'grass-grass'. All of the combinations that included forest were then used to identify forested areas within Idaho. The raster was then converted into a polygon using ESRI's Raster to Polygon tool in ArcMap. Areas classified as "forest" were then selected and exported as a Forested Lands polygon shapefile showing forested areas of Idaho.
To identify Private Lands within Idaho, the IDL used their Restricted Ownership The Dissolve tool in ESRI ArcMap was used to reduce the Forested Lands and the Private Lands shapefiles to a single polygon each. The Clip tool was then used to clip out the footprint of the Private Lands shapefile from the Forested Lands shapefile, resulting in a Private Forested Lands shapefile. From this, the IDL was able to identify that there are 4,575,264 acres of private forested land in Idaho.

## Non-Industrial Private Forest Lands

By practice in Idaho the Forest Stewardship Programs are used to assist non-industrial private forest owners. To identify the Non-Industrial Private Forest Lands in Idaho, the IDL used a similar methodology to the process described above for identifying Private Forested Lands. The same Forested Lands polygon was used for this analysis, but to identify Non-Industrial Private Lands, only areas classified as private landowner (no industrial timber organization without a mill or Indian Reservation) were selected and exported from the IDL's Restricted Ownership layer. The resulting shapefile, Non-Industrial Private Lands, was also dissolved into a single polygon, then intersected with the Forested Lands shapefile using the Clip tool to create a Non-Industrial Private Forest Lands layer. From this, the IDL was able to identify that there are 3,307,472 acres of non-industrial private forest lands within Idaho that Forest Stewardship Program services could be applied on.
Total value of resources leveraged through partnerships (monetary and in-kind)
Qualitative: Collaborative group and partnership success stories Education All 1. Percentage of at-risk communities who report increased local suppression capacity via more trained/certified fire fighters and/or crews 2. Number of people who annually participate in FS and S&PF and state forestry agency environmental literacy programs and activities 3. Percent of population within cities served by professional forestry staff
Number of people engaged in environmental stewardship activities as part of an S&PF program 1. Annual and cumulative acres of High priority forest ecosystems and landscapes are protected from conversion 2. Acres and percent of priority habitat areas where S&PF activities are protecting, conserving, and enhancing wildlife and fish habitat 3. Acres of connected forest resulting from S&PF investments
