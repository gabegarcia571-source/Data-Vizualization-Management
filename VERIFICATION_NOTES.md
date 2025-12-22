# VERIFICATION_NOTES.md

Date: 2025-12-22

## What can be regenerated immediately (with the files in this repo)
**Passport + Shiny (Part 02 + Part 03):**
- The repository includes:
  - `rank_by_year.csv`
  - `country_lists.csv`
- If you run the scripts in Part 02 in order, the data transformations and plots should reproduce the original outputs, assuming the same package versions and an R environment with the listed dependencies.

## What requires additional inputs
**Travel/Logistics (Part 01):**
- The original code imports LPI data via a **hard-coded Windows path** to the World Bank Excel download.
- That Excel file is **not included** here (not provided in the uploaded assets for this pass).
- Once you place the Excel in the path your code expects (or update locally for your environment), Part 01 scripts should reproduce the original outputs.

## Code fidelity confirmation
- ✅ All chunks listed in `CODE_MAPPING.md` are present in exactly one destination script.
- ✅ Extracted code inside each section is **verbatim** from the source Rmd chunks.
- ✅ No pipelines, variable names, function calls, or ggplot aesthetics were altered.
- ✅ Prototype/debug chunks were separated into:
  - `02-passport-power-evolution/code/99_exploratory_notes.R`
  - `03-shiny-application/code/01_prototypes.R`
- ✅ Only comments/annotations were added around the original code blocks.

## Notes on plot export
The original Rmds rendered plots inline. This repository preserves that exact plotting code.
If you want exported PNGs/GIFs in `outputs/`, add non-invasive `ggsave()` / `anim_save()` calls **after** plot creation (do not modify the plot-building code itself).
