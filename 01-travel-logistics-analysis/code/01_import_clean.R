#===============================================================================
# SCRIPT: 01_import_clean.R
# PURPOSE: Load packages, set global options/themes, import LPI data, and create region groupings (verbatim extraction).
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: Blog_Final_Project_2.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#-------------------------------------------------------------------------------
# CHUNK 1: setup (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] setup, include=FALSE
library(knitr)

knitr::opts_chunk$set(
  echo = FALSE,
  warning = FALSE,
  message = FALSE,
  fig.width = 10,
  fig.height = 6,
  fig.align = "center"
)

#-------------------------------------------------------------------------------
# CHUNK 2: global_setup (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] global_setup, echo=FALSE
# NOTE: This chunk contains a hard-coded Windows file path, preserved as-is.
#       Update the path for your local environment if needed, but do not
#       change the underlying transformation/analysis logic.

library(readxl)
library(dplyr)
library(purrr)
library(janitor)
library(countrycode)
library(tidyr)
library(ggplot2)
library(shiny)
library(gganimate)
library(plotly)

file_path <- "C:\\Users\\12022\\Downloads\\Blog Project\\International_LPI_from_2007_to_2023_0 (1).xlsx"

component_cols <- c(
  "customs_score", 
  "infrastructure_score", 
  "international_shipments_score", 
  "logistics_competence_and_quality_score", 
  "timeliness_score", 
  "tracking_and_tracing_score"
)

component_labels <- c(
  customs_score = "Customs",
  infrastructure_score = "Infrastructure",
  international_shipments_score = "Intl Shipments",
  logistics_competence_and_quality_score = "Logistics Quality",
  timeliness_score = "Timeliness",
  tracking_and_tracing_score = "Tracking"
)

component_palette <- c(
  "Customs" = "#8B0000",           
  "Infrastructure" = "#00008B",    
  "Intl Shipments" = "#228B22",   
  "Logistics Quality" = "#FF8C00", 
  "Timeliness" = "#FF4500",      
  "Tracking" = "#C71585"          
)

region_palette <- c(
  "Africa" = "#9370DB",      
  "Americas" = "#4682B4", 
  "Asia" = "#2F4F2F",        
  "Europe" = "#DAA520",      
  "Oceania" = "#8B4513"      
)

primary_color <- "#4682B4"

manual_regions <- c(
  "Hong Kong SAR, China" = "Asia",
  "Taiwan, China" = "Asia",
  "Korea, Rep." = "Asia",
  "Korea, Dem. Rep." = "Asia",
  "Congo, Dem. Rep." = "Africa",
  "Congo, Rep." = "Africa",
  "Egypt, Arab Rep." = "Africa",
  "Iran, Islamic Rep." = "Asia",
  "Russian Federation" = "Europe"
)

custom_theme <- theme_minimal(base_size = 13, base_family = "sans") +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0, margin = margin(b = 10)),
    plot.subtitle = element_text(size = 12, color = "gray30", hjust = 0, margin = margin(b = 15)),
    plot.caption = element_text(size = 9, color = "gray50", hjust = 1, margin = margin(t = 10)),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 11),
    legend.title = element_text(size = 11, face = "bold"),
    legend.text = element_text(size = 10),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "gray90"),
    plot.margin = margin(15, 15, 15, 15)
  )

theme_set(custom_theme)

#-------------------------------------------------------------------------------
# CHUNK 3: dataload (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] dataload, echo=FALSE
sheets <- excel_sheets(file_path)

dataLPI_all <- map_dfr(sheets, function(sh) {
  read_excel(file_path, sheet = sh) %>%
    clean_names() %>%
    mutate(year = as.integer(sh))
})

#-------------------------------------------------------------------------------
# CHUNK 4: region_creation (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] region_creation, echo=FALSE
dataLPI_all <- dataLPI_all %>%
  mutate(
    region = if_else(
      country %in% names(manual_regions), 
      manual_regions[country],
      countrycode(country, origin = "country.name", destination = "continent")
    )
  ) %>%
  filter(!is.na(region))
