## South Dakota Forest Action Plan

Section II:
Priority Area Description

## Introduction

The South Dakota Forest Action Plan acts as a road map for how to address threats or take advantage of opportunities within the different forest types across the State to accomplish the mission of the South Dakota Department of Agriculture, Resource Conservation and Forestry Division (RCF). The forest resource assessment (section I of the Forest Action Plan) defines what the major forest resources of South Dakota are and the values, threats, and opportunities associated with each. The priority areas identified in this section will aid in the efficacy and efficiency of accomplishing the RCF mission to protect, conserve, and enhance the natural resources of South Dakota. Priority areas will be reviewed and updated as needed to ensure the goals and objectives are being met. The sections III and IV will outline what those goals and objectives are, as well as specific strategies to accomplish those goals.

## Public Input

The priority areas identified for the current Forest Action Plan were developed in 2017. A public survey was sent out to all identified stakeholders and the public.

## NATIONAL THEME-ENHANCING PUBLIC BENEFITS FROM TREES AND FORESTS

## Riparian Areas of Concern

The "U.S. Rivers and Streams" (ESRI_DM, 2017) dataset provides a database of linear water features that interconnects and identifies the stream segments or reaches that comprise the surface water drainage system of United States. The dataset was digitized from 1:24,000 scale USGS topographic maps.
The navigable rivers and streams in South Dakota were first queried and separated from the US Rivers and Streams dataset for the Forest Action Plan. Intermittent streams (non-navigable) in northwestern South Dakota were added to the navigable streams dataset to reflect a critical streams area identified by the Nature Conservancy (TNC). The data was added from a shapefile provided by TNC. TNC identified this as an area of priority because local landowners have expressed concern about degrading intermittent stream areas and riparian zones and a desire to reverse the trend. Thus, this is an area of opportunity. TNC also expressed that there is some evidence that these areas provide critical sage grouse habitat. The resulting dataset was buffered by 400 feet to create the Riparian Areas of Concern dataset. This dataset was converted to ESRI Grid (raster) form and was used in the weighted overlay analysis.

## Agroforestry Suitability

The Agroforestry Suitability dataset was created from the USDA Natural Resource Conservation Service (NRCS) online Soil Survey, SSURGO soils geospatial database (USDA-NRCS, 2016). The SSURGO database contains digitized soil mapping unit polygons for all of South Dakota's 65 counties and contains individual soils tabular databases for each county. Each county soils tabular database contains dozens of fields, each representing unique soil properties.
The key field evaluated for agroforestry suitability was "Conservation Tree & Shrub Group". Soils in this field are rated for their ability to support trees and shrubs for field windbreaks and other agroforestry functions. There are ten primary groups and many specialized subgroups for each primary group. The top five (5) primary groups and associated subgroups were selected by query for South Dakota's agroforestry criteria. They were selected because these soils were best suited to grow the greatest variety of tree species. This was done for all of South Dakota's counties. The queried categories were identified on the map to form a vector dataset for each county.
To create the final data layer all vector datasets for each county are converted to a grid (raster dataset). Then each of these county level raster datasets were merged together to create the final statewide Agroforestry Suitability raster layer. This is used in the weighted overlay analysis.

## Priority Watersheds

Priority Watersheds in South Dakota were determined using the "319 Project Status" dataset produced by the South Dakota Department of Environment and Natural Resources (SD DENR).
SD DENR created this updated dataset from a combination of eight digit and 12 digit HUC watershed datasets, and scanned DENR 319 project maps.
The key attribute in this dataset is DENR Status, in which there are four watershed categories: Assessed, Assessing, Implemented, and Implementing. For the South Dakota Forest Action Plan only the "Implementing" DENR Status category is considered as "priority watersheds." Next, all selected watersheds that have a "DENR status" of Implementing are reclassified to a value of "1" all other watersheds are reclassified to a value of "0" Then this vector dataset is converted to a raster dataset consisting of values of 1 and 0.
This raster based "Priority Watersheds" dataset was used in the weighted overlay analysis.

## Public Drinking Water Supply

The South Dakota Public Drinking Water Supplies data layer was extracted from the Statewide Source Water Assessment Program (SWAP). SD DENR utilized "Hydrologic modeling" concepts, and watershed data to create this dataset along with United States Geological Survey (USGS) delineated watersheds in the Black Hills region.
The key field in the Statewide SWAP dataset is the "zone" field which is actually called "Priority Zone". There are three categories: Zone A, Zone B, and Zone C. Zone "A" is considered the critical zone where community drinking water originates.
In the Black Hills area this includes recharge area for wellheads and 1/4 mile buffers around perennial streams feeding communities up to 10 miles upstream. Zone B is not as critical as zone A but is important because groundwater in zone B watersheds flows into zone A. Zone B is the remaining priority watersheds in the Black Hills area. In the greater Missouri watersheds, Zone B is buffered within 25 miles of the wellheads, within the confines of the watershed boundaries. Zone C is the remainder of the greater Missouri River watersheds and is not considered critical or a priority zone.
Zones A and B were used for the purpose of the state's Forest Action Plan. These zones are reclassified to a value of "1". Zone C and the remainder of the state is reclassified to a value of "0". This vector layer now consisting of values of 1 and 0 are converted to a raster dataset. This new raster based "Public Drinking Water Supply Sources" layer was used in the weighted overlay analysis. The dataset contains point, line, and polygon vector attributes for all of South Dakota's species of special concern.

## Species of Special Concern

We focused on forest obligates for South Dakota's Forest Action plan. These species rely on forests or trees. They were queried from the dataset to create a subset data layer. We also obtained a separate GIS dataset showing recorded locations of the Northern Long-eared bat. These two datasets were merged then reclassified, "1" for locations of "Species of Special Concern" and "0" for NoData. This vector dataset was converted to a grid (raster dataset) to be used in the weighted overlay analysis.

## Incorporated Urban Municipalities at Risk

South Dakota contains many incorporated urban municipalities that are at risk due to many factors.
The first task was to identify all of South Dakota's urban municipalities. Urban communities are assessed a risk level based on five (5) criteria.
1 -Whether communities are a Managing, Developing, or None. These categories are defined by the U.S. Forest Service Community Accomplishment Reporting System (CARS). Managing communities are defined as (1) having active urban and community tree and forest management plans; (2) employing or retaining through written agreement the services of professional forestry staff; (3) adopting local/statewide ordinances or policies that focus on planting, protecting, and maintaining their urban and community trees and forests; and (4) having local advocacy/advisory organizations, such as active tree boards, commissions, or nonprofit organizations. Developing communities are defined as having between one and three of the above categories. If the municipality falls in the "None" category, they could have none or one of the above categories and the municipality did not receive any assistance from the RC&F within the past fiscal year.
2. The communities were sorted into three classes based on population. The three classes and ratings are: Class 1 -5,000 and over is rated low; Class 2 -500 to 5000 rated moderate; and Class 3 -Less than 500 is rated high. Then, within each class, the total number of high risk trees was divided by the total number of trees.
Formula (Within each population class):
(Total # of high-risk trees / total # of trees) X 100 The last step is to assign the expanded risk priority rating to each community based on the five criteria listed above. The expanded risk rating is parsed into three categories: High, Medium, and Low. The initial rating given to each urban municipality is based on the percentage of human population and their number of high-risk tree species as described in criteria 2. Next it is then adjusted "expanded" higher or lower when compared to the other four criteria. A community could have a large percentage of high risk tree species but be given a low rating if they are "managing" their urban forest and/or are a Tree City USA.
Expanded High Priority communities
• The community has a high percentage of high-risk tree species (as determined by the formula in criteria 2).
• The community does not have a community forestry program (not "Managing" or "Developing" according to CARS).
• The community lies within or near a Black Hills WUI area.
• The community falls within a projected developing area of concern.
• The community is not a Tree City USA.

## Expanded Medium Priority Communities

• The community has a medium to high percentage of high-risk tree species (as determined by the formula in criteria 2).
• The community either has a community forestry program or is developing one.
• The community falls into a projected developing area of concern but is a Tree City USA.
• The community is not within a projected developing area of concern and is not a Tree City USA.

## Expanded Low Priority communities

• The community has a low percentage of high-risk tree species (as determined by the formula in criteria 2).
• The community has an established community forest management program or is developing one as defined by CARS even if it is adjacent to a Black Hills WUI.
• The community is a Tree City USA.
For example, Sturgis was given a "high" risk rating based initially on criteria 2 due to its high volume of high-risk trees compared to the total trees within community class 1. Sturgis was dropped to medium based on criteria 1 and 5 (Sturgis is a managing community and a Tree City USA community). Hot Springs, however, was given an initial rating of "medium" based on criteria 2 but was bumped up "expanded" to "high" rating because of criteria 4 (it is a Black Hills WUI).
The urban communities that were given a final expanded risk rating of "high" were used in the Forest Action Plan's weighted overlay analysis.

## NATIONAL THEME-PROTECTING FORESTS FROM HARM

## Areas Threatened by Increased Housing Density: 2000 to 2030

To measure threat of development we focused is on increasing housing density.
Housing density reflects the change in the rural landscape more accurately than population density alone. Projections of future housing density increases on rural forest lands were used by "From the Forest to the Faucets: Drinking Water and Forests in the US, Methods Paper" 
(Weidner, 2016)
 to quantify the threat of development across US forests.
The "Forests to Faucets" data includes two files, one representing the data inputs, "F2F_Inputs.dbf" and one representing the data outputs, "F2F_outputs.dbf." In each file the unique row identifier is the 12-digit HUC code," HUC1." To view the data spatially, we downloaded the 12-digit HUC vector data from NRCS (
http://datagateway.nrcs.usda.gov
) (USGS: NRCS) and joined the DBF tables using the HUC code as the unique identifier to be consistent with the "From the Forests to the Faucet: Drinking Water and Forests in the US" methods paper 
(Weidner, 2016)
.
The key attribute that was used from the "F2F_inputs.dbf" file is the 3PER_DEV: Percent of HUC highly threatened by development (using Dave Theobald's data for predicted housing density increase).
This analysis used data layers produced by 
Stein et al. (2009)
, who processed data from Theobald's housing density models (SERGoM V3) 
(Weidner, 2016)
(Theobald 2009)
 to create 3 categories. A GIS layer was created showing expected increase in housing development between the years 2000 and 2030 from this data. The three categories are "Rural 1" (> 40 acres per housing unit), "Rural 2" (10-40 acres per housing unit) or "Exurban Rural" (> 10 acres per housing unit). Any change from Rural 1 to Rural 2, Rural 2 to Exurban, or Rural 1 to Exurban are considered as areas "Highly Threatened' by development.
Roughly 26% of the continental US, and 15% of forest lands fall into this "Highly Threatened" category. If any percentage of a sub-watershed (12 Digit HUC) demonstrated an increase in housing density, the watershed was selected as threatened by development.
Using the key attribute that was used from the "F2F_inputs.dbf" file that was joined to the 12-digit HUC, the "PER_DEV3" field was queried for any value greater than zero. The selected fields were then reclassified to a value of 1 and the non-selected sub-watersheds assigned a value of zero. The final data is converted to raster for use in the weighted overlay analysis.

## Wildfire Threats "Red Zones"

The Wildfire Assessment Layer (Red Zone Layer) was extracted from the reclassified Risk, Hazard, and Value (RHV) dataset for South Dakota. Those areas that were classified as "High Risk" for wildfire occurrence are considered critical for the past Stewardship Spatial Analysis Project and are important layer for the Forest Action Plan.
The Reclassified RHV (risk, hazard, value) layer for South Dakota was created by overlaying the Wildfire Risk Grid, the Wildfire Hazards Grid, and the Social Value Grid.
The Wildfire Risk Grid was extracted from 10 years of past wildfire occurrences. These past wildfire ignition points were overlaid over a regular grid and a spatial join was used to determine the grid cells with the most ignition points. This resulted in a raster grid that contained grid cells that were ranked low, medium and high depending on how many ignition points the grid cells contained.
The Wildfire Hazard Grid was created from overlying vegetation fuels loading hazards and vegetation disturbance regimes hazards. Vegetation fuels loading and disturbance regimes were derived from the NLCD dataset. Each was given a hazard fuels rating from low, medium, high, and extreme.
The Social Value Grid was created by extracting "Housing Density" from the 2000 Census inventory. Housing density was ranked from low, medium, and high.
These three grids were then combined in the weighted overlay analysis to create the initial Wildfire Assessment raster layer which had grid values ranging from 1 to 13. This initial raster was reclassified using the Jenks algorithm into 3 threats categories; low, medium and high. The wildfire red zone mapping raster was reclassified so that low and medium were given the value of "0" and the high threats were given a value of "1".

## Potential for Insects and Disease Risks

South Dakota's treed land accounts for 10% of the state. Of that treed land, 18% is at risk from insects and disease according to the Forest Health Technology Enterprise Team (FHTET).
This data layer depicts the Potential for Percent Total Basal Area Loss (TBAL) of all forestland. South Dakota Forest Action Plan is concerned with the risk of potential total basal area loss of 30% or greater due to insects and disease threats within forested areas. The definition of Total Basal Area Loss is the total amount of timber square footage that would be killed by potential insect and disease threats. One commenter requested RCF exclude native grasslands from all tree planting sites. RCF reviews tree planting plans for objectives, function, and design. We do not have the authority to deny tree planting plans based on land use.

## Weighting Alternatives

To create the 2017 Priority Areas dataset and map for the Forest Action Plan, several important raster datasets were selected for weighted overlay analysis. Several weighting alternatives were set up to create the initial set of maps ranging from; "All Included Data", "Forest Threats", "Forest Benefits", "Areas of Importance", "Equally Weighted", and Riparian Emphasis". The resulting raster datasets were stratified into three priorities, low, medium, and high using the natural breaks (Jenks) algorithm. The alternatives that were analyzed produced high priority rankings for the Black Hills region on every alternative. This diluted the results for the rest of the state by ranking two different ecosystems together instead of separately. It was decided to mask out the area of the Black Hills in order to analyze the data within the prairie ecosystem by itself. This method let us compare the scattered forest resources in the rest of the state to each other instead of ranking them with the concentrated resource in the Black Hills. The unmasked "Weighting Alternative 2: Forest Threats" ( To compensate, a mask was created and applied to the Black Hills area which allowed the result of the weighting alternatives to be visible across the rest of the state. This mask was created by digitizing a polygon around the Black Hills region (Figure 
3
.5.3), and then the vector mask was converted to raster, and was applied to the Black Hills area. The alternative that provided the best solution was the modified "riparian emphasis" model (Figure 
3
.5.4.) This alternative added weight to the buffered riparian areas and emphasized riparian areas in the northwestern part of the state. It also evenly emphasized the remaining data layers. The resulting raster map from this model was stratified into low, medium, and high priorities using the natural breaks (Jenks) algorithm 
(Figure 3.5.5.)
 This Model shows the priority watersheds across the state, increased housing density areas, source water supply zones, and buffered riparian areas in the central and northwest part of the state.
After this alternative was run, the masked out Black Hills region was added as a High priority area. The resulting raster is shown in Figure 
3
.5.6. A 12 digit Hydrologic Unit Code (HUC) (HUC level 6; Sub-Watershed) layer was used to outline the high priority areas. This was done by reclassifying the low and medium areas to zero values and the high priority areas to value of "1". Then this reclassified raster layer is converted to vector data with only 2 values, "0" and "1" (high priority). Using the Identity Overlay Function in Arc/Map, the high value data layer is merged with the 12 digit HUC layer (Figure 
3
.5.7). This "Identity" merged layer is queried to select watersheds that contain at least 50% of the area within the 12 digit HUC ranked as "high priority". These 12 digit HUC watersheds selected were "filled in" so the watersheds became a solid polygon (Figure 
3
.5.8). The next step was to merge this "high priority" watershed layer with the high, medium and low priority ranking raster layer to display all three (high, medium and low) priority areas. The high priority watershed vector dataset is converted back into a raster dataset. Those areas that are high priority are reclassified to a value of "10" and the rest of the areas were reclassified as a "0". The two raster datasets were added together. This resulting raster was reclassified into another raster and the high priority areas are given a "3", the medium priority areas were given a "2" and the low priority areas were given a "1", and colored red, yellow and green respectively (Figure 
3
.5.9). To complete the final map the total forested acres were calculated for each priority area. This was accomplished by creating an "Identity" overlay was performed using the all forested lands dataset and the priority areas dataset. From this dataset the acres of forested lands in high, medium, and low priority areas, and the acres of non-forested lands in high, medium, and low priority areas were calculated. These values are placed in the table embedded in the "Priority Areas" map, to be used in the Forest Action Plan. 

## Priority Area Percentages

The distribution of priority area weights presented in Figure 
B
.5.4 provided the best interaction among the data layers. No single data layer is high priority unless it combines with some other layer such as enhanced riparian areas, all forested lands, priority watersheds, and public water drinking water supply sources. There is an acceptable distribution of forest land and total land area in low, medium, and high priority areas as illustrated in table 4.1.1. 

## Multi-State Priorities and Opportunities

The surrounding six states were considered when looking at multi-state priorities and potential for project opportunities. All adjacent states cited at least one priority area that touched the border with South Dakota in their previous forest action plans, except for Montana.

## IOWA

Iowa cited two areas that were priorities on or within the South Dakota Border.

## Karst Topography

-area with a geology of limestone or other soluble rock that is characterized by caves, sinkholes, and sinking streams.
The Karst topography map in Iowa's forest action plan shows some of the Karst topography as wholly in South Dakota. The Karst topography that Iowa is concerned with borders Minnesota and Wisconsin. The area on the South Dakota/Iowa border is not currently a priority for Iowa.

## Issues associated with this area:

• The porous landscape prevents adequate filtering of water that usually takes place through soil layers. Therefore, groundwater quality is greatly threatened by the type of land use occurring. The loss of forest land in this area and the lack of forest management have led to water quality problems in this region.
• Karst areas contain many protected or sensitive species, usually associated with caves. Lack of forest management activities is a concern for the forest habitats of is area. Issues associated with this area:
• Water Pollution --Sediment, nitrogen and phosphorus are the main pollutants in the Upper Mississippi watershed. A significant portion of sediment, nitrogen and phosphorus loads in the Mississippi River comes from human activities: runoff and groundwater from farming, discharges from sewage treatment and industrial wastewater plants, and storm water runoff from city streets. The delivery of high amounts of nitrogen to the Gulf of Mexico causes a hypoxia zone (abnormally low levels of dissolved oxygen in bottom waters) to expand each summer. About 90% of the nitrate load to the Gulf of Mexico comes from nonpoint sources, and over 31% of that load comes from the Upper Mississippi River.
• Loss of Migratory Bird Habitat--The north-to-south orientation of the Upper Mississippi River and its contiguous habitat make it critical to the life cycles of many migratory birds. It is a globally important migratory flyway for 40 percent of all North American waterfowl and 60 percent of all the bird species in North America. The loss of more than 50% of historic floodplain and valley hardwood forests creates a problem for many waterfowl, raptors, songbirds, and shorebirds.
• Forest Loss and Fragmentation--Forests and prairies are the most beneficial land uses in the Upper Mississippi River Basin in terms of protecting watersheds and water quality. Nearly all the prairies and about 70 percent of the forest land have been converted to agriculture and urban land uses. The remaining forest land is critical to watershed health and clean water. The ability of forests to produce abundant clean water declines as they are broken up (fragmented) and eventually lost. Fragmentation is a process where large, contiguous forest landscapes are broken into smaller, more isolated pieces, often surrounded by human-dominated uses. The loss and continued break up of forest land increasingly impairs water flow and quality, forest health and diversity, and other economic and recreational benefits.

## MINNESOTA

## Midwest Glacial Lakes Partnership

The Midwest Glacial Lakes Partnership works together to protect, rehabilitate, and enhance sustainable fish habitats in glacial lakes greater than 10 acres in size that occur in Minnesota, Wisconsin, Michigan, North Dakota, South Dakota, Iowa, Illinois and Indiana.
In South Dakota, Game Fish and Parks is currently a partner in this group.
The goals of the partnership are to:
• protect and maintain intact and healthy lake systems;
• prevent further degradation of fish habitats that have been adversely affected
• reverse declines in the quality and quantity of aquatic habitats in lakes to improve the overall health of fish and other aquatic organisms
• increase the quality and quantity of fish habitats in lakes that support a broad natural diversity of fish and other aquatic species 

## Red River Basin Watershed

The Red River Basin encompasses both the United States and Canada including three states of Minnesota, North Dakota, South Dakota and one province Manitoba. Due to nature and rarity of the river flowing north and the flat topography, this river basin is prone to extremes in flooding and drought. Over the years there have been many collaborative efforts aimed at mitigation, flood planning/mapping, data collection and integration, river, soil erosion and bank restoration.
In Issues associated with this area:
• Land fragmentation due to ownership The northern reaches of the corridor generally do not include the hickories, black oak, chinkapin oak, red mulberry and redbud. There are 11 state-listed species that occur within the Missouri River corridor, six of which are also federally listed. Most of the floodplain's riparian forests have been converted to cropland. The Nebraska Game and Parks Commission (NGPC) designated several biologically unique landscapes in this area as part of its 2005 Nebraska Natural Legacy Project: Missouri River, Indian Bluffs, Ponca Bluffs, Rulo Bluffs and Thurston-Dakota Bluffs. This area was also designated as a priority under Nebraska's Forest Legacy Program.

## Issues associated with this area:

• Steep decline in gallery cottonwood forest type, with negative ecological and economic impacts.
• High-grading timber harvests (repeatedly removing only the highest quality trees while leaving poorest quality trees).
• Heavy infestations of invasive woody species (Russian olive, honeysuckle) and aggressive native species (eastern red cedar).
• Livestock grazing affecting forest health and sustainability.
• High wildlife values for uncommon and/ or migratory bird species and other mammals and reptiles of concern.
• Herbicide damage from agricultural chemicals.
• Increasing development and fragmentation of forest and woodlands.
• High concentration of green ash and black walnut at risk to EAB and thousand cankers disease, respectively.

## NORTH DAKOTA

Two high priority landscapes were identified in the North Dakota Forest Action Plan. These priority areas coincide with priority landscapes identified on figure 4.0.1. The North Dakota plan cited resource concerns including over-mature cottonwood trees on the Missouri River and an overabundance of green ash on the landscape.

## Issues associated with this area:

• Overabundance of ash trees threatened by emerald ash borer • Over-maturity of cottonwood trees in riparian areas • Aging windbreaks and shelterbelts in need of renovation • Loss of windbreaks and shelterbelts to crop production 

## WYOMING

The Black Hills is a high priority landscape for South Dakota and expands well into Wyoming's northeast corner. Recent mountain pine beetle epidemics have proven that multi-state efforts are effective and necessary in this ecosystem. Insects and other natural disturbances do not recognize state or ownership boundaries; therefore, collaboration is crucial in mitigating the impacts from those disturbances.

## Issues associated with this area:

• Mountain pine beetle and other bark beetle outbreaks • Land fragmentation due to ownership • Catastrophic wildfire • Wildland urban interface and heavy fuel loads 

## Stewardship Priority Areas

The Forest Stewardship Program promotes the long-term stewardship of important State and private forest landscapes. In South Dakota this is achieved is primarily through landowner assistance and writing forest management plans to encourage proactive management of the private forest resources. Lands considered eligible for forest stewardship include rural lands and wildland urban interface, with existing tree cover or suitable for growing trees, that is owned or leased long-term by any private individual or non-governmental organization. The 2018 direction for state forest action plans require that no more than 50% of the lands eligible for forest stewardship fall within areas considered high priority.
The current stewardship eligible priority lands make up 38.7% (17,102,418 acres) of all eligible stewardship acres in the State (44,189,063 acres).

## Conclusion

The priority areas identified in South Dakota, and along the borders with neighboring states considered the recommendations of various groups, stakeholders, and the public. Through outreach efforts and stakeholder group meetings, and with direction from the USDA State and Private Forestry and the National Association of State Foresters, 10-data layers were chosen and given a weighted percentage to determine where efforts should be directed to most effectively accomplish the mission of resource conservation, protection, and

[FIGURE: Species of Special Concern data comes from the South Dakota National Heritage Program as of July 2016. South Dakota Department of Game, Fish, & Parks, Wildlife Division (GFP) maintains this dataset and converted the GIS data to ArcGIS/ArcMap.]

[FIGURE: -Are they located in the projected developing areas of concern by 2030. (Based on Increased Housing Density Map B.3.1)) 4 -Are they located within a Black Hills wildland urban interface (WUI) designation. (Figure 1.11, Conifer Assessment) 5 -Are they a Tree City USA community.]

[FIGURE: Figure B.5.1, and the map results, Figure B.5.2 alternative weighting percentages) as compared to the masked data of "Weighting Alternative 2: Forest Threats" Figure B.5.3, as an example shows the differences in analysis.]

[FIGURE: Figure 3.5.1: "Weighting Alternative 2: Forest Threats"]

[FIGURE: Figure 3.5.4 Black Hills & Hogbacks Mask.]

[FIGURE: Figure 3.5.5 Modified "Riparian Emphasis" Alternative.]

[FIGURE: Figure 3.5.6 "Riparian Emphasis" model results with application of Black Hills mask]

[FIGURE: Figure 3.5.7 "Riparian Emphasis Model" Priority area map with Black Hills added as a High Priority area]

[FIGURE: Figure 3.5.8 High priority areas displayed with 12 digit HUC boundaries.]

[FIGURE: Figure 3.5.9 12 Digit HUC watersheds containing at least 50 percent priority area are designated as high priority watersheds]

[FIGURE: Figure 3.5.10 Reclassified raster containing high, medium, and low priority designation]

[FIGURE: Figure 4.0.2. Final map displaying high, medium, and low priority areas with Forest Legacy Areas in South Dakota.]

[FIGURE: Figure 5.1.1 Karst Topography in Green (Iowa Forest Action Plan, p. 224, 2010) 5.1.2. Upper Mississippi Watershed -All of the watersheds that drain into the Mississippi River in the upper Midwest are included as priority areas. In South Dakota this area includes the Little Minnesota River (Figure 5.1.2), the North and South Forks of the Whetstone River, the North and South Forks of the Yellow Bank River and the North Fork of the Lac que Parle River. These rivers are located primarily in Marshall, Roberts, Grant, and Duel counties and flow into the Minnesota River.]

[FIGURE: Figure 5.1.2 The Little Minnesota River Watershed (Wikipedia, 2017)]

[FIGURE: Figure 5.2.1 Level III Ecoregions of the Midwest Glacial Lakes Partnership Area (Omerick, 1987).]

[FIGURE: Figure 5.4.1 Nebraska's Missouri River Priority Forest Landscape (Nebraska Forest Action Plan, p. 86, 2015)]

[FIGURE: Figure 5.5.1 Priority Areas for North Dakota (North Dakota Forest Action Plan, p. 53, 2010)]

[FIGURE: Figure 5.6.1 GIS Analysis and Assessment of Wyoming's State Forest Resources and Priority Landscapes (Wyoming Forest Action Plan, 2019)]

[FIGURE: Figure 6.1 Map of stewardship priority areas related to all lands eligible for stewardship. (SDDA, 2017)]

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

[TABLE]
*4 Data Sets Considered but Not Used This dataset was created from the National Insects and Disease Risk Maps dataset, FHTET Online Portal https://www.fs.fed.us/foresthealth/technology/nidrm2012.shtml & https://foresthealth.fs.usda.gov/nidrm using the "Composite hazard from all pests" layer. From this layer, the Percent Total Basal Area Loss (pct_tbaloss) layer was stratified into five categories: 0% to 5%, 5% to 15%, 15% to 25%, 25% to 35%, and 35% and greater. The values were reclassified into two categories; 0% to 30%, and 30% and greater. Areas with 30% TBAL and greater were assigned a "1" and those areas with TBAL less than 30% a "0". The rest of the state that contained NoData values were classified "0". This final dataset is used in the weighted overlay analysis.*

| Spatial Data Set | Rationale |
| --- | --- |
| Critical Slope | Affected very little area and high- |
|  | lead cable logging companies |
|  | expanded access. |
| Healthy Forest Restoration Act | Subset of All Forested Lands data |
| (HFRA) Section 602 designated | set; created duplicate emphasis |
| areas |  |
| Forested Wetlands | Subset of All Forested Lands data |
|  | set; created duplicate emphasis |
| Grouped Forest Patches | Subset of All Forested Lands data |
|  | set; created duplicate emphasis |
| Proximity to Public Lands | Duplication in forested areas; |
|  | created false emphasis outside of |
|  | forested areas |
| Federal Forest Lands | Subset of All Forested Lands data |
|  | set; created duplicate emphasis |
| Private Forest Lands | Subset of All Forested Lands data |
|  | set; created duplicate emphasis |
| State and Private Forest Lands | Subset of All Forested Lands data |
|  | set; created duplicate emphasis |
| Wildland Urban Interface | Duplicates Wildfire Threats data set |
| South Dakota State University |  |
| Grasslands |  |

[/TABLE]

[TABLE: Table 4 ]

[TABLE]
*1 Custer Gallatin National Forest, Sioux Ranger District An South Dakota this involves the Bois De Sioux River in north eastern Roberts County. area known as the east short pines in Harding County in the Northwest corner of South Dakota is part of the Custer Gallatin National Forest (CGNF). Unlike the Black Hills National Forest, which is part of Forest Service Region 2, this National Forest is in Region 1, and its Forest Supervisor headquarters is in Bozeman, MT. With the potential for Good Neighbor Authority projects, collaboration with the Forest Service to accomplish forest management work on these tracts of land presents new opportunities.*

| 5.3 MONTANA |
| --- |
| 5.3. |

[/TABLE]

[TABLE]
* South Sioux City is a Nebraska multistate priority area with South Dakota and Iowa.The Missouri River extends along the eastern edge of Nebraska from the Nebraska/Kansas border to the Nebraska/South Dakota border. Upland deciduous forests cover the bluffs and loess hills adjacent to the Missouri River and rolling uplands along the Missouri River Corridor.Most of these forests are classified as oak-hickory (Carya spp.) forests and contain species typical of central hardwood forests. However, the mix and diversity of forest species depends on latitude. For example, the upland deciduous forests in the southern section of the Missouri River corridor often include northern red oak (Quercus rubra), black oak (Quercus velutina), bur oak (Quercus macrocarpa),*

| 5.4 NEBRASKA |
| --- |
| 5.4.1 Missouri River |

[/TABLE]

Figure 4.0.1. Final map displaying high, medium, and low priority areas in South Dakota.
The first step in developing the priority areas map was to update the geospatial data layers used to determine the priority area in the 2010 Forest Action Plan. The updated data layers included 
Agroforestry Suitability, All Forested Lands, Non-Federal Forested Lands, Housing Density
, 
Riparian Areas
, 
Priority Watersheds
, 
Public Drinking Water
 supply, 
Wildland Fire Threats
, 
National Insects and Disease Risks, Species of Special Concern, and Urban and Community Forestry
.

## NATIONAL THEME-CONSERVING RURAL FORESTS

## South Dakota All Forested Lands

The result is displayed in Figure 4.0.1 as the South Dakota Forest Action Plan, 2017 -present Priority Areas
Composite hazard from all pests (ArcINFO GRID format, Zipped file), 2012 National Insect & Disease Risk Maps/Data Products
Literature Cited 2017 -2027 National Insect and Disease Risk Map Viewer. 2017. USDA Forest Service: Forest Health Assessment and Applied Science Team (FHAAST) Map and Image Services
Jan. 2017. Jan. 2017
USDA Forest Service
Forest Health Technology Enterprise Team (FHTET
Helen
Cozzetto
Minnesota Forest Action Plan; Minnesota Forest Resource Assessment: Important facts, information, trends and conditions about Minnesota's Forests
2010
Fire Management Plan. ESRI, ArcGIS
Custer Gallatin National Forest
2016. id=8206e517c2264bb39b4a0780462d5b e1> Accessed Feb. 2017
Get the Forest to Faucets Data…" Web hyperlink
Ecosystem Services & Markets
F2f_Inputs
Dbf
F2f_Outputs
Dbf
Washington, DC
USDA Forest Service
2016. April 2016
Data Readme File
Aron
Flickinger
Iowa Forest Action Plan; Iowa's Forests Today: An Assessment of the Issues and Strategies for Conserving and Maintaining Iowa's Forests. Forest to Faucets, USDA Forest Service, Cooperative Forestry
Washington, DC
2009. 2016. April 2016
Ecosystem Services & Markets
Scott
Josiah
Nebraska Statewide Forest Action Plan
2015
Larry
Kotchman
North Dakota Forest Action Plan; Statewide Assessment of Forest Resources and Forest Resource Strategy
2010
U.S. Geological Survey, Earth Resources Observation and Science Center
Landfire Evt
2014. May 2017
Sioux Falls, SD
A
Mckerrow
J
Dewitz
D
Long
K
Nelson
J
Connot
J
Smith
A Comparison of NLCD 2011 and LANDFIRE EVT 2010: Regional and National Summaries
2016
J
M
Omernik
Ecoregions of the conterminous United States. Map (scale 1:7,500,000)
1987
77
Source Water Assessment Program Geodatabase
2016
South Dakota Department of Environment and Natural Resources
Dakota
South
Game
Fish
Parks
South Dakota Heritage Program, 2016. Threatened and Endangered Species Geodatabase
S
R
Stein
L
Mcroberts
M
Mahal
R
Carr
S
Alig
D
Comas
A
Theobald
Cundiff
PNW-GTR-795
Private Forests, Public Benefits: Increased Housing Density and Other Pressures on Private Forest Contributions
2009. December 2009
USDA Forest Service, Pacific Northwest Research Station
Landscape patterns of exurban growth in the USA from 1980 to 2020
D
Theobald
Ecology and Society
10
1
32
2005
USDA Natural Resource Conservation Service Web portal. 2016. U.S. Department of Agriculture: Natural Resource Conservation Service (NRCS)
May 2016. 2016
USDA Natural Resource Conservation Service: Geospatial Data Gateway. 12-digit HUC vector dataset
ESRI Data & Maps, National Atlas of the United States and the United States Geological Survey
U.S. Rivers and Streams
2017
Ecosystem Services & Markets Program Area State and Private Forestry
E
Weidner
A
Todd
Methods Paper
2011. October 2011. May 2016
From the Forest to the Faucet Drinking Water and Forests in the US
Wyoming State Forestry Division, Office of State Lands and Investments
Wyoming Forest Action Plan: Wyoming Statewide Forest Resource Assessment: Describing Conditions, Threats, Trends, and Priorities
2009
