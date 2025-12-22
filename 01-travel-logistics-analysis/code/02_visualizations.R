#===============================================================================
# SCRIPT: 02_visualizations.R
# PURPOSE: Generate the four main logistics visualizations (verbatim extraction).
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: Blog_Final_Project_2.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#===============================================================================
# SECTION: A Global Logistics Divide: The 2023 Snapshot
# AUTHOR NOTE:
# The journey begins with a simple question: how do countries compare today? The distribution below revealed a logistics hierarchy with profound implications.
#===============================================================================

# [CHUNK HEADER] visualization_1, echo=FALSE, fig.cap="Most nations cluster in the 2.5–3.5 range, but the tails tell competing stories: wealthy trade hubs on the right, struggling clacleconomies on the left."
dataLPI_2023 <- dataLPI_all %>% filter(year == 2023)

ggplot(dataLPI_2023, aes(x = lpi_score)) +
  geom_histogram(binwidth = 0.2, fill = primary_color, color = "white", alpha = 0.85) +
  labs(
    title = "The Global Logistics Middle Class (2023)",
    subtitle = "Most countries score between 2.5–3.5, revealing a performance plateau",
    x = "LPI Score (1–5 scale)",
    y = "Number of Countries",
    caption = "Source: World Bank Logistics Performance Index, 2023 | Higher scores indicate better logistics performance"
  )

#===============================================================================
# SECTION: Regional Divergence Over Time: Who's Rising, Who's Stuck?
# AUTHOR NOTE:
# To start, I looked at the simple question of how countries compare in the most recent year. The 2023 distribution shows that most countries fall between two point five and three point five. It forms a clear middle range, which suggests that a basic level of logistics capability is within reach for many countries. The inequality shows up at the edges. Very few countries score above four, and these are places like Singapore, the Netherlands, and parts of Europe where logistics is a national priority. On the low end are countries that are landlocked, facing conflict, or struggling with weak institutions.
# 
# For the visualization, I used a histogram with equal sized bins and a neutral color palette to keep the focus on the shape of the distribution. The goal is simply to show that logistics performance sits on a spectrum, and most of the world is clustered in the middle.
# 
# ---
# 
# 
# 
# Aggregate distributions hide temporal trends. To understand change, we  track regions across the full 16-year dataset. The interactive chart below invites exploration.
#===============================================================================

# [CHUNK HEADER] visualization_2_plotly, echo=FALSE, fig.cap="Interactive exploration reveals Europe's dominance, Asia's rise, and Africa's stagnation. Hover over data points to see exact scores."
avgLPI_by_region <- dataLPI_all %>%
  group_by(year, region) %>%
  summarise(avg_lpi = mean(lpi_score, na.rm = TRUE), .groups = "drop")

p_plotly <- plot_ly(avgLPI_by_region, 
                    x = ~year, 
                    y = ~avg_lpi, 
                    color = ~region,
                    colors = region_palette,
                    type = 'scatter',
                    mode = 'lines+markers',
                    text = ~paste("Region:", region, 
                                  "<br>Year:", year,
                                  "<br>LPI Score:", round(avg_lpi, 2)),
                    hoverinfo = 'text',
                    line = list(width = 3),
                    marker = list(size = 8)) %>%
  layout(title = list(text = "Regional Logistics Trajectories (2007–2023)<br><sub>Europe leads, Asia climbs, Africa flatlines</sub>", 
                      font = list(size = 16)),
         xaxis = list(title = "Year", gridcolor = "lightgray"),
         yaxis = list(title = "Average LPI Score", gridcolor = "lightgray"),
         hovermode = "closest",
         plot_bgcolor = "white",
         paper_bgcolor = "white")

p_plotly

#===============================================================================
# SECTION: Deconstructing the Index: Which Components Drive Improvement?
# AUTHOR NOTE:
# The next visualization looks at how each region performs across the full period. Europe stays far ahead, consistently scoring above three point five. It reflects how much the European Union has invested in cross border infrastructure and customs systems. Asia shows the strongest climb after 2014, which lines up with the rise of manufacturing powerhouses like China, Vietnam, and India as they modernized ports and digitized their supply chains. The Americas sit in the middle range, and Australia and New Zealand track close to them. The most worrying pattern is Africa, which stays almost flat between about 2.4 and 2.6 with no real progress.
# 
# For this chart, I used Plotly so users can hover and explore individual year and region values without crowding the figure with labels. Each region keeps a consistent color, which makes the lines easier to follow. The interactivity helps turn a simple line chart into something people can actually explore.
# 
# ---
# 
# 
# 
# Regional averages hide internal structure. The LPI aggregates six sub-scores, each represents a different dimension of logistics performance. By tracking these components separately, we can diagnose where improvement happens and where it doesn't.
#===============================================================================

# [CHUNK HEADER] visualization_3, echo=FALSE, fig.cap="Infrastructure and tracking surge ahead, while customs improvement lags—revealing that technology outpaces bureaucracy."
avg_components <- dataLPI_all %>%
  group_by(year) %>%
  summarise(across(all_of(component_cols), ~mean(., na.rm = TRUE)), .groups = "drop") %>%
  pivot_longer(-year, names_to = "component", values_to = "avg_score") %>%
  mutate(component = recode(component, !!!component_labels))

ggplot(avg_components, aes(x = year, y = avg_score, color = component)) +
  geom_line(linewidth = 1.4, alpha = 0.9) +
  geom_point(size = 2.5, alpha = 0.8) +
  scale_color_manual(values = component_palette) +
  labs(
    title = "Global Logistics Components: Technology Leads, Bureaucracy Lags",
    subtitle = "Infrastructure and tracking improve fastest; customs reform stalls globally (2007–2023)",
    x = "Year",
    y = "Average Component Score (1–5 scale)",
    color = "Component",
    caption = "Source: World Bank LPI | Each line represents the global average for one of six logistics dimensions"
  ) +
  guides(color = guide_legend(override.aes = list(linewidth = 3)))

#===============================================================================
# SECTION: From Trends to Magnitudes: Ranking Component Growth
# AUTHOR NOTE:
# This chart looks at how each part of the LPI has changed over time. Timeliness has the highest overall score, which makes sense since the world has continued to get faster at delivery. Infrastructure and logistics quality show the steepest improvement, reflecting major global investment in ports, highways, and new supply chain technology like real time tracking. On the other end, customs barely moves at all, growing less than three percent across the whole period. That suggests that while money can quickly upgrade physical infrastructure, the actual processes and bureaucracy behind borders are much harder to fix.
# 
# The visualization uses a multivariate line chart with a colorblind friendly palette so it is easy to track each component. Everything is kept on the same scale so the comparisons are direct. The points highlight the survey years since the LPI is not collected every year and the data is discrete.
# 
# ---
# 
# 
# 
# While line charts excel at showing change over time, bar charts excel at showing relative magnitude. To show which components have grown most, we calculate percent change from 2007 to 2023 and rank them.
#===============================================================================

# [CHUNK HEADER] visualization_4, echo=FALSE, fig.cap="Tracking outpaces all other dimensions, growing 12%, while customs barely budges at 3%—a bureaucratic bottleneck."
growth <- avg_components %>%
  group_by(component) %>%
  summarise(
    start_2007 = avg_score[year == 2007],
    end_2023 = avg_score[year == 2023],
    growth_pct = (end_2023 - start_2007) / start_2007 * 100,
    .groups = "drop"
  )

ggplot(growth, aes(x = reorder(component, growth_pct), y = growth_pct, fill = component)) +
  geom_col(width = 0.7, alpha = 0.9) +
  geom_text(aes(label = paste0(round(growth_pct, 1), "%")), 
            hjust = -0.1, size = 4.5, fontface = "bold", color = "gray20") +
  coord_flip() +
  scale_fill_manual(values = component_palette) +
  labs(
    title = "Tracking Technology Surges, Customs Reform Crawls",
    subtitle = "Percent growth in global logistics components (2007–2023)",
    x = NULL,
    y = "Growth (%)",
    caption = "Source: World Bank LPI | Bars ordered by magnitude for immediate comparison"
  ) +
  theme(legend.position = "none") +
  expand_limits(y = max(growth$growth_pct) * 1.15)
