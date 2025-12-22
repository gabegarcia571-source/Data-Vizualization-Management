#===============================================================================
# SCRIPT: 03_animation.R
# PURPOSE: Create the gganimate animation (verbatim extraction).
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: Blog_Final_Project_2.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#===============================================================================
# SECTION: Motion Reveals Pattern: Infrastructure as the Engine of Performance
# AUTHOR NOTE:
# This chart focuses on how much each LPI component has grown since the start of the dataset. Infrastructure shows the biggest increase at about twelve point eight percent, which lines up with major global spending on ports, roads, and supply chain systems. Tracking also grows a lot, driven by things like GPS, better container tech, and the consumer expectation of real time updates from companies like Amazon and FedEx. Timeliness barely increases, which suggests that faster infrastructure does not automatically translate into faster processing. It may take more time before the effects show up. Overall, the pattern fits the idea that technology is easy to scale but actual institutional reform is much slower.
# The bar chart uses a zero to fifteen percent scale and orders the components from highest growth to lowest, which makes it easier to read and differentiate than a pie chart. The colors simply separate the components so the ranking is immediately clear.
# ---
# 
# 
# 
# Aggregates obscure individual stories. To understand who leads each region-and how leadership shifts over time-we need granular, country-level rankings. The interactive tool below lets you explore regional leaderboards across survey years.
# 
# https://ggarcia-stats.shinyapps.io/lpi_leaderboard/
# 
# The interactive leaderboard shows differences that do not show up in the overall averages. In Europe, the top performers are almost always Northern and Western countries like Germany, the Netherlands, Belgium, Austria, and Sweden. Asia’s leaders shift between places like Singapore, Hong Kong, Japan, and South Korea, which highlights the mix of trade hubs and large manufacturing economies. In Africa, South Africa and a few North African countries usually lead, while most of sub Saharan Africa is missing from the top spots. In the Americas, Chile and Panama often rise, while bigger economies, including Brazil, move up and down more often.
# 
# The animation helps turn the rankings into a story, letting viewers watch how positions change over time. The horizontal bars stay ordered by score, and the labels are direct, so it is easy to compare countries across years. The region filter and the year slider make it simple to explore different patterns without adding a lot of clutter.
# 
# ---
# 
# 
# 
# Regional rankings answer "who's best?", but policymakers need a different question: "How does my country compare to neighbors on specific dimensions?" The tool below allows sub component-level benchmarking.
# 
# https://ggarcia-stats.shinyapps.io/app2/
# 
# This comparison moves the story from broad regional patterns to what is actually happening within those regions. When you stack individual countries against their own regional average, you start to see who is breaking away from the pack and who is dragging behind. Rwanda is a good example of upward movement within Africa, with infrastructure growth far above the regional baseline. Vietnam shows a similar breakout in Asia with rapid gains in tracking and logistics tech. On the other side, Venezuela falls sharply below the Americas average, showing how national crises pull logistics performance downward even when the region as a whole is improving.
# 
# This matters because it shows that regional trends do not tell the full story. Progress is uneven, and the gap between leaders and laggards exists not only across regions but inside them. The visualization lets viewers pull up the regional average only when they want it, so the main focus stays on the country’s trajectory. 
# 
# Using lighter opacity for the regional line keeps the comparison clear while keeping the attention on the country itself. The consistent color scheme links back to the earlier visuals so everything feels part of a single narrative.
# 
# ---
# 
# 
# 
# Static charts show what and how much; animation shows when. To understand the relationship between infrastructure investment and overall LPI performance over time, we animate a scatterplot across 16 years.
#===============================================================================

# [CHUNK HEADER] animation_creation, include=FALSE, echo=FALSE, message=FALSE, results='hide'
animated <- dataLPI_all %>%
  select(country, region, year, lpi_score, infrastructure_score)

p <- ggplot(animated, aes(x = infrastructure_score, 
                          y = lpi_score, 
                          color = region)) +
  geom_point(size = 3, alpha = 0.75) +
  scale_color_manual(values = region_palette) +
  labs(
    title = "Infrastructure Drives Logistics Performance (2007–2023)",
    subtitle = "Year: {frame_time}",
    x = "Infrastructure Score (1–5 scale)",
    y = "Overall LPI Score (1–5 scale)",
    color = "Region",
    caption = "Source: World Bank LPI | Each point represents one country; color indicates region"
  ) +
  theme(legend.position = "right") +
  transition_time(year) +
  ease_aes('linear')

anim <- animate(
  p, width = 8, height = 6,
  fps = 10, nframes = 150,
  renderer = gifski_renderer()
)
