#===============================================================================
# SCRIPT: 01_import_and_initial_exploration.R
# PURPOSE: Load libraries and import passport ranking datasets; perform initial exploration (verbatim extraction).
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: TidyTuesdayDecemberCodeArchive.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#-------------------------------------------------------------------------------
# CHUNK 1: setup (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] setup, include=FALSE
knitr::opts_chunk$set(echo = TRUE)

#-------------------------------------------------------------------------------
# CHUNK 2: data upload (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] data upload
# NOTE: This chunk contains a hard-coded Windows file path, preserved as-is.
#       Update the path for your local environment if needed, but do not
#       change the underlying transformation/analysis logic.

##Use these two libraries because JSON is a text format that stores structured data and this way the data wont be just text strings. tidyverse for data manipulation and for its use with ggplot.
library(jsonlite)
library(tidyverse)

rank_by_year <- read_csv("C:\\Users\\12022\\Downloads\\Shiny_Tidy_UI_Experiment\\rank_by_year.csv")
country_lists <- read_csv("C:\\Users\\12022\\Downloads\\country_lists.csv")

#-------------------------------------------------------------------------------
# CHUNK 3: data view (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] data view
glimpse(rank_by_year)
summary(rank_by_year)
head(country_lists)
