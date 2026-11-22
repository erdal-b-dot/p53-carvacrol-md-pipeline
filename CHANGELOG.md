# Changelog

## v2.0.0 — 2026-11-22 (Revision release)

Supports the revised manuscript *"Carvacrol Makes Only Transient, Weak Surface Contact with the
Wild-Type p53 Core Domain in Microsecond Simulations and Shows Non-Selective Millimolar Cytotoxicity in
Breast Epithelial Cells"* (Balcan, Tuğrul, Türker, Çöllü; under revision, *IUBMB Life*).

### Added
- `06_md_analysis/replicas_apo/` — processed MD analysis outputs for **replica 1** (re-analysis of the
  published trajectory), **replica 2**, **replica 3**, and the **apo (ligand-free) control**:
  backbone RMSD, per-residue RMSF, radius of gyration, SASA, minimum protein–ligand distance, contact
  count (<0.5 nm), per-residue contact frequency, H-bond occupancy, and PCA
  (eigenvalues + 2-D projections).
- `06_md_analysis/replicas_apo/replika_ozet.csv` — cross-replica/apo summary table (structural
  stability, carvacrol surface behaviour, PCA), all from direct `gmx` analysis.
- `06_md_analysis/replicas_apo/` comparison figures (replica comparison; per-residue contact-frequency
  comparison).
- `06_md_analysis/mmgbsa_revised/` — documentation of the **revised end-state MM-GBSA protocol**
  (GB-Neck2, igb = 8, mbondi3, 199 frames over 5–995 ns at 5 ns intervals, 310 K, 0.15 M salt) and the
  per-replica ΔG_bind summary reported in manuscript Table 3, with provenance notes.
- `CHANGELOG.md`, updated `.zenodo.json`.

### Changed
- Title and framing updated throughout to match the revised manuscript: transient/weak **surface
  contact** (not validated binding); carvacrol described as a **computationally screened fragment hit
  (not a validated lead)**; analogs described as **hypothesis-generating**.
- Cellular-assay language corrected: MDC results described as **MDC-positive acidic vesicle
  accumulation**, not autophagy induction.
- Per-residue MM-GBSA decomposition now computed over the **complete receptor** (residues 94–289 + Zn²⁺;
  197 units) rather than a residue subset.

### Deprecated / superseded
- `06_md_analysis/results/mmpbsa_final_results.txt` (gmx_MMPBSA v1.5.0.3, igb = 5, 100 frames,
  298.15 K, ΔTOTAL = −3.61 kcal/mol) is the **original-submission** result. It is retained for
  provenance only and is **not** the value reported in the revised manuscript. The revised MM-GBSA is
  documented in `06_md_analysis/mmgbsa_revised/`.
- The earlier working manuscript title and the derived Kd (≈ 2.2 mM) and its IC50 comparison have been
  removed from the revised manuscript; `07_manuscript/carvacrol_1us_manuscript_v8.md` is retained only
  for provenance.

## v1.0.0 — 2026-07-18 (Initial archival release)
- Initial archival release: single 1 µs GROMACS MD run of carvacrol with p53 (1TSR), docking,
  analysis scripts and processed outputs. Corrected force-field documentation drift.
