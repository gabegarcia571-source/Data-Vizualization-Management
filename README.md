# Global Mobility Analysis: Logistics, Passport Power, and Interactive Exploration

This repository tells a single story in three chapters: **how global logistics infrastructure shapes opportunity**, **how passport access changes over time**, and **how an interactive Shiny tool can make those patterns explorable**.

## Why this matters
Global mobility is not just “where you can go.” It’s a systems outcome of **infrastructure, policy, and international relationships**. In practice, the same forces that make trade easier (efficient customs, reliable shipping, strong tracking systems) often appear in the way countries’ travel access and rankings evolve.

## Repository structure

- `01-travel-logistics-analysis/` — World Bank Logistics Performance Index (LPI) analysis (2007–2023)
- `02-passport-power-evolution/` — Passport “power” (visa-free counts + rank) over time, framed as **winners vs. losers**
- `03-shiny-application/` — Interactive Shiny app (Trends / Leaderboard / Biggest Improvers + event annotations)

Supporting docs:
- `docs/` — methodology, data sources, data dictionary
- `assets/images/` — screenshots / figures used in READMEs
- `archive/` — original Rmd/HTML artifacts used for **verbatim** code extraction

## How the pieces connect
1. **Logistics (Part 1)** establishes the structural “mobility backbone” (customs, infrastructure, tracking, timeliness).
2. **Passport evolution (Part 2)** shows how mobility access shifts over time and who gains/loses.
3. **Shiny (Part 3)** turns the time series + ranking-change logic into an exploration interface with country comparisons and context.

## How to run
> **Fidelity note:** All analysis scripts are extracted **verbatim** from the original Rmd sources. Only comments/annotations were added. Some scripts contain **hard-coded Windows paths** preserved exactly as written (see notes inside scripts).

### Travel/Logistics
1. Open `01-travel-logistics-analysis/code/01_import_clean.R`
2. Run scripts in order:
   - `01_import_clean.R`
   - `02_visualizations.R`
   - `03_animation.R`
   - `04_external_assets.R`

### Passport Power
Run, in order:
- `02-passport-power-evolution/code/01_import_and_initial_exploration.R`
- `02-passport-power-evolution/code/02_historically_weak_passport_gains.R`
- `02-passport-power-evolution/code/03_powerhouse_time_series.R`
- `02-passport-power-evolution/code/04_winners_vs_losers_leaderboard.R`

Exploratory/prototype work (not required for reproduction):
- `02-passport-power-evolution/code/99_exploratory_notes.R`

### Shiny app
- Run `03-shiny-application/app.R`

## Primary data
- Passport dataset inputs are included in:
  - `02-passport-power-evolution/data/rank_by_year.csv`
  - `02-passport-power-evolution/data/country_lists.csv`

For LPI: see `01-travel-logistics-analysis/README.md` and `docs/data-sources.md`.

## Component highlights (author narrative excerpts)
**Travel/Logistics (Blog excerpt):**
```
Introduction
My project looks at how well countries move goods across borders
using the World Bank Logistics Performance Index. The index scores
countries from one to five on customs, infrastructure, shipment ease,
logistics competence, tracking, and timeliness. Since supply chains
decide who can compete in the global economy, these scores line up with
growth and trade.
I used data from 2007 to 2023 for 139 countries to see whether
logistics performance is becoming more equal or if the gap between
strong and weak countries is getting wider. I made eight visualizations
to follow the trends. There is real improvement in things like tracking
technology and infrastructure, but landlocked and conflict heavy
countries are still stuck behind. The goal is to show both the progress
and the barriers that still shape global trade.
A Global Logistics Divide: The 2023 Snapshot
The journey begins with a simple question: how do countries compare
today? The distribution below revealed a logistics hierarchy with
profound implications.
Most nations cluster in the 2.5–3.5 range, but the tails tell competing
stories: wealthy trade hubs on the right, struggling clacleconomies on
```

**Passport Power (TidyTuesday excerpt):**
```
Visualization 2: Global Power Shifts (2006-2025)
I wanted a broader view of how passport power changed for all
countries. I used a full ranking from “lost the most access” to “gained
the most.” Then I did something that really makes the chart work:
I grabbed the bottom 10 and top 10 countries and stacked them into
one data frame so the viewer immediately sees who gained the most and
also sees who either barely improved or actually lost ground (Bolivia).
I wanted the colors to mean something. So I created a change_type column
with case_when. Then I converted that to a factor and used
scale_fill_manual() to lock in consistent colors:
Red for decline
Gold for small improvement
Green for major improvement
This is what lets the viewer understand the chart at a glance without
reading every number.
For the final plot I ordered the bars from best to worst change. I
went horizontal to keep the country names readable. I added custom
labels (+99, -5, etc.) and nudged them left/right depending on whether
the change was positive or negative. I wrote the subtitle to explicitly
call out the Bolivia finding. Those coding decisions turn a giant table
```

**Shiny documentation excerpt (as provided):**
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
