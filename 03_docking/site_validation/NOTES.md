# Docking site validation (2026-07-01)

This folder documents how the manuscript's reported docking score (−4.377 / −4.38 kcal/mol)
was validated against the 1 µs MD trajectory, and why it differs from the blind-box score
in `../vina_log.txt` (−6.056 kcal/mol). See the **Docking Site Validation** section in the
top-level README for the full explanation.

- `receptor.pdbqt` — receptor prepared from `01_protein_prep`'s protonated structure via
  `mk_prepare_receptor.py` (AutoDock Vina 1.2.5 + Meeko 0.7.1, `docking_env` conda environment).
- `converge_test.py` — re-docks the parent ligand across box sizes (20–99 Å) and
  exhaustiveness levels (8–32) with 3 seeds each, centered on the validated pocket
  (57.767, 1.858, 76.828). Confirms a 20 Å box reproduces −4.38 kcal/mol (σ < 0.01) while
  staying at the ARG174/ASP207/PHE212 site; larger boxes let the ligand escape to a different,
  competing pocket instead of refining the same pose.
- `fragment_growing_dock.py` — dockes the parent + five redesigned analogs (B1–B5) at the
  validated site, used to produce the Section 3.9 fragment-growing SAR table in the v8
  manuscript.

To reproduce: `conda activate docking_env && python converge_test.py` (or
`fragment_growing_dock.py`) from this directory.
