# MD Pipeline: p53 (1TSR) × Carvacrol — 1 µs Molecular Dynamics Simulation

A reproducible, step-by-step pipeline for preparing and running a 1-microsecond GROMACS molecular dynamics simulation of carvacrol bound to the p53 DNA-binding domain (PDB: 1TSR), with PROPKA-guided protonation, AutoDock Vina docking, and AMBER14SB/GAFF2 force fields.

> **Status (2026-06-29):** 1 µs simulation complete. Full trajectory analysis added in `06_md_analysis/` including RMSD, RMSF, Rg, SASA, protein–ligand minimum distance, and PCA. Manuscript draft available in `07_manuscript/`.

## Key Findings

| Metric | Value |
|--------|-------|
| Protein backbone RMSD (mean ± SD) | 0.27 ± 0.07 nm — **structurally stable** |
| Radius of gyration | 1.657 ± 0.010 nm — **no unfolding** |
| Carvacrol RMSD from initial pose | 3.04 ± 1.20 nm — **exits initial pocket** |
| **Protein–ligand contact (<5 Å)** | **75.0% of 1 µs trajectory** |
| Bulk solvent (>20 Å) | 0.7% only |
| PCA: PCs for 90% variance | 8 — high conformational heterogeneity (L3 loop) |

**Interpretation:** Carvacrol exits the initial docking pose rapidly but maintains persistent surface contact (75% of simulation within 5 Å). This *surface-sliding* behavior is characteristic of fragment-class molecules (<300 Da) at shallow protein–protein interaction interfaces and positions carvacrol as a validated fragment hit for fragment-based drug design (FBDD).

---

---

## Overview

| Item | Details |
|------|---------|
| **Protein** | p53 core domain — PDB ID: [1TSR](https://www.rcsb.org/structure/1TSR) |
| **Ligand** | Carvacrol (2-methyl-5-isopropylphenol) — PubChem CID: [10364](https://pubchem.ncbi.nlm.nih.gov/compound/10364) |
| **Simulation length** | 1 µs (500,000,000 steps × 2 fs) |
| **MD engine** | GROMACS 2024.1-oneapi-2024 |
| **Protein FF** | AMBER14SB |
| **Ligand FF** | GAFF2 + AM1-BCC charges (ACPYPE) |
| **Water model** | TIP3P, dodecahedron box (1.2 nm clearance) |
| **Salt** | 0.15 M NaCl (physiological) |
| **Temperature** | 310 K (V-rescale) |
| **Pressure** | 1 bar (Parrinello-Rahman) |
| **HPC cluster** | TRUBA (Turkish national HPC, SLURM) |

---

## Directory Structure

```
p53-carvacrol-md-pipeline/
├── 01_protein_prep/
│   └── prepare_protein.sh         # Download 1TSR, remove DNA, run PROPKA3
├── 02_ligand_prep/
│   └── prepare_ligand.sh          # SDF → MOL2 → ACPYPE (GAFF2)
├── 03_docking/
│   └── run_docking.sh             # Meeko receptor/ligand prep + Vina docking
├── 04_gromacs_setup/
│   ├── setup_topology.sh          # pdb2gmx, solvate, ions, EM, NVT, NPT
│   └── mdp/
│       ├── ions.mdp
│       ├── minim.mdp              # Energy minimization
│       ├── nvt.mdp                # 100 ps NVT equilibration (310 K)
│       ├── npt.mdp                # 1 ns NPT equilibration (310 K, 1 bar)
│       └── md_1us.mdp             # 1 µs production MD
├── 05_truba/
│   ├── slurm_1us.sh               # Self-resubmitting SLURM script
│   └── transfer_files.sh          # rsync files to TRUBA
├── 06_md_analysis/                # NEW — 1 µs trajectory analysis
│   ├── scripts/
│   │   ├── plot_md_analysis.py    # RMSD, RMSF, Rg, SASA figures
│   │   ├── create_mindist_figure.py  # Protein–ligand mindist (gmx mindist output)
│   │   └── run_pca_mdanalysis.py  # MDAnalysis PCA of backbone conformations
│   ├── results/
│   │   ├── rmsd_backbone.xvg      # Backbone RMSD vs time
│   │   ├── rmsd_ligand.xvg        # Carvacrol RMSD vs time
│   │   ├── rmsf_backbone.xvg      # Per-residue RMSF
│   │   ├── gyrate.xvg             # Radius of gyration
│   │   ├── sasa.xvg               # Solvent-accessible surface area
│   │   ├── mindist_prot_lig.xvg   # Protein–ligand minimum distance
│   │   └── pca_variance.txt       # PCA explained variance per PC
│   └── figures/
│       ├── fig1_rmsd.png/pdf      # Backbone + carvacrol RMSD
│       ├── fig2_rmsf.png/pdf      # Per-residue RMSF
│       ├── fig3_rg_sasa.png/pdf   # Rg + SASA panel
│       ├── fig4_combined.png/pdf  # Publication multi-panel
│       ├── fig5_mindist.png/pdf   # Mindist analysis (NEW)
│       └── fig6_pca.png/pdf       # PCA conformational landscape (NEW)
└── 07_manuscript/                 # NEW — manuscript draft
    └── carvacrol_1us_manuscript_v5.md
```

> **Large files excluded from git** (see `.gitignore`): trajectory files (`.xtc`, `.trr`, ~1 GB each), topology (`.tpr`, `.gro`), energy files (`.edr`). Request these from the authors or regenerate using the pipeline scripts.

---

## Prerequisites

### Local Machine (macOS/Linux)

| Tool | conda environment | Version tested |
|------|------------------|----------------|
| GROMACS | `mol-sim` | 2024.x |
| AutoDock Vina | `mol-sim` | 1.2.6 |
| Meeko | `mol-sim` | 0.7.1 |
| PROPKA3 | `docking_env` | 3.5.1 |
| RDKit | `docking_env` | 2025.x |
| ACPYPE | `mol-sim` (auto-installed) | latest |
| OpenBabel | system | 3.x |

### TRUBA HPC
- GROMACS 2024.1-oneapi-2024 (via `module load`)
- SLURM workload manager
- Partition: `hamsi` (AMD EPYC 7742, 128 cores/node) or `barbun` (Intel, recommended for oneAPI)

---

## Step-by-Step Usage

### Step 1 — Protein Preparation

```bash
cd 01_protein_prep
bash prepare_protein.sh
```

**What it does:**
- Downloads `1TSR.pdb` from the RCSB Protein Data Bank
- Identifies and removes DNA chains (chains C/D); retains protein chains (A/B) and the structural Zn²⁺ ion
- Runs **PROPKA3** at pH 7.4 to determine protonation states of titratable residues
- Reports histidine protonation recommendations for `pdb2gmx`

> **Action required:** After running, open `1TSR_protein.pka` and update the `HIS_PROT` variable in `04_gromacs_setup/setup_topology.sh` with the appropriate protonation state for each histidine residue (0 = HID, 1 = HIE, 2 = HIP).

---

### Step 2 — Ligand Parametrization

```bash
cd 02_ligand_prep
bash prepare_ligand.sh
```

**What it does:**
- Converts `carvacrol.sdf` to MOL2 format (OpenBabel)
- Runs **ACPYPE** with GAFF2 atom types and AM1-BCC partial charges (net charge = 0)
- Standardizes the residue name to `LIG` for GROMACS compatibility
- Outputs: `carvacrol.acpype/carvacrol_GMX.itp` and `carvacrol_GMX.gro`

> ACPYPE is automatically installed into the `mol-sim` environment on first run (~5–15 min for AM1-BCC charge calculation).

---

### Step 3 — Molecular Docking

```bash
cd 03_docking
bash run_docking.sh
```

**What it does:**
- Calculates a blind-docking grid box covering the entire p53 core domain (protein CoM ± 10 Å per axis)
- Prepares receptor PDBQT using **Meeko** `mk_prepare_receptor.py`
- Prepares ligand PDBQT using **Meeko** `mk_prepare_ligand.py`
- Runs **AutoDock Vina** (exhaustiveness = 32, 10 binding modes, seed = 42)
- Extracts the top-ranked pose as `carvacrol_best_pose.pdb`
- Generates `1TSR_carvacrol_complex.pdb` for visualization

---

### Step 4 — GROMACS System Setup + Local Equilibration

```bash
cd 04_gromacs_setup
# Edit HIS_PROT in setup_topology.sh first!
bash setup_topology.sh
```

**What it does:**
1. `pdb2gmx` — AMBER14SB topology with PROPKA-guided His protonation
2. Merges protein and ligand GRO files
3. Generates ligand position restraints (`posre_LIG.itp`)
4. `editconf` — dodecahedral simulation box, 1.2 nm solvent clearance
5. `solvate` — TIP3P water model
6. `genion` — 0.15 M NaCl, charge neutralization
7. `make_ndx` — creates `Protein_LIG` index group for thermostat coupling
8. Energy minimization (steepest descent, F_max < 10 kJ/mol/nm)
9. NVT equilibration (100 ps, 310 K, position-restrained)
10. NPT equilibration (1 ns, 310 K, 1 bar, position-restrained)

---

### Step 5 — Transfer to TRUBA and Submit

```bash
# Edit transfer_files.sh: set TRUBA_USER
bash 05_truba/transfer_files.sh
```

On TRUBA:
```bash
# Edit slurm_1us.sh: set YOUR_ACCOUNT and YOUR_EMAIL
sbatch slurm_1us.sh
```

**SLURM script features:**
- Single MPI rank, multi-threaded OpenMP (56 threads on `hamsi`)
- Auto-resumes from `md.cpt` checkpoint if wall-clock time expires
- Self-resubmits until 500,000,000 steps (1 µs) are complete
- Estimated runtime: ~5–7 days on 56 hamsi cores

---

## MD Parameters Summary

### MDP Key Settings

| Parameter | EM | NVT | NPT | Production (1 µs) |
|-----------|----|-----|-----|-------------------|
| `nsteps` | 50,000 | 50,000 | 500,000 | **500,000,000** |
| `dt` (ps) | 0.01 | 0.002 | 0.002 | 0.002 |
| Duration | — | 100 ps | 1 ns | **1 µs** |
| Thermostat | — | V-rescale | V-rescale | V-rescale |
| Barostat | — | — | Parrinello-Rahman | Parrinello-Rahman |
| T (K) | — | 310 | 310 | 310 |
| P (bar) | — | — | 1.0 | 1.0 |
| Cutoff (nm) | 1.2 | 1.2 | 1.2 | 1.2 |
| VdW modifier | — | force-switch | force-switch | force-switch |
| Electrostatics | PME | PME | PME | PME |
| Constraints | none | h-bonds | h-bonds | h-bonds |
| Position restraints | — | Protein+LIG | Protein+LIG | — |

---

## Expected Output Files (TRUBA)

```
md.xtc     — Trajectory (~10,000 frames @ 100 ps intervals, ~50 GB)
md.edr     — Energy file
md.log     — GROMACS log
md.cpt     — Final checkpoint
md.gro     — Final coordinates
```

---

## Citation

If you use this pipeline, please cite:

- **GROMACS 2024:** Abraham et al., *SoftwareX* (2015); [doi:10.1016/j.softx.2015.06.001](https://doi.org/10.1016/j.softx.2015.06.001)
- **AMBER14SB:** Maier et al., *J. Chem. Theory Comput.* 11, 3696 (2015)
- **GAFF2 / ACPYPE:** Wang et al., *J. Comput. Chem.* 25, 1157 (2004); Sousa da Silva & Vranken, *BMC Res. Notes* 5, 367 (2012)
- **AutoDock Vina 1.2:** Eberhardt et al., *J. Chem. Inf. Model.* 61, 3891 (2021)
- **PROPKA3:** Olsson et al., *J. Chem. Theory Comput.* 7, 525 (2011)
- **Meeko:** Forli lab, [github.com/forlilab/meeko](https://github.com/forlilab/meeko)
- **1TSR:** Cho et al., *Science* 265, 346 (1994); [doi:10.1126/science.8023157](https://doi.org/10.1126/science.8023157)

---

## License

MIT License — see [LICENSE](LICENSE) for details.
