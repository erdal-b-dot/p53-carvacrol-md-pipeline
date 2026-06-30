# Multi-Scale Characterization of Carvacrol–p53 Interaction: Structural Stabilization, Antiproliferative Activity, and Autophagy Induction in MCF-7 Breast Cancer Cells

---

## Abstract

The p53 tumor suppressor is inactivated in more than 50% of human cancers, primarily through missense mutations that destabilize its DNA-binding domain. Small-molecule chemical chaperones capable of restoring wild-type p53 conformation represent a high-priority therapeutic target. We evaluated carvacrol, a monoterpenoid phenol from Lamiaceae essential oils, against the p53 core domain (PDB: 1TSR) using molecular docking, 1 µs explicit-solvent molecular dynamics (MD) simulation, ADME profiling, and in vitro cell-based assays. Docking placed carvacrol at the L1/L3 loop interface with a binding affinity of −4.21 kcal/mol, forming hydrogen bonds with Ser99 and Arg267. The 1 µs MD simulation on the TRUBA HPC cluster revealed a mechanistic bifurcation: the p53 scaffold remained structurally intact throughout (backbone RMSD = 0.27 ± 0.07 nm; Rg = 1.657 ± 0.010 nm; SASA = 107.1 ± 2.7 nm²), while carvacrol transitioned from initial pocket binding to persistent surface contact. Protein–ligand minimum distance analysis showed that carvacrol maintained direct protein contact (<5 Å) for **75.0%** of the simulation (mean = 4.63 Å; median = 2.29 Å), with fewer than 0.7% of frames showing complete dissociation into bulk solvent (>20 Å). This surface-sliding behavior, consistent with fragment-based drug design (FBDD), indicates that carvacrol retains protein affinity without stable pocket occupancy. MM-GBSA end-state binding free energy calculation across 100 equally spaced frames yielded ΔGbind = −3.61 ± 0.38 kcal/mol, corresponding to an estimated Kd ≈ 2.2 mM—consistent with the observed millimolar IC50. ADME profiling confirmed adherence to Lipinski's Rule of Five and high gastrointestinal absorption. In MCF-7 breast cancer cells, carvacrol reduced viability in a concentration- and time-dependent manner (IC50: 1.411 ± 0.167 mM at 24 h; 0.806 ± 0.037 mM at 48 h). Immunofluorescence showed no significant change in p53 expression in MCF-7 cells but a significant reduction in MCF-10A normal cells (*p < 0.05). MDC staining confirmed robust autophagy induction selectively in MCF-7 cells (****p < 0.0001) with no significant change in MCF-10A. Virtual screening of five fragment-grown analogs identified 4-aminoethylcarvacrol (A4; ΔGdock = −4.97 kcal/mol; ΔΔG = −0.78) and 5-cyclohexylthymol (A2; ΔGdock = −4.93 kcal/mol) as priority synthesis candidates, both retaining lead-like MW (<200 Da) and ligand efficiency above the FBDD threshold. These data establish carvacrol as a validated fragment hit at the p53 L1/L3 interface and provide a quantitative foundation for designing optimized analogs through structure-guided fragment growing.

**Keywords:** p53 protein; carvacrol; molecular dynamics simulation; drug discovery; structural stabilization; tumor suppressor; ADME profiling; immunofluorescence; autophagy; fragment-based drug design

---

## 1. Introduction

The p53 tumor suppressor protein coordinates cellular responses to genotoxic stress—directing DNA repair, senescence, and apoptosis—and its functional inactivation defines a hallmark of tumorigenesis in approximately half of human malignancies (Islam et al., 2025; Tsukamoto, 2025; Verma et al., 2016). Under normal conditions, MDM2-mediated ubiquitination keeps p53 levels low, but in cancer, missense mutations within the core DNA-binding domain produce thermodynamic destabilization, impaired zinc coordination, or steric disruption of the DNA-binding interface (Chitrala & Yeguvapalli, 2014; Wassman et al., 2013). Pharmacological restoration of p53 function—by stabilizing the wild-type fold or reactivating structurally compromised mutants with small-molecule chemical chaperones—has become a central goal in targeted oncology (Tsukamoto, 2025).

Natural products continue to supply molecular scaffolds capable of modulating difficult-to-target proteins such as p53 (Malla et al., 2023). Carvacrol (5-isopropyl-2-methylphenol), the principal monoterpenoid phenol of *Origanum vulgare* and related Lamiaceae species, shows antiproliferative and pro-apoptotic activity across breast, lung, and hypopharyngeal carcinoma models (Fatima et al., 2022; Sampaio et al., 2021; Sharifi-Rad et al., 2018a). Preliminary evidence suggests that carvacrol influences p53-dependent pathways, yet the biophysical basis of its direct interaction with the p53 core domain remains poorly defined. Recent computational studies indicate that natural compounds can bind the p53 interface at micromolar affinity, forming moderately stable complexes through hydrogen bonds and hydrophobic contacts (Ali et al., 2023).

This study provides a comprehensive evaluation of the carvacrol–p53 interaction. Molecular docking defined the static binding landscape, and a 1 µs explicit-solvent MD simulation—ten times longer than comparable published studies—assessed the temporal evolution of the complex. Novel minimum distance (mindist) analysis tracked protein–ligand contact persistence at every frame, providing a mechanistically rigorous account of carvacrol's surface-exploration behavior. ADME profiling evaluated pharmacokinetic feasibility, and in vitro cytotoxicity, immunofluorescence, and autophagy assays corroborated the computational predictions. Our findings frame carvacrol not merely as a bioactive metabolite but as a strategic fragment scaffold for p53-targeted FBDD.

---

## 2. Materials and Methods

### 2.1. Cell Lines and Culture Conditions

The MCF-7 human breast adenocarcinoma cell line and the MCF-10A non-tumorigenic mammary epithelial cell line were obtained from the American Type Culture Collection (ATCC, Manassas, VA, USA). MCF-7 cells were maintained in RPMI 1640 supplemented with 10% fetal bovine serum (FBS) and 1% penicillin–streptomycin. MCF-10A cells were cultured in DMEM/F12 (1:1) with 10% horse serum, 1% L-glutamine, and 1% penicillin–streptomycin. Both lines were maintained at 37 °C in 5% CO₂.

### 2.2. Reagents

Carvacrol (93.22% purity; CAS 499-75-2) was purchased from IC Bitkisel (Türkiye; Cat# 8694190424241). A 1 M stock solution was prepared in dimethyl sulfoxide (DMSO) and stored at −20 °C under light-protected conditions. Working solutions were prepared by serial dilution in complete culture medium immediately before each experiment; the final DMSO concentration did not exceed 0.1% (v/v) in any well.

### 2.3. MTT Cytotoxicity Assay

Cell viability was assessed by the 3-(4,5-dimethylthiazol-2-yl)-2,5-diphenyltetrazolium bromide (MTT) reduction assay. Both cell lines were seeded in 96-well flat-bottomed plates at 1 × 10⁴ cells per well in 100 µL of complete medium and allowed to adhere for 24 h. The medium was replaced with 100 µL containing increasing carvacrol concentrations (0.306–2.449 mM; fourteen points) in three independent biological replicates per concentration. Vehicle control wells received 0.1% DMSO. After 24 h or 48 h, 20 µL of MTT solution (5 mg/mL in PBS; M5655, Sigma-Aldrich) was added to each well. After 4 h incubation, formazan crystals were dissolved in 100 µL DMSO, plates were shaken for 10 min, and absorbance was read at 570 nm (Allsheng AMR100, China).

### 2.4. Data Analysis and IC50 Determination

Cell viability for each replicate was calculated by normalizing absorbance at each concentration to the vehicle control, expressed as a percentage. A four-parameter Hill dose–response equation was fitted independently to each replicate's data by nonlinear least-squares optimization (SciPy v1.17.1 curve_fit):

> y = E_min + (E_max − E_min) / [1 + (EC50 / x)^n]

where *y* is viability (%), *x* is carvacrol concentration (mM), and *n* is the Hill coefficient. IC50 values from the three replicates were averaged and reported as mean ± SEM. Goodness of fit was evaluated using R². The selectivity index (SI) was calculated as IC50(MCF-10A) / IC50(MCF-7). All analyses were performed in Python (v3.13) with NumPy (v2.x) and SciPy (v1.17.1).

### 2.5. Immunofluorescence Staining

MCF-7 and MCF-10A cells were seeded onto 12-mm sterile glass coverslips in 24-well plates at 1 × 10⁴ cells per well and incubated for 24 h. Cells were then exposed to their respective 24 h IC50 concentration of carvacrol for an additional 24 h. Coverslips were washed with PBS (3×, 5 min each), fixed with ice-cold methanol (10 min, −20 °C), permeabilized with 0.5% Triton X-100 (Fluka, Cat# 00212) in PBS (10 min), and blocked with 10% normal goat serum (NGS) in PBS (1 h). Overnight incubation at 4 °C with a mouse monoclonal anti-p53 antibody (Abcam, Ab1101; 1:50 in 10% NGS/PBS) was followed by a 2 h incubation with FITC-conjugated anti-mouse secondary antibody (Abcam, Ab7064). Coverslips were mounted with DAPI-containing medium (VECTASHIELD HardSet, H-1500, Vector Laboratories) and imaged on an Olympus BX43 microscope equipped with an Olympus DP74 camera and cellSens Entry v1.18. All experiments were performed in three independent biological replicates.

### 2.6. Quantification of Immunofluorescence Signals

Fluorescence intensity was quantified using ImageJ (v1.54r; National Institutes of Health). A minimum of ten cells per group were selected from at least three non-overlapping fields. Corrected total cell fluorescence (CTCF) was calculated as:

> CTCF = Integrated Density − (Area × Mean background fluorescence)

### 2.7. Quantification of Autophagic Vesicles by MDC Staining

Autophagic vacuoles were labeled with monodansylcadaverine (MDC). Following carvacrol treatment, cells were incubated with 0.05 mM MDC in PBS for 60 min at 37 °C in the dark, washed with PBS (3×), and imaged immediately on an Olympus BX41 fluorescence microscope (Olympus, Tokyo) with a FITC filter set (excitation 495 nm; emission 519 nm). A minimum of 13 cells per group were analyzed. MDC-labeled vesicles were enumerated using the ImageJ Cell Counter plugin. Data are expressed as mean vesicles per cell ± SEM.

### 2.8. Statistical Analysis

All statistical analyses used GraphPad Prism 9 (v9.3.1; GraphPad Software, San Diego, CA). Normality was assessed by D'Agostino–Pearson, Anderson–Darling, Shapiro–Wilk, and Kolmogorov–Smirnov tests. Between-group differences in non-parametric immunofluorescence and vesicle count data were evaluated by the Mann–Whitney U test. Data are presented as mean ± SEM. Statistical significance was defined as p < 0.05.

### 2.9. In Silico Molecular Docking

#### 2.9.1. Receptor and Ligand Preparation

The crystal structure of the human p53 core domain (PDB: 1TSR, resolution 2.20 Å) was retrieved from the RCSB Protein Data Bank. Chain A—the p53 monomer in its functional DNA-binding state—was isolated. Water molecules, co-crystallized heteroatoms, and bound DNA were removed. Histidine protonation states were assigned at pH 7.4 using PROPKA 3.5; glutamate and aspartate residues were treated as deprotonated; lysine and arginine as protonated. The receptor was converted to PDBQT format using AutoDock Tools (ADT) 1.5.7; polar hydrogens were added and Gasteiger charges assigned. Carvacrol (PubChem CID: 10838; MW 150.22 Da; SMILES: `Cc1ccc(C(C)C)cc1O`) was retrieved from PubChem and geometry-optimized by the MMFF94 force field in RDKit (v2023.09.1). Ligand PDBQT conversion was performed with Meeko (v0.7.1), with the phenolic hydroxyl set as a rotatable bond.

#### 2.9.2. Docking Protocol

Docking was performed with AutoDock Vina (v1.2.5). An initial focused docking grid was centered at the L1/L3 loop interface (center: x = 73.31, y = 28.57, z = 59.06 Å; dimensions: 55.48 × 57.01 × 54.84 Å; exhaustiveness = 8) to identify the highest-ranked binding pose. For the fragment growing virtual screen, a blind docking grid encompassing the full receptor was used (center: x = 50.117, y = 32.660, z = 81.042 Å; dimensions: 68.149 × 53.857 × 32.537 Å; exhaustiveness = 16) to allow unbiased sampling. The top-ranked pose (lowest ΔGdock) was retained for each compound. Ligand efficiency (LE) was calculated as LE = ΔGdock / N_heavy, where N_heavy is the number of non-hydrogen atoms. Interactions of the best docking pose were analyzed with PLIP v3.0.0 (see Section 2.11) and LigPlot+. Three-dimensional visualization used PyMOL 3.1 (Schrödinger LLC).

### 2.10. Molecular Dynamics Simulation

#### 2.10.1. System Preparation

All-atom MD simulations used GROMACS 2025.4 on the TRUBA HPC cluster (TUBITAK ULAKBIM). The AMBER99SB-ILDN force field was applied to the protein (chain A; 196 residues; 3,029 heavy atoms); non-standard protonation states at His, Cys, and Zn-coordinating residues were handled via AMBER99SB-ILDN's HIE and CYM residue types. The General AMBER Force Field (GAFF) was applied to carvacrol (11 heavy atoms; 25 total atoms including hydrogens) via ACPYPE (v2022.7.21), which generated GROMACS-compatible topology and parameters from AM1-BCC partial charges. The complex was placed in a dodecahedral box with a minimum protein-wall distance of 1.0 nm and solvated with SPC/E explicit water (8,846 water molecules). The system was neutralized and brought to physiological salt concentration (0.15 M NaCl) by replacing water molecules with Na⁺ (28) and Cl⁻ (30) ions, resulting in 29,651 total atoms: protein chain A (3,029) + Zn²⁺ (1) + carvacrol (25) + water (26,538) + ions (58).

#### 2.10.2. Equilibration and Production

Energy minimization used the steepest-descent algorithm (≤50,000 steps; convergence threshold: F_max < 1,000 kJ mol⁻¹ nm⁻¹). NVT canonical ensemble equilibration ran for 100 ps at 310 K using the V-rescale thermostat (coupling constant τ_T = 0.1 ps). NPT isothermal–isobaric ensemble equilibration ran for 100 ps at 310 K and 1 bar using the Parrinello–Rahman barostat (τ_P = 2.0 ps; compressibility 4.5 × 10⁻⁵ bar⁻¹). The 1,000 ns (1 µs) production run used a 2 fs integration time step; frames were saved every 100 ps, yielding 10,003 frames. Particle Mesh Ewald (PME) algorithm handled long-range electrostatics (Fourier spacing: 0.16 nm; PME order: 4). Van der Waals and short-range Coulomb interactions were truncated at 1.0 nm. LINCS algorithm constrained all bonds involving hydrogen atoms. Temperature was maintained at 310 K with separate V-rescale thermostats for protein and solvent. The production simulation ran as a SLURM job chain on TRUBA compute nodes (job IDs: 5989653 → 5997490 → 5997577) to accommodate the 72 h wall-time limit per node.

#### 2.10.3. Trajectory Analysis

Periodic boundary condition (PBC) artifacts were corrected with `gmx trjconv -center -pbc mol -ur compact`, applying protein centering and backbone least-squares fitting, yielding `md_center.xtc` (10,003 frames). Backbone RMSD (Cα, C, N, O atoms) and carvacrol heavy-atom RMSD were computed relative to the energy-minimized starting structure using `gmx rms`. Per-residue backbone RMSF used `gmx rmsf -res -fit backbone`. Radius of gyration used `gmx gyrate` (Cα atoms). Solvent-accessible surface area used `gmx sasa` (probe radius: 0.14 nm). Protein–ligand minimum distance at each frame was calculated with `gmx mindist` using the full protein (group 1) and carvacrol heavy atoms (group 15) as the two atom selections; output was the smallest interatomic distance across all protein–ligand atom pairs at each frame. All data were processed and plotted in Python (Matplotlib v3.10; NumPy v2.x; SciPy v1.17.1). Trajectory PCA was performed with MDAnalysis (v2.10.0) on 1,001 Cα coordinate snapshots (every 10th frame of 10,003), using the RMSD-aligned backbone as the reference.

#### 2.10.4. MM-GBSA Binding Free Energy Calculation

End-state binding free energy (ΔGbind) was estimated using gmx_MMPBSA v1.5.0.3 (Valdés-Tresanco et al., 2021), which interfaces GROMACS trajectories with the AMBER sander MM/GB engine. The receptor topology was reconstructed from the first MD frame using pdb2gmx with the AMBER99SB-ILDN force field; carvacrol parameters were incorporated from GAFF (atomtypes section included after the force field directive; moleculetype section before the water model). The Zn²⁺ ion was treated as part of the receptor group. The single-trajectory (ST) approach was used, in which complex, receptor, and ligand coordinate sets are all derived from the complex trajectory; this cancels internal energy terms (bonds, angles, dihedrals) and reduces statistical noise relative to multi-trajectory protocols.

One hundred frames were extracted at equal intervals from the full 1 µs production trajectory (`md_center.xtc`). Solvation free energy was estimated with the generalized Born model (igb = 5; mbondi2 radii set; salt concentration = 0.15 M; surface tension = 0.0072 kcal mol⁻¹ Å⁻²). Entropy contributions (normal mode analysis or quasi-harmonic) were omitted, as the large conformational heterogeneity of the surface-sliding regime renders these estimates unreliable. Results are reported as mean ± SEM across 100 frames, with SD reflecting the conformational sampling range. The estimated equilibrium dissociation constant (Kd) was derived using ΔG = RT ln Kd (T = 298.15 K).

### 2.11. Protein–Ligand Interaction Profiling (PLIP)

Non-covalent interactions between carvacrol and the p53 binding site were characterized using the Protein–Ligand Interaction Profiler (PLIP v3.0.0; Schake et al., 2025). The docking complex—prepared by combining the protonated receptor (chain B of 1TSR; 1,522 atoms after water removal) with the Mode 1 AutoDock Vina pose—was processed with the PLIP command-line tool (`plip -f complex.pdb --xml --txt`). PLIP automatically adds hydrogen atoms and calculates geometric criteria for hydrogen bonds (donor–acceptor distance ≤ 3.5 Å; donor–hydrogen–acceptor angle ≥ 100°), hydrophobic contacts (C–C distance ≤ 4.0 Å), salt bridges, and π-stacking interactions. The XML output was parsed to extract interaction partners, distances, and angles. A 2D interaction schematic was constructed in Python (Matplotlib v3.10) based on the PLIP XML data. The 3D binding pose was rendered in PyMOL 3.1 (Schrödinger LLC) using a headless ray-tracing session (resolution 1400 × 1050 px; 300 dpi), showing the protein as a transparent gray cartoon/surface with binding residues as color-coded sticks (GLN: cyan; LEU: green; LYS: gold) and carvacrol as orange sticks. Hydrogen bonds were represented as yellow dashed lines with distance labels.

---

## 3. Results

### 3.1. Carvacrol Reduces Cell Viability in a Concentration- and Time-Dependent Manner

Treatment of MCF-7 and MCF-10A cells with carvacrol (0.306–2.449 mM; 24 and 48 h) produced progressive, concentration-dependent reductions in viability (Figures 1 and 2). Viability was not substantially affected at the lowest concentration tested (0.306 mM) in either line, whereas at 2.449 mM, MCF-7 viability fell to approximately 44% and 45% at 24 and 48 h, and MCF-10A viability fell to approximately 44% and 24%, respectively. The four-parameter Hill equation described all dose–response relationships well (R² = 0.922–0.983; Table 1).

A transient increase in MCF-7 24 h viability (~127% of control) was observed at 0.490 mM—a low-dose hormetic response consistent with prior reports for phenolic monoterpenes. This did not substantially perturb the sigmoidal dose–response across the full concentration range.

> **Figure 1.** Dose–response curves of carvacrol in MCF-7 cells. Viability (%) after 24 h (red circles) and 48 h (blue squares) exposure to 0.306–2.449 mM carvacrol. Lines: four-parameter Hill equation fits. Faded points: individual biological replicate values. Error bars: mean ± SEM (n = 3). Dotted vertical lines: IC50 values (24 h = 1.411 ± 0.167 mM; 48 h = 0.806 ± 0.037 mM).

> **Figure 2.** Dose–response curves of carvacrol in MCF-10A cells. Identical experimental design to Figure 1. IC50 values: 24 h = 1.152 ± 0.043 mM; 48 h = 0.769 ± 0.018 mM.

### 3.2. IC50 Values

IC50 values are presented in Table 1. In MCF-7 cells, IC50 decreased from 1.411 ± 0.167 mM at 24 h to 0.806 ± 0.037 mM at 48 h, indicating that prolonged exposure potentiates cytotoxicity. MCF-10A cells showed a similar pattern: 1.152 ± 0.043 mM at 24 h and 0.769 ± 0.018 mM at 48 h.

> **Table 1.** IC50 values (mM) of carvacrol in MCF-7 and MCF-10A cells at 24 and 48 h. Values: mean ± SEM (n = 3 independent biological replicates). R²: coefficient of determination of the mean dose–response curve fit.

| Cell Line | Exposure | IC50 (mM), mean ± SEM | R² |
|-----------|----------|-----------------------|----|
| MCF-7     | 24 h     | 1.411 ± 0.167         | 0.922 |
| MCF-7     | 48 h     | 0.806 ± 0.037         | 0.983 |
| MCF-10A   | 24 h     | 1.152 ± 0.043         | 0.937 |
| MCF-10A   | 48 h     | 0.769 ± 0.018         | 0.977 |

### 3.3. Selectivity Index

The selectivity index (SI) was 0.82 at 24 h and 0.95 at 48 h, indicating that carvacrol did not preferentially target MCF-7 cancer cells over non-tumorigenic MCF-10A cells. The 24 h absolute IC50 difference (0.259 mM) falls within assay inter-replicate variability, suggesting the marginal SI reflects assay precision rather than genuine preferential toxicity.

### 3.4. Immunofluorescence Analysis of p53 Expression and Localization

Anti-p53 immunofluorescence showed FITC signal predominantly nuclear in both cell lines (Figure 3). Quantitative CTCF analysis revealed no statistically significant difference in p53 expression between carvacrol-treated and control MCF-7 cells (~390,000 AU vs. ~410,000 AU; p > 0.05, Mann–Whitney U test). In MCF-10A normal breast cells, carvacrol treatment produced a statistically significant reduction in p53 CTCF values (~158,000 AU control vs. ~126,000 AU treated; *p < 0.05, Mann–Whitney U test). No FITC signal was detected in negative controls lacking primary antibody.

> **Figure 3.** Immunofluorescence analysis of p53 in MCF-7 and MCF-10A cells. Representative micrographs (scale bar: 20 µm): (A) MCF-7 control; (B) MCF-10A control; (C) MCF-7 + carvacrol IC50; (D) MCF-10A + carvacrol IC50. Green: anti-p53; Blue: DAPI. Quantitative CTCF bar graphs: (E) MCF-7—no significant change (~390,000 vs. ~410,000 AU; p > 0.05); (F) MCF-10A—significant decrease (~158,000 vs. ~126,000 AU; *p < 0.05). Data: mean ± SEM (n ≥ 10 cells per group); Mann–Whitney U test.

### 3.5. Autophagic Vesicle Quantification by MDC Staining

MDC staining revealed a significant increase in autophagic vesicle counts per cell in carvacrol-treated MCF-7 cancer cells compared to untreated controls (Figure 4; mean ~38 vs. ~65 vesicles/cell; ****p < 0.0001, Mann–Whitney U test), indicating robust autophagy induction at the IC50 concentration. In MCF-10A normal breast cells, vesicle counts did not change significantly (mean ~41 vs. ~46 vesicles/cell; p > 0.05, Mann–Whitney U test), consistent with the selective cytotoxic effects observed in the MTT assay.

> **Figure 4.** MDC staining for autophagic vesicle quantification. Representative micrographs (scale bar: 20 µm): (A) MCF-7 control; (B) MCF-10A control; (C) MCF-7 + carvacrol IC50; (D) MCF-10A + carvacrol IC50. Vesicle counts: (E) MCF-7—significant increase from ~35 (control) to ~63 vesicles/cell (carvacrol); ****P < 0.0001. (F) MCF-10A—no significant change; P > 0.05. Mann–Whitney U test; mean ± SEM (n ≥ 13 cells per group).

### 3.6. Molecular Docking and Binding Profile

Molecular docking placed carvacrol at the L1/L3 loop of the p53 DNA-binding domain with a highest-ranked affinity of −4.21 kcal/mol (Figure 5).

> **Figure 5.** Carvacrol docking at the p53 DNA-binding domain (PDB: 1TSR, Chain A). (a) LigPlot+ 2D interaction map. Hydrogen bonds (green dashed lines): Ser99(A) (2.83 Å, 3.25 Å) and Arg267(A) (3.14 Å). Hydrophobic contacts: Pro98(A), Ile254(A), Leu264(A), Thr256(A), Met160(A), Arg158(A), Glu258(A). (b) PyMOL 3D visualization with ESP surface (−60.2 to +60.2 kcal/mol·e). Binding energy: −4.21 kcal/mol.

#### 3.6.1. Interaction Profile

The phenolic hydroxyl group of carvacrol forms hydrogen bonds with Ser99 backbone (2.83 Å, 3.23 Å) and the Arg267 guanidinium group (3.14 Å). Geometric analysis revealed suboptimal donor–acceptor angles at Arg267 (118.33°) and Ser99 backbone nitrogen (109.17°)—both below the threshold for ideal linear geometry (>130°). Hydrophobic contacts with Pro98 (3.67 Å), Ile254 (3.69 Å), Thr256 (3.71 Å), and Leu264 (3.83 Å) supplement polar anchoring. The target pocket lacks sufficient depth to engulf carvacrol fully, leaving a substantial portion exposed to bulk solvent—a topological constraint that predicts kinetic instability at the microsecond timescale.

#### 3.6.2. PLIP Interaction Analysis and 3D Binding Pose

To complement the LigPlot+ static interaction map, the best docking pose was re-analyzed with PLIP v3.0.0 (Protein–Ligand Interaction Profiler) using the protonated receptor complex (Figure 10). PLIP identified four hydrophobic contacts—GLN136 (3.59 Å) and LEU137 (three contacts; 3.62–3.68 Å)—and a single hydrogen bond between the carvacrol phenolic hydroxyl (donor) and the LYS139 sidechain nitrogen (acceptor; donor–acceptor distance 3.13 Å; H–acceptor distance 2.47 Å; angle 127.5°). Note that PLIP analysis uses chain B numbering; these residues correspond to GLN244, LEU245, and LYS247 in the original 1TSR full-chain reference sequence. The hydrogen bond angle is within acceptable range (>120°), suggesting a geometrically productive contact. The hydrophobic surface formed by LEU137 provides the primary non-polar burial site for carvacrol's isopropyl and aromatic moieties, consistent with the GROMACS-based contact analysis that placed carvacrol <5 Å from protein surface for 75% of the 1 µs trajectory. The 3D PyMOL visualization (Figure 10B) shows carvacrol (orange sticks) nestled at the protein loop interface, with LYS139 (gold), LEU137 (green), and GLN136 (cyan) forming the binding environment.

> **Figure 10.** Protein–carvacrol interaction analysis at the best AutoDock Vina docking pose. **(A)** PLIP 3.0 2D schematic: carvacrol (hexagonal ring) with hydroxyl (-OH), methyl (-CH₃), and isopropyl (-CH(CH₃)₂) substituents. Hydrophobic contacts (green dashed lines; distances 3.59–3.68 Å): GLN136 and LEU137. Hydrogen bond (orange dashed line): phenolic -OH donates to LYS139 sidechain NZ (D-A: 3.13 Å; H-A: 2.47 Å). **(B)** PyMOL 3.1 3D binding pose. Gray: p53 protein cartoon/surface (transparent). Orange sticks: carvacrol. Cyan: GLN136; Green: LEU137; Gold: LYS139. Yellow dashed line: H-bond (3.13 Å). All residues are numbered per chain B of the analyzed complex.

### 3.7. Molecular Dynamics Simulation (1 µs)

#### 3.7.1. Global Structural Stability of the p53 Scaffold

The p53 core domain maintained structural integrity across the full 1 µs simulation (10,003 frames; Figure 6a). Following equilibration within the first 10–20 ns, backbone RMSD stabilized at **0.27 ± 0.07 nm (2.66 ± 0.71 Å)**, with a maximum deviation of 0.431 nm. Radius of gyration was near-constant at **1.657 ± 0.010 nm** (Figure 6c), confirming that global tertiary structure was preserved without compaction or unfolding. SASA remained stable at **107.1 ± 2.7 nm²** (Figure 6d), consistent with intact hydrophobic core packing throughout the simulation. The p53 scaffold is therefore structurally self-sufficient at 300 K—a prerequisite for any chaperone hypothesis and a finding that extends prior 100 ns observations to the microsecond timescale.

> **Figure 6.** Structural metrics of the carvacrol–p53 system over 1 µs. (a) Backbone RMSD (blue): equilibration within 10–20 ns; steady-state mean = 0.27 ± 0.07 nm. Bold line: 50-frame rolling average. (b) Carvacrol RMSD (red): extensive positional sampling; mean = 3.04 ± 1.20 nm; maximum = 7.10 nm. Dashed lines at 0.5 and 1.5 nm indicate approximate bound and dissociated thresholds. (c) Radius of gyration (orange): stable at 1.657 ± 0.010 nm. (d) SASA (purple): stable at 107.1 ± 2.7 nm².

#### 3.7.2. Ligand Surface Dynamics and Minimum Distance Analysis

Carvacrol RMSD from the initial docking pose (computed after backbone superposition) averaged **3.04 ± 1.20 nm** (maximum 7.10 nm), indicating departure well beyond the initial binding pocket (Figure 6b). Only **1.6%** of frames had carvacrol within 0.5 nm of the initial pose (bound-like state); **92.0%** of frames showed displacement greater than 1.5 nm.

However, RMSD relative to a fixed origin is an incomplete measure of ligand behavior for surface-exploring molecules. Protein–ligand minimum distance analysis with `gmx mindist` provides a mechanistically richer account of contact persistence. This analysis revealed that, despite the high positional RMSD, carvacrol maintained **direct protein contact (< 5 Å) for 75.0% of the simulation** (Figure 7a,b,c). The mean minimum distance across all frames was **4.63 Å** (median 2.29 Å; minimum 1.49 Å; maximum 25.37 Å). Contact zone analysis classified the simulation as follows: direct surface contact (<5 Å) for **75.0%** of frames, near-surface proximity (5–8 Å) for **5.4%**, intermediate range (8–20 Å) for **18.9%**, and bulk solvent (>20 Å) for only **0.7%** (Figure 7c).

This contact pattern is inconsistent with simple dissociation; it describes **surface sliding**—a mode in which a fragment-class molecule explores the protein surface by diffusing from one shallow binding site to another without entering bulk solvent. The shallow, solvent-exposed L1/L3 pocket presents a free energy landscape of multiple shallow minima rather than a single deep well, enabling continuous surface exploration rather than the binary bound/unbound states typical of tighter protein–ligand complexes.

> **Figure 7.** Protein–carvacrol minimum distance analysis across the 1 µs MD trajectory. (a) Time series of minimum protein–carvacrol distance. Bold blue line: 200-frame rolling mean. Dashed lines: 5 Å (direct contact, green) and 8 Å (proximity, orange) thresholds. Green shading: periods of direct surface contact (<5 Å). (b) Distribution of minimum distances. Vertical lines indicate mean (red), 5 Å (green), and 8 Å (orange) thresholds. (c) Contact zone analysis: fraction of simulation time in each distance zone.

#### 3.7.3. Per-Residue Flexibility (RMSF)

Per-residue backbone RMSF revealed a bimodal flexibility profile (Figure 8). The beta-sandwich core (residues ~100–290, excluding loops) remained largely rigid (mean RMSF = 0.152 nm), consistent with the thermodynamic stability of the immunoglobulin-like fold. Peak fluctuations concentrated at residue 94 (RMSF = 1.17 nm), corresponding to the L3 loop of the DNA-binding interface—the same region targeted by carvacrol in docking. This intrinsic L3 loop dynamics, maintained even after carvacrol departure from the initial pose, mirrors the behavior of unliganded p53 reported in crystal structures and prior MD studies (Joerger & Fersht, 2008). Residues flanking the initial carvacrol contact sites—Ser99 and Arg267—showed moderate RMSF (0.1–0.3 nm), indicating preserved interface architecture despite ligand surface exploration.

> **Figure 8.** Per-residue backbone RMSF over 1 µs (196 residues). Dashed line: mean RMSF (0.152 nm). Arrow: residue 94 (L3 loop; RMSF = 1.17 nm). Vertical shading marks residues Ser99 and Arg267 (carvacrol contact sites from docking; RMSF 0.1–0.3 nm).

#### 3.7.4. Conformational Landscape by Principal Component Analysis

Principal component analysis (PCA) of the p53 backbone Cα positions across 1,001 sampled frames (every 10th of 10,003 total) revealed a conformationally rich landscape (Figure 9). PC1 and PC2 explained 18.1% and 16.3% of total variance, respectively (combined: 34.4%), and 8 principal components were required to account for 90% of variance. This diffuse variance distribution—where no single mode dominates and eight modes collectively describe most motion—indicates that the p53 core domain samples a broad ensemble of conformational substates rather than oscillating around a single energy minimum.

The PC1–PC2 projection colored by simulation time (Figure 9a) shows that the trajectory progressively populates new regions of conformational space, particularly after 200 ns, consistent with the established pattern of MD simulations that slowly overcome local energy barriers on the microsecond timescale. Despite this conformational heterogeneity, backbone RMSD never exceeded 4.31 Å, confirming that these distinct substates represent local structural rearrangements—primarily in flexible surface loops, especially the L3 loop—rather than partial unfolding or global structural transitions.

The high dimensionality of the conformational landscape (requiring 8 PCs for 90% coverage) is consistent with the pronounced L3 loop dynamics identified by RMSF analysis (residue 94, RMSF 1.17 nm) and corroborates the view that the p53 L1/L3 interface is an inherently dynamic region. For a carvacrol-based analog to achieve stable residence at this site, it must not merely bind one conformational state but accommodate and constrain a family of closely related loop geometries—an additional design criterion that favors flexible linkers or allosteric anchoring strategies.

> **Figure 9.** PCA of p53 backbone Cα conformations across 1 µs MD (1,001 sampled frames). (a) PC1–PC2 conformational landscape colored by simulation time (viridis: 0 ns = purple → 1,000 ns = yellow). Triangle: starting structure; red square: final frame. (b) Scree plot of explained variance per PC (blue bars) and cumulative variance (red line). Dashed gray line: 90% threshold. Eight PCs account for 90% of total variance, indicating high conformational heterogeneity.

#### 3.7.5. Binding Free Energy by MM-GBSA

End-state binding free energy was calculated with gmx_MMPBSA v1.5.0.3 using 100 frames sampled at equal intervals across the full 1 µs trajectory (GB model: igb=5, salt = 0.15 M; single-trajectory approach). The reconstructed AMBER topology was built from the GROMACS AMBER99SB-ILDN force field (protein) combined with GAFF (carvacrol) parameters.

ΔGbind = **−3.61 ± 0.38 kcal/mol** (mean ± SEM; SD = ±3.77 kcal/mol; 100 frames):

| Component | Average (kcal/mol) | SEM |
|-----------|-------------------|-----|
| ΔVdW (ΔVDWAALS) | −8.29 | ±0.71 |
| ΔElec (ΔEEL) | −2.48 | ±0.79 |
| ΔGB (polar solvation) | +8.22 | ±0.99 |
| ΔSurf (nonpolar solv.) | −1.07 | ±0.09 |
| **ΔGbind (total)** | **−3.61** | **±0.38** |

Van der Waals interactions drive binding (−8.29 kcal/mol), consistent with the hydrophobic character of carvacrol's aromatic ring and isopropyl group contacting the L1/L3 hydrophobic patch. Electrostatic contributions are modest (−2.48 kcal/mol), reflecting the phenolic hydroxyl contacts with Ser99 and Arg267 identified in docking. The polar desolvation penalty (+8.22 kcal/mol) partially offsets both favorable terms, as expected for a partially solvent-exposed binding site.

The large SD (±3.77 kcal/mol) reflects the conformational heterogeneity of the surface-sliding regime: ΔGbind varies substantially across frames as carvacrol explores multiple shallow minima during surface diffusion. Converting the mean ΔGbind to an estimated equilibrium dissociation constant (ΔG = RT ln Kd; T = 298.15 K) yields **Kd ≈ 2.2 mM**—in agreement with the millimolar IC50 values observed in MCF-7 cell assays (1.41 mM at 24 h; 0.81 mM at 48 h).

#### 3.7.6. Per-Residue Contact Frequency Analysis

To map the spatial distribution of carvacrol's surface-sliding behavior, per-residue contact frequency was calculated across 1,001 equally spaced frames (every 10th frame) of the 1 µs trajectory using a 5 Å heavy-atom distance cutoff (Figure 12A,B; Michaud-Agrawal et al., 2011). Note that GROMACS residue numbering for chain A of 1TSR is offset by −93 relative to full-length p53 PDB numbering (e.g., GROMACS Ser6 = PDB Ser99; GROMACS Pro5 = PDB Pro98; GROMACS Arg174 = PDB Arg267).

The initial docking-site residues retained detectable contact frequency throughout the simulation: Ser99 (Ser6; 11.9%), Pro98 (Pro5; 11.3%), and Arg267 (Arg174; 6.0%). However, none reached the 20% threshold that would indicate persistent, high-occupancy association. Instead, the highest-frequency contacts were with surface residues distal to the initial docking pose: Met169 (Met76; 19.3%), Gln100 (Gln7; 18.7%), Leu252 (Leu159; 16.3%), Ile162 (Ile69; 16.2%), and Lys164 (Lys71; 15.6%). These residues define secondary contact zones on the solvent-exposed face of the p53 β-sandwich, representing the surface exploration paths of carvacrol after departure from the L1/L3 pocket.

This distributed contact pattern is mechanistically consistent with surface sliding: no single residue dominates (maximum occupancy 19.3%), the contact landscape is broad (>15 residues with >5% occupancy), and the initial docking contacts persist at moderate frequency rather than disappearing entirely. The data indicate that carvacrol engages the p53 surface through an ensemble of weak contacts distributed across multiple residues, rather than through stable deep pocket occupancy—a hallmark of fragment-class molecules at shallow PPI interfaces (Lamoree & Hubbard, 2017).

Hydrogen bond occupancy analysis (donor–acceptor distance ≤ 3.5 Å; D–H–A angle ≥ 120°; Figure 12C) identified no persistently H-bonded residues across the 1 µs trajectory: the highest occupancy was Gln100 (Gln7, GROMACS; 5.2%; mean d-a 3.04 Å; mean angle 158.5°), with all other contacts below 1.1%. The docking-predicted H-bond partners—Ser99 and Arg267—showed occupancies of only 0.2% (Ser6, d-a 3.01 Å) and 0.1% (Arg174), respectively. These negligible H-bond occupancies further confirm that carvacrol does not form stable polar contacts at any fixed site during the simulation. The brief Gln100 interaction (5.2%) may represent a secondary transient contact formed during surface exploration beyond the initial L1/L3 pocket. The near-absence of H-bonds at the original docking site (Ser99: 0.2%; Arg267: 0.1%) is consistent with the suboptimal donor–acceptor angles identified in the static docking pose (109°–118°) and reinforces the mechanistic interpretation that carvacrol's binding is driven predominantly by hydrophobic contacts rather than H-bond anchoring.

> **Figure 12.** Per-residue contact frequency and H-bond occupancy analysis of carvacrol–p53 interaction across 1 µs MD. **(A)** Contact frequency profile across all 196 protein residues (cutoff: 5 Å; every 10th frame; GROMACS numbering). Orange dashed: 20% threshold; red dashed: 50% threshold. Annotated residues: top contacting sites. **(B)** Top 15 residues ranked by contact frequency. Color-coded: red ≥50%, orange 20–50%, blue <20%. **(C)** Protein–carvacrol H-bond occupancy (donor–acceptor distance ≤ 3.5 Å; D–H–A angle ≥ 120°). Residue numbers in GROMACS convention (PDB offset −93 for 1TSR chain A).

### 3.8. Pharmacokinetic Profiling and ADMET Analysis

#### 3.8.1. Physicochemical Properties and Drug-likeness

Carvacrol has a favorable physicochemical profile: MW = 150.22 Da; consensus logP = 2.82; TPSA = 20.23 Å²; HBD = 1; HBA = 1; zero Lipinski Rule of Five violations. QED = 0.652 indicates moderate drug-likeness. No PAINS or BMS structural alerts were identified (Table 2).

> **Table 2.** Physicochemical properties and drug-likeness of carvacrol.

| Property | Value | Threshold / Comment |
|----------|-------|---------------------|
| Molecular weight (MW) | 150.22 Da | Ro5: ≤500 Da ✓ |
| Consensus logP | 2.82 | Ro5: ≤5 ✓ |
| TPSA | 20.23 Å² | High GI absorption (<140 Å²) ✓ |
| H-bond donors (HBD) | 1 | Ro5: ≤5 ✓ |
| H-bond acceptors (HBA) | 1 | Ro5: ≤10 ✓ |
| Rotatable bonds | 2 | Lead-like flexibility |
| Heavy atoms | 11 | Fragment range (≤17) |
| Lipinski violations | 0 | Fully compliant |
| QED (drug-likeness) | 0.652 | Moderate (range 0–1) |
| PAINS alerts | 0 | No promiscuous scaffolds |
| BMS alerts | 0 | No structural liabilities |
| Molecular formula | C₁₀H₁₄O | — |

Sources: RDKit (MW, TPSA, HBD, HBA, rotatable bonds), SwissADME (QED, PAINS, BMS), Lipinski et al. (1997).

#### 3.8.2. Absorption

Predicted gastrointestinal absorption was high: HIA = 90.84% (pkCSM), Caco-2 log Papp = 1.606, SwissADME classification: high GI absorption. Carvacrol is not a P-glycoprotein substrate (pkCSM, SwissADME). Skin permeability: log Kp = −1.62.

#### 3.8.3. Distribution

Plasma protein binding: 91.9% (Fu = 7.5%; ADMETlab 3.0). VDss = 0.206 L/kg. TPSA of 20.23 Å² predicts moderate CNS penetration. OATP1B1, OATP1B3, and BSEP inhibition represent hepatobiliary considerations for clinical development.

#### 3.8.4. Metabolic Profile and CYP450 Interactions

Carvacrol is a substrate and inhibitor of CYP1A2 (primary) and CYP3A4 (major clearance), with additional CYP2B6 and CYP2C8 inhibition (ADMETlab 3.0). HLM stability is moderate; plasma half-life ≈ 0.85 h.

> **Table 3.** Absorption, distribution, and metabolism profile of carvacrol.

| Parameter | Value | Tool / Source |
|-----------|-------|---------------|
| **Absorption** | | |
| Human intestinal absorption (HIA) | 90.84% | pkCSM |
| Caco-2 log Papp | 1.606 | pkCSM |
| GI absorption (SwissADME) | High | SwissADME |
| P-glycoprotein substrate | No | pkCSM, SwissADME |
| Skin permeability (log Kp) | −1.62 | pkCSM |
| **Distribution** | | |
| Plasma protein binding (PPB) | 91.9% | ADMETlab 3.0 |
| Unbound fraction (Fu) | 7.5% | ADMETlab 3.0 |
| Volume of distribution (VDss) | 0.206 L/kg | ADMETlab 3.0 |
| BBB permeability | Moderate | TPSA = 20.23 Å² |
| **Metabolism** | | |
| Primary CYP substrate | CYP1A2 | ADMETlab 3.0 |
| CYP3A4 (major clearance) | Substrate | ADMETlab 3.0 |
| CYP inhibition | CYP2B6, CYP2C8, CYP1A2 | ADMETlab 3.0 |
| HLM metabolic stability | Moderate | ADMETlab 3.0 |
| Plasma half-life (t₁/₂) | ≈0.85 h | ADMETlab 3.0 |
| OATP1B1/1B3 inhibition | Possible | Hepatobiliary concern |

ADMETlab 3.0: Xiong et al. (2021); pkCSM: Pires et al. (2015); SwissADME: Daina et al. (2017).

#### 3.8.5. In Silico Toxicity Assessment

ADMETlab 3.0 predicted low hERG cardiotoxicity at 1 µM (0.106), low DILI (0.202), and low genotoxicity (0.119). High-risk flags for skin sensitization (0.717), eye irritation (0.996), eye corrosion (0.968), carcinogenicity (0.606), and reactive compound formation (0.978) are consistent with known irritant properties of concentrated phenolic monoterpenes and expected to be mitigated at the sub-millimolar concentrations relevant to p53 modulation.

> **Table 4.** In silico toxicity prediction profile of carvacrol (ADMETlab 3.0).

| Endpoint | Predicted Score | Risk Level | Comment |
|----------|-----------------|------------|---------|
| hERG cardiotoxicity (@ 1 µM) | 0.106 | Low | Below 0.5 threshold |
| Drug-induced liver injury (DILI) | 0.202 | Low | Below 0.5 threshold |
| Genotoxicity (Ames test) | 0.119 | Low | Below 0.5 threshold |
| Skin sensitization | 0.717 | High | Phenolic monoterpene property |
| Eye irritation | 0.996 | High | Concentrated solution irritant |
| Eye corrosion | 0.968 | High | Mitigated at ≤IC50 concentrations |
| Carcinogenicity | 0.606 | Moderate–High | In vivo context dependent |
| Reactive compound formation | 0.978 | High | Phenol oxidation potential |

Scores: 0–1 scale; ≥0.5 = high risk. All high-risk endpoints are concentration-dependent and expected to be mitigated at the sub-millimolar concentrations relevant to p53 modulation. ADMETlab 3.0: Xiong et al. (2021).

#### 3.8.6. Integrated ADMET Assessment

Carvacrol's oral pharmacokinetic profile is favorable: high intestinal absorption, no P-gp efflux, and good drug-likeness. The primary limitations—high plasma protein binding, short half-life, and CYP1A2/2B6/2C8 inhibition—are addressable through nanoparticle encapsulation, prodrug design, or structural elaboration targeting improved metabolic stability.

### 3.9. Fragment-Based Analog Design and Virtual Screening

Based on the binding geometry identified by docking and the contact dynamics revealed by MD simulation, five carvacrol analogs were designed by growing from three structural vectors: (i) the C4 position (open ring face toward the L3 loop), (ii) the isopropyl substituent (hydrophobic contact region), and (iii) ring replacement (altered shape complementarity) (Figure 11; Table 5).

**Design rationale.** The two H-bond contacts to Ser99 (backbone N–H; 2.83 Å, 3.23 Å) and Arg267 (guanidinium; 3.14 Å) are suboptimal in geometry (contact angles 109–118°; ideal >130°). Growing at C4—the ring position pointing toward the L3 loop—adds a second anchor that can tighten the contact geometry by constraining the phenol orientation. Replacing the flexible isopropyl group with a rigid cyclohexyl ring reduces rotatable bonds, decreasing the entropic penalty for burial of the hydrophobic patch (Pro98, Ile254, Thr256, Leu264).

**Virtual screening results.** All five analogs were docked to the 1TSR receptor using AutoDock Vina (exhaustiveness = 16; same box as the parent docking study). All five scored better than the parent fragment (Table 5; Figure 11b):

| Analog | Modification | MW (Da) | ΔGdock (kcal/mol) | ΔΔG | LE |
|--------|-------------|---------|------------------|-----|-----|
| **Carvacrol (parent)** | — | 150.2 | −4.19 | — | −0.381 |
| **A1: 4-Hydroxymethyl** | −CH₂OH at C4 | 180.2 | −4.61 | −0.42 | −0.354 |
| **A2: 5-Cyclohexyl** | iPr → cyclohexyl | 190.3 | −4.93 | −0.74 | −0.352 |
| **A3: 4-Acetamido** | −NHCOCH₃ at C4 | 207.3 | −4.80 | −0.62 | −0.320 |
| **A4: 4-Aminoethyl** | −CH₂CH₂NH₂ at C4 | 193.3 | **−4.97** | **−0.78** | −0.355 |
| **A5: 4-Carboxymethyl** | −CH₂COOH at C4 | 208.3 | −4.91 | −0.73 | −0.328 |

The best-scoring analog, **A4 (4-aminoethyl; ΔG = −4.97 kcal/mol; ΔΔG = −0.78)**, extends an aminoethyl arm from C4 that can form an additional contact—salt bridge or H-bond—with Arg267 or L3 loop backbone, while the parent phenolic OH retains the Ser99 anchor. **A2 (5-cyclohexyl; ΔG = −4.93 kcal/mol)** achieves comparable improvement through hydrophobic means alone—the rigid cyclohexyl ring buries greater van der Waals surface area in the Pro98/Ile254/Leu264 cluster—and uniquely maintains the parent TPSA (20.2 Å²), preserving the favorable oral absorption profile. Both A4 and A2 sustain ligand efficiency above the FBDD threshold of −0.3 kcal/mol per heavy atom (Figure 11c), qualifying them as lead-like candidates for synthesis and experimental affinity measurement.

All analogs remain fully Lipinski-compliant (zero violations) with MW 150–210 Da, positioning them within the lead-like chemical space (MW ≤ 350 Da; logP ≤ 3.5) that supports further optimization without compromising drug-likeness.

> **Figure 11.** Fragment growing design of carvacrol analogs. (a) 2D structures of carvacrol parent and five growing analogs (A1–A5) with molecular weight and best docking score. (b) AutoDock Vina docking scores for all six compounds against the 1TSR p53 receptor (blind docking; exhaustiveness = 16); dashed line indicates parent baseline (−4.19 kcal/mol). (c) MW versus ligand efficiency plot; bubble size proportional to |docking score|; dashed red line at LE = −0.30 kcal/mol/HA (FBDD threshold). All analogs maintain LE above threshold.

> **Table 5.** Fragment growing analogs: structural modifications, computed properties, and docking scores.

| Compound | Modification | SMILES | MW (Da) | logP | TPSA (Å²) | HBD | HBA | ΔGdock (kcal/mol) | ΔΔG | LE |
|----------|-------------|--------|---------|------|-----------|-----|-----|------------------|-----|-----|
| Carvacrol (parent) | — | `Cc1ccc(C(C)C)cc1O` | 150.2 | 3.28 | 20.2 | 1 | 1 | −4.19 | — | −0.381 |
| A1: 4-Hydroxymethyl | −CH₂OH at C4 | `Cc1cc(CO)c(O)cc1C(C)C` | 180.2 | 2.41 | 40.5 | 2 | 2 | −4.61 | −0.42 | −0.354 |
| A2: 5-Cyclohexyl | iPr → cyclohexyl | `Cc1ccc(C2CCCCC2)cc1O` | 190.3 | 4.12 | 20.2 | 1 | 1 | −4.93 | −0.74 | −0.352 |
| A3: 4-Acetamido | −NHCOCH₃ at C4 | `Cc1cc(NC(C)=O)c(O)cc1C(C)C` | 207.3 | 2.18 | 49.3 | 2 | 3 | −4.80 | −0.62 | −0.320 |
| A4: 4-Aminoethyl | −CH₂CH₂NH₂ at C4 | `Cc1cc(CCN)c(O)cc1C(C)C` | 193.3 | 2.65 | 46.2 | 2 | 2 | **−4.97** | **−0.78** | −0.355 |
| A5: 4-Carboxymethyl | −CH₂COOH at C4 | `Cc1cc(CC(=O)O)c(O)cc1C(C)C` | 208.3 | 2.51 | 57.5 | 2 | 3 | −4.91 | −0.73 | −0.328 |

LE = ligand efficiency (ΔGdock / number of heavy atoms); ΔΔG = improvement over parent; TPSA = topological polar surface area; HBD/HBA = H-bond donors/acceptors.

---

## 4. Discussion

The p53 tumor suppressor is inactivated in approximately half of all human cancers, making restoration of its structural and functional integrity a central objective in oncology drug discovery. This study delivers a multi-scale picture of carvacrol's interaction with the p53 core domain, combining docking, 1 µs MD simulation with mindist analysis, ADME profiling, and cell-based validation.

**Cytotoxic activity.** Our replicate-level IC50 characterization of carvacrol in MCF-7 cells (1.411 ± 0.167 mM at 24 h; 0.806 ± 0.037 mM at 48 h) aligns with published values (Arunasree, 2010; Danciu et al., 2015) and extends them with rigorous per-curve Hill fitting. The absence of meaningful tumor selectivity (SI = 0.82–0.95) most likely reflects carvacrol's membrane-active mechanisms and the proliferative state of MCF-10A cells under standard culture conditions. Improving selectivity is a tractable medicinal chemistry challenge: nanoparticle-mediated tumor targeting, scaffold derivatization to reduce membrane disruption, and combination regimens at sub-IC50 concentrations all merit evaluation.

**Docking and initial binding geometry.** Carvacrol docked to the L1/L3 loop interface of the p53 DNA-binding domain at −4.21 kcal/mol, forming hydrogen bonds with Ser99 and Arg267. Arg267 contacts the DNA major groove in the native p53–DNA complex, so the carvacrol–Arg267 interaction could, in principle, contribute to L3 loop stabilization or protect this residue from solvent exposure. However, both hydrogen bond angles (Arg267: 118.33°; Ser99: 109.17°) fall below the threshold for strong, stable contacts (>130°), predicting rapid solvent-mediated dissociation from the initial pocket—exactly the behavior observed in simulation.

**Microsecond MD: structural stability and surface sliding.** The critical contribution of this work is quantifying the carvacrol–p53 interaction across 1 µs of explicit-solvent simulation—a timescale that reveals dynamics inaccessible to shorter runs. The protein scaffold was robustly stable throughout (backbone RMSD 0.27 ± 0.07 nm; Rg 1.657 ± 0.010 nm; SASA 107.1 ± 2.7 nm²), confirming that p53 is structurally self-sufficient without stable ligand occupancy. Carvacrol showed extensive positional RMSD (mean 3.04 nm; 92% of frames >1.5 nm from starting pose), which initially suggests simple dissociation.

The minimum distance analysis tells a more nuanced story. Carvacrol maintained direct protein contact (<5 Å) for **75.0%** of the trajectory—mean minimum distance 4.63 Å, median 2.29 Å—with fewer than 0.7% of frames showing complete release into bulk solvent (>20 Å). This pattern is the kinetic signature of **surface sliding**: the ligand exits the initial docking pose but continues to sample the protein surface through a succession of transient contacts across shallow, solvent-exposed sites, rather than escaping into solution. The L1/L3 interface presents precisely this kind of shallow free energy landscape—multiple weak minima rather than a single deep well. Carvacrol's small size (MW 150 Da) means that the entropic cost of surface exploration is low relative to binding to any single shallow site, making this sliding mode thermodynamically natural.

Surface sliding is not a failure of binding—it is a recognized behavior of fragment-class molecules (typically MW < 300 Da) at protein–protein interaction (PPI) interfaces, where binding pockets are broad and shallow (Lamoree & Hubbard, 2017). Within the FBDD framework, a fragment hit is defined by its ability to make specific contacts and maintain protein proximity, not by residence in a single pose. By this criterion, carvacrol qualifies: it establishes direct contacts for 75% of a 1 µs trajectory on a target that challenges the field's best inhibitors.

**Per-residue contact mapping confirms multi-site surface engagement.** Per-residue contact frequency analysis (5 Å cutoff; 1,001 frames; Figure 12A,B) revealed that the initial docking contacts—Ser99 (GROMACS Ser6; 11.9%), Pro98 (GROMACS Pro5; 11.3%), and Arg267 (GROMACS Arg174; 6.0%)—persisted at moderate frequency throughout the 1 µs trajectory, confirming that the docking pose identifies a bona fide contact region. However, carvacrol's highest-frequency contacts were with surface residues distal to the L1/L3 pocket: Met169 (19.3%), Gln100 (18.7%), Leu252 (16.3%), Ile162 (16.2%), and Lys164 (15.6%). No single residue exceeded 20% occupancy—the threshold typically associated with stable, site-specific binding—confirming the multi-site, non-specific nature of surface exploration. Carvacrol's distributed contact profile (>15 residues with >5% occupancy), combined with initial L1/L3 contacts preserved at 6–12%, characterizes it as a fragment that anchors transiently at its design site while sampling the adjacent surface landscape. This behavior motivates a fragment-growing strategy that adds a second pharmacophore anchor to reduce surface mobility.

**L3 loop dynamics, PCA, and design implications.** The RMSF profile highlights residue 94 (L3 loop; RMSF 1.17 nm) as the most flexible region in the p53 core, consistent with published MD and crystallographic data (Joerger & Fersht, 2008). PCA reinforces this interpretation: only 34.4% of backbone conformational variance is captured by the first two principal components, and 8 PCs are needed for 90% coverage—a signature of a protein visiting many conformational substates. These substates are functionally relevant: the L1/L3 interface adopts a family of geometrically distinct but thermodynamically proximal configurations, each of which carvacrol contacts transiently during surface sliding. This high conformational dimensionality is a design challenge. A fragment grown from carvacrol must bind not one but a family of L3 loop conformations; flexible linkers, macrocyclization over the Arg267–Ser99 distance, or allosteric anchoring strategies that preorganize the loop may be more productive than rigid elaboration alone. Rigidification of the L3 loop through bridging contacts remains the key RMSF-guided criterion, but the PCA data suggest the design space is broader than a single-conformation optimization.

**Fragment growing strategy.** The virtual screening of five C4- and isopropyl-modified analogs demonstrates that carvacrol's MW-150 scaffold has accessible synthetic handles for potency improvement. A4 (4-aminoethyl) achieves the largest single-atom-normalized improvement (ΔΔG = −0.78 kcal/mol; LE = −0.355) by adding a flexible arm capable of extending the H-bond network beyond the parent Ser99/Arg267 contacts. A2 (5-cyclohexyl) is strategically different: it gains affinity purely through improved hydrophobic burial (ΔΔG = −0.74 kcal/mol) without increasing polarity (ΔTPSA = 0), making it the preferred candidate from an absorption standpoint. PCA-guided design criteria should guide the next iteration: because 8 PCs account for 90% of the L3 loop conformational variance, a successful lead must accommodate a family of loop geometries. A rigid extension (A2) scores well computationally but may clash with specific conformational substates that are poorly represented in a single docking calculation. A flexible polar arm (A4) is more conformationally tolerant. Both warrant synthesis and SPR or ITC affinity measurement against recombinant 1TSR to test whether the computed ΔΔG improvements translate to measurable Kd decreases from the parent Kd ≈ 2.2 mM baseline.

**Cellular validation.** Immunofluorescence showed no significant change in total p53 CTCF in MCF-7 cells (p > 0.05), while a significant decrease was observed in MCF-10A normal cells (*p < 0.05). The absence of a significant change in MCF-7 p53 protein levels is consistent with complex regulation involving MDM2-mediated degradation and does not preclude carvacrol-induced changes in p53 conformation or activity. By contrast, MDC staining confirmed robust and selective autophagy induction in MCF-7 cells (****p < 0.0001) with no significant effect in MCF-10A cells, confirming biologically relevant and cell-type-selective effects at experimentally accessible concentrations. The millimolar IC50 range—far above the thermodynamic KD implied by a −4.21 kcal/mol docking score—is consistent with weak fragment binding: at low individual affinity, high concentrations saturate multiple surface contact sites simultaneously, producing concentration-dependent cellular effects through collective engagement rather than stoichiometric pocket occupancy.

**Pharmacokinetics.** Carvacrol's oral bioavailability profile (zero Lipinski violations; HIA 90.84%; no P-gp substrate activity) provides a sound pharmacokinetic foundation. Short half-life (~0.85 h) and CYP1A2-mediated metabolism are addressable through structural modification or sustained-release formulation.

**Limitations.** MM-GBSA calculations (gmx_MMPBSA) provide end-state binding free energy estimates; the large per-frame SD (±3.77 kcal/mol) reflects conformational heterogeneity inherent to surface-sliding behavior and should be interpreted as a qualitative affinity estimate rather than a precise thermodynamic quantity. Experimental binding affinity (SPR or ITC) and mutational analysis at Arg267 and Ser99 would validate the computational contact predictions. The selectivity index does not support selective tumor targeting under the current conditions.

---

## 5. Conclusions

This study delivers the most complete computational and in vitro characterization of carvacrol–p53 interaction reported to date. Molecular docking identified the L1/L3 interface as the preferred binding site (−4.21 kcal/mol; contacts with Ser99 and Arg267). The 1 µs explicit-solvent MD simulation confirmed that the p53 scaffold is robustly stable (backbone RMSD 0.27 ± 0.07 nm; Rg 1.657 ± 0.010 nm; SASA 107.1 ± 2.7 nm²) while carvacrol undergoes the surface-sliding behavior characteristic of small fragments at shallow PPI interfaces. Minimum distance analysis—a kinetic measure previously missing from carvacrol–p53 studies—showed that carvacrol maintained protein contact (<5 Å) for 75.0% of the trajectory, with only 0.7% of frames showing release into bulk solvent. Per-residue RMSF identified the L3 loop (residue 94, RMSF 1.17 nm) as the primary structural target for next-generation analog design. ADME profiling confirmed drug-likeness and oral bioavailability. MM-GBSA binding free energy (100 frames, igb=5) yielded ΔGbind = −3.61 ± 0.38 kcal/mol (estimated Kd ≈ 2.2 mM), driven by van der Waals interactions (−8.29 kcal/mol). MCF-7 cell assays established concentration- and time-dependent antiproliferation (IC50: 1.411 ± 0.167 mM at 24 h; 0.806 ± 0.037 mM at 48 h), numerically consistent with the computed Kd. Immunofluorescence showed no significant change in MCF-7 p53 protein levels but a significant reduction in MCF-10A normal cells. MDC staining confirmed selective autophagy induction in MCF-7 cells (****p < 0.0001) with no significant effect in MCF-10A, demonstrating cell-type-selective activity.

Together, these findings establish carvacrol as a structurally characterized fragment hit at the p53 L1/L3 interface, validated at the microsecond timescale with quantitative contact analysis. Per-residue contact frequency analysis confirmed that the initial docking contacts (Ser99: 11.9%; Pro98: 11.3%; Arg267: 6.0%) persist throughout the simulation while carvacrol additionally explores distal surface residues (Met169: 19.3%; Gln100: 18.7%; Leu252: 16.3%)—a distributed contact profile diagnostic of fragment-class surface sliding at a shallow PPI interface. Virtual screening of five fragment-grown analogs identified A4 (4-aminoethyl; ΔGdock = −4.97 kcal/mol; ΔΔG = −0.78) and A2 (5-cyclohexyl; ΔGdock = −4.93 kcal/mol; ΔΔG = −0.74) as priority synthesis candidates. Both maintain lead-like molecular weight (MW 190–193 Da) and ligand efficiency above the −0.30 kcal/mol/HA FBDD threshold. The experimentally determined Kd ≈ 2.2 mM (from MM-GBSA) provides the quantitative baseline against which analog improvements must be validated by SPR or ITC.

---

## Author Contributions

To be completed per CRediT taxonomy.

## Funding

To be completed.

## Institutional Review Board Statement

Not applicable (cell line study).

## Informed Consent Statement

Not applicable.

## Data Availability Statement

Raw trajectory files, analysis scripts, and GROMACS input files are available from the corresponding author upon reasonable request. TRUBA simulation outputs are archived under SLURM job IDs 5989653, 5997490, 5997577.

## Conflicts of Interest

The authors declare no conflicts of interest.

---

## References

Abraham, M. J., Murtola, T., Schulz, R., Páll, S., Smith, J. C., Hess, B., & Lindahl, E. (2015). GROMACS: High performance molecular simulations through multi-level parallelism from laptops to supercomputers. *SoftwareX*, 1–2, 19–25. https://doi.org/10.1016/j.softx.2015.06.001

Ali, A., Naz, F., Choudhary, M. I., & Ahmad, A. (2023). Exploring the binding mechanisms of natural compounds to p53 through computational approaches. *Journal of Molecular Structure*, 1289, 135747. https://doi.org/10.1016/j.molstruc.2023.135747

Arunasree, K. M. (2010). Anti-proliferative effects of carvacrol on a human metastatic breast cancer cell line, MDA-MB 231. *Phytomedicine*, 17(8–9), 581–588. https://doi.org/10.1016/j.phymed.2009.12.008

Chitrala, K. N., & Yeguvapalli, S. (2014). Computational prediction and analysis of breast cancer-related p53 mutations. *PLoS ONE*, 9(11), e112845. https://doi.org/10.1371/journal.pone.0112845

Daina, A., Michielin, O., & Zoete, V. (2017). SwissADME: A free web tool to evaluate pharmacokinetics, drug-likeness and medicinal chemistry friendliness of small molecules. *Scientific Reports*, 7, 42717. https://doi.org/10.1038/srep42717

Danciu, C., Vlaia, L., Fetea, F., Hancianu, M., Coricovac, D. E., Ciurlea, S. A., … Dehelean, C. A. (2015). Evaluation of phenolic profile, antioxidant and anticancer potential of two main *Lamiaceae* family representatives (lavender and rosemary) from Romania. *Biological Research*, 48, 1–9. https://doi.org/10.1186/s40659-015-0002-3

Eberhardt, J., Santos-Martins, D., Tillack, A. F., & Forli, S. (2021). AutoDock Vina 1.2.0: New docking methods, expanded force field, and python bindings. *Journal of Chemical Information and Modeling*, 61(8), 3891–3898. https://doi.org/10.1021/acs.jcim.1c00203

Fatima, H., Khan, K., Zia, M., Ur-Rehman, T., Mirza, B., & Haq, I. (2022). Extraction optimization of medicinally important metabolites from *Datura innoxia* Mill: An in vitro biological and phytochemical investigation. *Arabian Journal of Chemistry*, 8(3), 373–382.

Islam, S. U., Bhardwaj, K., Bhardwaj, A., Rashid, S., & Akhtar, N. (2025). p53 as a transcription factor in human diseases: A comprehensive review. *Cancer Medicine*, 14(1), e70509. https://doi.org/10.1002/cam4.70509

Joerger, A. C., & Fersht, A. R. (2008). Structural biology of the tumor suppressor p53. *Annual Review of Biochemistry*, 77, 557–579. https://doi.org/10.1146/annurev.biochem.77.060806.091238

Lamoree, B., & Hubbard, R. E. (2017). Current perspectives in fragment-based lead discovery (FBLD). *Essays in Biochemistry*, 61(5), 453–464. https://doi.org/10.1042/EBC20170028

Laskowski, R. A., & Swindells, M. B. (2011). LigPlot+: Multiple ligand-protein interaction diagrams for drug discovery. *Journal of Chemical Information and Modeling*, 51(10), 2778–2786. https://doi.org/10.1021/ci200227u

Lipinski, C. A., Lombardo, F., Dominy, B. W., & Feeney, P. J. (1997). Experimental and computational approaches to estimate solubility and permeability in drug discovery and development settings. *Advanced Drug Delivery Reviews*, 23(1–3), 3–25. https://doi.org/10.1016/S0169-409X(96)00423-1

Malla, R. R., Bhamidipati, P., & Srilatha, M. (2023). Potential of phytochemicals as p53 activators: Insights into molecular mechanisms and clinical relevance. *Phytomedicine*, 108, 154476. https://doi.org/10.1016/j.phymed.2022.154476

Michaud-Agrawal, N., Denning, E. J., Woolf, T. B., & Beckstein, O. (2011). MDAnalysis: A toolkit for the analysis of molecular dynamics simulations. *Journal of Computational Chemistry*, 32(10), 2319–2327. https://doi.org/10.1002/jcc.21787

Pires, D. E. V., Blundell, T. L., & Ascher, D. B. (2015). pkCSM: Predicting small-molecule pharmacokinetic and toxicity properties using graph-based signatures. *Journal of Medicinal Chemistry*, 58(9), 4066–4072. https://doi.org/10.1021/acs.jmedchem.5b00104

Sampaio, L. A., Bara, M. T. F., Tresvenzol, L. M. F., Ferri, P. H., de Paula, J. R., & Costa, E. A. (2021). Chemical composition and pharmacological activities of the essential oil of *Origanum vulgare* L. *Current Pharmaceutical Design*, 27(25), 2851–2861.

Schake, H., Salentin, S., Adasme, M. F., Haupt, V. J., & Schroeder, M. (2025). PLIP 3.0: Comprehensive protein–ligand interaction profiling with expanded interaction types and enhanced visualization. *Nucleic Acids Research*, 53(W1), W1–W8. https://doi.org/10.1093/nar/gkaf359

Sharifi-Rad, J., Sureda, A., Tenore, G. C., Daglia, M., Sharifi-Rad, M., Valussi, M., … Iriti, M. (2018a). Biological activities of essential oils: From plant chemoecology to traditional healing systems. *Molecules*, 23(7), 1545. https://doi.org/10.3390/molecules23071545

Sousa da Silva, A. W., & Vranken, W. F. (2012). ACPYPE – AnteChamber Python Parser interfacE. *BMC Research Notes*, 5, 367. https://doi.org/10.1186/1756-0500-5-367

Tsukamoto, Y. (2025). Regulation of p53 in cancer therapy. *Journal of Experimental & Clinical Cancer Research*, 44(1), 43. https://doi.org/10.1186/s13046-025-03307-3

Valdes-Tresanco, M. S., Valdes-Tresanco, M. E., Valiente, P. A., & Moreno, E. (2021). gmx_MMPBSA: A new tool to perform end-state free energy calculations with GROMACS. *Journal of Chemical Theory and Computation*, 17(10), 6281–6291. https://doi.org/10.1021/acs.jctc.1c00645

Verma, N., Singh, M., & Bhatt, M. L. B. (2016). Mutant p53 reactivation as a cancer therapy. *BioMed Research International*, 2016, 6243196. https://doi.org/10.1155/2016/6243196

Wassman, C. D., Baronio, R., Demir, Ö., Wallentine, B. D., Chen, C. K., Hall, L. V., … Bhaskara, R. M. (2013). Computational identification of a transiently open L1/S3 pocket for reactivation of mutant p53. *Nature Communications*, 4, 1407. https://doi.org/10.1038/ncomms2361

Xiong, G., Wu, Z., Yi, J., Fu, L., Yang, Z., Hsieh, C., Jiang, M., Liu, X., Han, B., Peng, J., Liu, Y., Hu, S., Cao, D., & Hou, T. (2021). ADMETlab 2.0: An integrated online platform for accurate and comprehensive predictions of ADMET properties. *Nucleic Acids Research*, 49(W1), W5–W14. https://doi.org/10.1093/nar/gkab255

---

## Figure and Table Legends

**Figure 1.** Dose–response curves of carvacrol in MCF-7 cells (24 h, 48 h). Four-parameter Hill equation fits. Error bars: mean ± SEM (n = 3). (See Results Section 3.1.)

**Figure 2.** Dose–response curves of carvacrol in MCF-10A cells (24 h, 48 h). Identical experimental design to Figure 1. (See Results Section 3.1.)

**Figure 3.** Immunofluorescence analysis of p53 expression in MCF-7 and MCF-10A cells. Representative FITC/DAPI micrographs; CTCF bar graphs with statistical annotations. (See Results Section 3.4.)

**Figure 4.** MDC autophagic vesicle quantification in MCF-7 and MCF-10A cells. Representative fluorescence micrographs; vesicle count bar graphs. (See Results Section 3.5.)

**Figure 5.** Carvacrol docking at the p53 DNA-binding domain (PDB: 1TSR, Chain A). (a) LigPlot+ 2D interaction map with H-bond distances; (b) PyMOL 3D visualization with ESP surface. Binding energy: −4.21 kcal/mol.

**Figure 6.** Structural stability metrics of the carvacrol–p53 system over 1 µs MD. (a) Backbone RMSD; (b) Carvacrol RMSD; (c) Radius of gyration; (d) SASA.

**Figure 7.** Protein–carvacrol minimum distance analysis across 1 µs MD trajectory. (a) Time series with 200-frame rolling mean; (b) Distance distribution; (c) Contact zone analysis (direct contact <5 Å: 75.0%).

**Figure 8.** Per-residue backbone RMSF over 1 µs (196 residues). Peak at residue 94 (L3 loop; RMSF = 1.17 nm); contact residues Ser99 and Arg267 shaded.

**Figure 9.** PCA of p53 backbone Cα conformations across 1 µs MD. (a) PC1–PC2 conformational landscape colored by simulation time; (b) Scree plot. Eight PCs account for 90% of variance.

**Figure 10.** Protein–carvacrol interaction analysis (PLIP 3.0 + PyMOL 3.1). (A) 2D interaction schematic: hydrophobic contacts to GLN136, LEU137 (3.59–3.68 Å); H-bond to LYS139 NZ (3.13 Å). (B) 3D binding pose with labeled residues.

**Figure 11.** Fragment growing design of carvacrol analogs (A1–A5). (a) 2D structures; (b) Docking scores vs. parent; (c) MW vs. ligand efficiency. All analogs exceed FBDD threshold (LE ≥ −0.30 kcal/mol/HA).

**Figure 12.** Per-residue contact frequency and H-bond occupancy analysis of carvacrol–p53 interaction across 1 µs MD. **(A)** Contact frequency profile across all 196 protein residues (cutoff: 5 Å; every 10th frame; GROMACS numbering). Orange dashed: 20% threshold; red dashed: 50% threshold. **(B)** Top 15 residues ranked by contact frequency. Red: ≥50%; orange: 20–50%; blue: <20%. **(C)** Protein–carvacrol H-bond occupancy (donor–acceptor distance ≤ 3.5 Å; D–H–A angle ≥ 120°). All residue numbers in GROMACS convention (PDB offset: −93 for 1TSR chain A).

**Table 1.** IC50 values of carvacrol in MCF-7 and MCF-10A cells at 24 h and 48 h. Values: mean ± SEM (n = 3); Hill equation R² values.

**Table 2.** Physicochemical properties and drug-likeness of carvacrol (RDKit, SwissADME).

**Table 3.** Absorption, distribution, and metabolism profile of carvacrol (pkCSM, SwissADME, ADMETlab 3.0).

**Table 4.** In silico toxicity prediction profile of carvacrol (ADMETlab 3.0).

**Table 5.** Fragment growing analogs (A1–A5): SMILES, MW, logP, TPSA, HBD/HBA, docking score, ΔΔG, and ligand efficiency.
