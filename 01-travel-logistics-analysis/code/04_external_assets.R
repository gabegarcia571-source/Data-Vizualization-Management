#===============================================================================
# SCRIPT: 04_external_assets.R
# PURPOSE: Document and reproduce external image / asset embedding steps (verbatim extraction).
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: Blog_Final_Project_2.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#-------------------------------------------------------------------------------
# CHUNK 10: animate_graphic (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] animate_graphic, echo=FALSE
knitr::include_graphics("animation.gif")

#===============================================================================
# SECTION: Geography is Destiny: A Spatial View of Logistics Performance
# AUTHOR NOTE:
# When you animate the scatterplot over time, a clear pattern shows up. Countries with stronger infrastructure almost always have higher LPI scores, and the two move together year after year. Asian countries steadily climb upward on both axes as ports, highways, and supply chain tech expand across the region. Africa stays clustered in the lower left with only small shifts, which highlights how weak infrastructure can keep nations stuck. Europe remains grouped in the upper right, showing high performance and slow, steady improvement.correlation. Asian nations (dark green) visibly climb the scatterplot over time, reflecting China's Belt and Road Initiative, Vietnam's port expansions, and India's Golden Quadrilateral highway project. African nations (purple) remain clustered in the lower-left quadrant, with minimal upward movement—illustrating how lack of infrastructure investment creates a development trap. European nations (gold) remain tightly grouped in the upper-right, showing that mature economies maintain high performance with incremental improvements.
# 
# The animation makes these movements easy to see because the motion shows how countries drift or stay locked in place over time. Color separates the regions, and the smooth transitions make the story feel continuous rather than choppy. Instead of a static picture, you get to watch the global gap widen or narrow—bringing the convergence question into focus.
# 
# ---
# 
# 
# 
# Numbers and charts reveal patterns; maps reveal place. To understand the geographic dimension of logistics performance—why coastal nations, trade route hubs, and landlocked countries cluster where they do—we turn to a choropleth map created in Tableau.
#===============================================================================

# [CHUNK HEADER] tableau_screenshot, echo=FALSE, out.width="100%", fig.cap="Coastal nations and trade route hubs (Singapore, Netherlands, UAE) glow bright on this global map, while landlocked and conflict-affected regions remain dark—logistics performance has a geography."
# NOTE: This chunk contains a hard-coded Windows file path, preserved as-is.
#       Update the path for your local environment if needed, but do not
#       change the underlying transformation/analysis logic.

knitr::include_graphics("C:\\Users\\12022\\Documents\\LPI Mapping.png")
