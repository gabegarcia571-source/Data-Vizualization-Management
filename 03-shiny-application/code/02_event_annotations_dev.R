#===============================================================================
# SCRIPT: 02_event_annotations_dev.R
# PURPOSE: Development of key event annotations and event data joins preserved verbatim.
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: TidyTuesdayDecemberCodeArchive.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#-------------------------------------------------------------------------------
# CHUNK 34: key events for selected countries point pop ups (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] key events for selected countries point pop ups
   geom_point(
      data = events_data,
      aes(
        text = paste0(
          "<b>", country, "</b><br>",
          "Year: ", year, "<br>",
          "Visa-Free Access: ", visa_free_count, "<br><br>",
          "<b>", event, "</b><br>",
          detail)))

#-------------------------------------------------------------------------------
# CHUNK 35: data join (key events and events data) (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] data join (key events and events data)
events_data <- filtered_data() %>%
  inner_join(key_events, by = c("country", "year"))

#-------------------------------------------------------------------------------
# CHUNK 36: actual event data (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] actual event data
## the importnat thing here was making this a tible and its own tab. Because selected coutnries was a vector of names I filtered to get the data but this is metadata and this would need a year column an event column and detail column and that would take forever. 
key_events <- tibble::tibble(
  country = c(
    "United Arab Emirates",
    "Singapore",
    "Japan",
    "Germany",
    "United States",
    "Brazil"
  ),
  year = c(
    2015,  # the UAE makes new law
    2012,  # Singapore gov makes pledge
    2008,  # Japan access to europe
    2010,  # Germany EU Schengen
    2017,  # United States visa waiver partnership
    2010   # Brazil improvement in global regions
  ),
  event = c(
    "Major increase in global visa agreements",
    "Business/travel diplomacy increases access",
    "Europe visa-waiver expands passport mobility",
    "Schengen EU consolidation strengthens access",
    "Rapid growth before plateauing",
    "Growth during regional/global expansion"
  ),
  detail = c(
    "UAE’s strategic reforms make its passport one of the fastest-improving in the world.",
    "Singapore cements its status as a leading travel and business hub.",
    "Japan broadens visa-free access across Europe and beyond.",
    "EU mobility benefits help Germany reach top-tier status.",
    "Visa-waiver partnerships expand, but others begin catching up after 2018.",
    "Steady improvements raise Brazil’s global mobility significantly."
  )
)
