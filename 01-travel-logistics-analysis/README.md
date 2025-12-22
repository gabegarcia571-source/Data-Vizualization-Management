# Travel and Logistics Analysis (World Bank LPI)

This folder reproduces the Travel/Logistics analysis from the original project blog output.

## Research question
How do countries differ in logistics performance (2007–2023), and what patterns emerge across regions and LPI sub-components?

## Scripts (run in order)
1. `code/01_import_clean.R`  
   - Loads packages and global theme
   - Imports LPI data (hard-coded Windows path preserved)
   - Creates region groupings / derived variables used downstream

2. `code/02_visualizations.R`  
   Reproduces the four main visuals:
   - “A Global Logistics Divide: The 2023 Snapshot”
   - “Regional Divergence Over Time”
   - “Deconstructing the Index: Component Trends”
   - “From Trends to Magnitudes: Ranking Component Growth”

3. `code/03_animation.R`  
   - Reproduces the `gganimate` sequence used in the original write-up

4. `code/04_external_assets.R`
   - Preserves the image embedding / external asset documentation steps referenced in the blog

## Outputs
- Plots render directly from the scripts (as in the original Rmd).
- If you want file exports (PNG/GIF), add non-invasive `ggsave()` / `anim_save()` calls **after** plot creation (do not alter plot code).

## Original narrative excerpt
```
Regional averages hide internal structure. The LPI aggregates six
sub-scores, each represents a different dimension of logistics
performance. By tracking these components separately, we can diagnose
where improvement happens and where it doesn’t.
Infrastructure and tracking surge ahead, while customs improvement
lags—revealing that technology outpaces bureaucracy.
This chart looks at how each part of the LPI has changed over time.
Timeliness has the highest overall score, which makes sense since the
world has continued to get faster at delivery. Infrastructure and
logistics quality show the steepest improvement, reflecting major global
investment in ports, highways, and new supply chain technology like real
time tracking. On the other end, customs barely moves at all, growing
less than three percent across the whole period. That suggests that
while money can quickly upgrade physical infrastructure, the actual
processes and bureaucracy behind borders are much harder to fix.
The visualization uses a multivariate line chart with a colorblind
friendly palette so it is easy to track each component. Everything is
kept on the same scale so the comparisons are direct. The points
highlight the survey years since the LPI is not collected every year and
the data is discrete.
From Trends to Magnitudes: Ranking Component Growth
While line charts excel at showing change over time, bar charts excel at
```
