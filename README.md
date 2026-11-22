# MD Pipeline: p53 (1TSR) × Carvacrol — Microsecond Molecular Dynamics (3 replicas + apo control)

A reproducible, step-by-step pipeline for preparing and running 1-microsecond GROMACS molecular dynamics
simulations of carvacrol with the p53 DNA-binding domain (PDB: 1TSR), with PROPKA-guided protonation,
AutoDock Vina docking, and AMBER99SB-ILDN/GAFF2 force fields. This release adds **three independent holo
replicas and a ligand-free (apo) control** and a **revised MM-GBSA protocol**, supporting the revised
manuscript (see **Associated manuscript**).

> **Status (2026-11-22, v2.0.0):** Revision release. Two additional independent 1 µs holo replicas
> (replicas 2 and 3; randomized initial velocities, otherwise identical conditions) and one 1 µs
> ligand-free (apo) control were added. The per-residue MM-GBSA decomposition was repeated over the
> **complete receptor** and the end-state MM-GBSA was recomputed under a **revised protocol (GB-Neck2,
> igb = 8; see `06_md_analysis/mmgbsa_revised/`)**. Reproducibility outputs are in
> `06_md_analysis/replicas_apo/`. The language throughout has been aligned with the revised manuscript:
> transient/weak surface contact rather than validated binding, **MDC-positive acidic vesicle
> accumulation** rather than autophagy induction, and carvacrol described as a **computationally screened
> fragment hit (not a validated lead)**.

## Associated manuscript

This repository supports the manuscript:

**"Carvacrol Makes Only Transient, Weak Surface Contact with the Wild-Type p53 Core Domain in
Microsecond Simulations and Shows Non-Selective Millimolar Cytotoxicity in Breast Epithelial Cells."**
Balcan E., Tuğrul B., Türker G., Çöllü F. (under revision, *IUBMB Life*).

> This title and framing supersede the earlier working title
> ("Multi-Scale Characterization of Carvacrol–p53 Interaction…", in `07_manuscript/carvacrol_1us_manuscript_v8.md`),
> which is retained only for provenance.

## Key Findings (revised)

| Metric | Value |
|--------|-------|
| Protein backbone RMSD, all four systems (holo ×3 + apo) | 0.26–0.28 nm — **structurally stable, ligand-independent** |
| Radius of gyration, all four systems | ≈ 1.65 nm — **no unfolding** |
| SASA, all four systems | 105–107 nm² |
| Carvacrol behaviour | **transient, pocket-independent surface contact** reproduced in all three holo replicas |
| Docking-site residues (Arg174 / Asp207 / Phe212) | ≤ 2% contact in every replica — **no stable pocket residence** |
| MM-GBSA (revised, GB-Neck2 / igb = 8) | qualitative, ensemble-level indicator only; **no Kd derived** (see `mmgbsa_revised/`) |
| Classification | **computationally screened fragment hit (not a validated lead)**; analogs are hypothesis-generating |

**Interpretation:** Carvacrol exits the initial docking pose rapidly and makes transient, distributed
surface contact rather than occupying a defined pocket. This behaviour is reproduced across three
independent replicas, and the apo control is as stable as the holo systems, which rules out
ligand-induced (or inherent) protein instability. MM-GBSA is reported only as a qualitative,
entropy-omitting, ensemble-level indicator of weak, occupancy-dependent association; no dissociation
constant is derived and no numerical comparison with the cellular IC50 is made.

---

## What changed in v2.0.0 (vs v1.0.0)

- **Added** `06_md_analysis/replicas_apo/` — processed MD outputs for replica 1 (re-analysis of the
  published trajectory), replica 2, replica 3, and the apo control (RMSD, RMSF, radius of gyration,
  SASA, minimum protein–ligand distance, contact count, per-residue contact frequency, H-bond
  occupancy, PCA eigenvalues/projections), plus the cross-replica summary table (`replika_ozet.csv`)
  and comparison figures.
- **Added** `06_md_analysis/mmgbsa_revised/` — documentation of the revised end-state MM-GBSA protocol
  (GB-Neck2, igb = 8, mbondi3, 199 frames over 5–995 ns at 5 ns intervals, 310 K, 0.15 M salt) and the
  per-replica ΔG_bind summary reported in the manuscript (Table 3). See that folder's README for the
  provenance of each value and for the status of the raw gmx_MMPBSA output files.
- **Marked as superseded** the original-submission MM-GBSA result
  (`06_md_analysis/results/mmpbsa_final_results.txt`: gmx_MMPBSA v1.5.0.3, igb = 5, 100 frames,
  298.15 K, ΔTOTAL = −3.61 kcal/mol). It is kept for provenance only and is **not** the value in the
  revised manuscript.
- **Updated** README, `PIPELINE_SUMMARY.txt`, and `.zenodo.json` to the revised title and framing.
- **Corrected** cellular-assay language: MDC results are described as MDC-positive acidic vesicle
  accumulation, not autophagy induction.

See `CHANGELOG.md` for the full list.

---

## Reproducibility across replicas and the apo control

Replicas 2 and 3 differ from the original (published) replica 1 **only in their randomized initial
velocities**, under otherwise identical conditions (same force fields, box, salt, thermostat/barostat,
and 1 µs length). The apo control is the same p53 core domain simulated for 1 µs **without carvacrol**.

Processed outputs for all four systems are in `06_md_analysis/replicas_apo/`; the file
`replicas_apo/replika_ozet.csv` tabulates the per-system structural, contact, and PCA summaries, and
`replicas_apo/README.md` documents exactly how each file was generated and two points a careful reader
should note (the full-trajectory vs MM-GBSA-frame contact definitions, and the PCA frame-count effect,
both discussed in the manuscript). All values are from direct `gmx` analysis; **nothing is fabricated or
upscaled**.

---

## Overview

| Item | Details |
|------|---------|
| **Protein** | p53 core domain — PDB ID: [1TSR](https://www.rcsb.org/structure/1TSR) |
| **Ligand** | Carvacrol (2-methyl-5-isopropylphenol) — PubChem CID: [10364](https://pubchem.ncbi.nlm.nih.gov/compound/10364) |
| **Simulations** | 3 × 1 µs holo (replicas 1–3) + 1 × 1 µs apo control (500,000,000 steps × 2 fs each) |
| **MD engine** | GROMACS 2024.1 |
| **Protein FF** | AMBER99SB-ILDN |
| **Ligand FF** | GAFF2 + AM1-BCC charges (ACPYPE) |
| **Water model** | TIP3P, dodecahedron box (1.2 nm clearance) |
| **Salt** | 0.15 M NaCl (physiological) |
| **Temperature** | 310 K (V-rescale) |
| **Pressure** | 1 bar (Parrinello-Rahman) |
| **End-state free energy** | MM-GBSA, GB-Neck2 (igb = 8), qualitative only — see `06_md_analysis/mmgbsa_revised/` |
| **HPC cluster** | TRUBA (Turkish national HPC, SLURM) |

The force-field, box, docking, and equilibration protocols are unchanged from v1.0.0 and are documented
in full in `PIPELINE_SUMMARY.txt` and in the step-by-step sections below. The replicas and apo control
were produced with the **same** setup scripts (`01_`–`05_`), differing only in the random seed for
initial-velocity generation (replicas) or the absence of the ligand (apo).

---

## Data availability note

Raw trajectory files (`.xtc` / `.trr`, ~1 GB per replica) are too large for repository hosting and are
available from the corresponding author on reasonable request. The processed analysis outputs for every
replica and the apo control are included here. Raw cellular data and original microscopy images are
provided in the manuscript's Supplementary Information.

---

## Citation

If you use this pipeline, please cite the associated manuscript (above) and this archive:

> Balcan, E. (2026). *erdal-b-dot/p53-carvacrol-md-pipeline: v2.0.0 — Revision release (replicas + apo
> control, revised MM-GBSA).* Zenodo. https://doi.org/10.5281/zenodo.21430040

(The DOI `10.5281/zenodo.21430040` is the concept DOI and always resolves to the latest version.)

---

*The step-by-step usage, prerequisites, directory structure, and software citations below are unchanged
from v1.0.0 except where noted; see the sections that follow.*
