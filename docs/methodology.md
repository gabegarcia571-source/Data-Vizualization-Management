# Methodology

This repository preserves the original analysis logic and visualization code from the author’s RMarkdown sources.

**Reproducibility principle:** code is extracted **verbatim** into scripts, and only explanatory comments were added. Prototype/debug chunks are preserved in dedicated scripts so the “main pipeline” stays runnable.

## Component methods (high level)

### 01 — Logistics (LPI)
- Uses the World Bank Logistics Performance Index (LPI) across 2007–2023
- Compares overall and component scores (customs, infrastructure, international shipments, logistics competence, tracking & tracing, timeliness)
- Visual strategy: snapshot comparisons, regional time series, component trend decomposition, and growth comparisons

### 02 — Passport power
- Uses a country-year dataset of passport access (visa_free_count, rank, region, year)
- Constructs change metrics (e.g., change since baseline year / change since prior year)
- Story framing: leaders vs decliners (winners vs losers), plus focused case studies and time series

### 03 — Shiny
- Converts the same datasets and derived metrics into interactive workflows:
  - Trends (time series)
  - Leaderboard (rank changes)
  - Biggest improvers/decliners
  - Event annotations for interpretive context
