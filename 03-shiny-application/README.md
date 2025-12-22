# Shiny Application

This folder contains the **final working Shiny app** (extracted verbatim from the source chunk 38), plus preserved prototype and annotation-development code.

## What’s here
- `app.R` — **Final Shiny app code** (do not modularize; preserved exactly)
- `code/01_prototypes.R` — early Shiny experiments (chunks 14, 17, 18)
- `code/02_event_annotations_dev.R` — key event annotations development (chunks 34–36)

## How to run
From R:
```r
shiny::runApp("03-shiny-application")
```

## Narrative (documentation excerpt provided)
```
Purpose and Main Message
The LPI Growth Explorer is a way for users to look at how different
countries improved or declined across key logistics performance
indicators between 2007 and 2023. It shows which countries made progress
in specific areas of their logistics systems and how those patterns
differ across countries. The big idea is that the app lets users compare
any two countries side by side. So if someone is doing a project on,
say, the U.S. and China, or they just want quick statistics on
infrastructure or customs growth, they can get that instantly.
The app focuses on the specific logistics components that matter to
users, and originally it used checkboxes so people could include or
exclude components as needed. It gives both a visual pattern and a
quantitative summary of growth across selected components, which is
useful for policy work, business analysis, or anyone trying to
understand which countries are emerging in logistics or where the most
improvement has happened.
I think interactivity is really important here because a static
visualization would run into a lot of limitations. There are over 100
```

## Notes on fidelity
All code is extracted verbatim from the original Rmd sources. Only explanatory comments were added to clarify purpose and data flow.
