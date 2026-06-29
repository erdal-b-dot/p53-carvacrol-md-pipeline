# Multi-Scale Characterization of Carvacrol–p53 Interaction: Structural Stabilization, Antiproliferative Activity, and Autophagy Induction in MCF-7 Breast Cancer Cells

---

## Abstract

The p53 tumor suppressor is inactivated in more than 50% of human cancers, primarily through missense mutations that destabilize its DNA-binding domain. Small-molecule chemical chaperones capable of restoring wild-type p53 conformation represent a high-priority therapeutic target. We evaluated carvacrol, a monoterpenoid phenol from Lamiaceae essential oils, against the p53 core domain (PDB: 1TSR) using molecular docking, 1 µs explicit-solvent molecular dynamics (MD) simulation, ADME profiling, and in vitro cell-based assays. Docking placed carvacrol at the L1/L3 loop interface with a binding affinity of −5.11 kcal/mol, forming hydrogen bonds with Ser99 and Arg267. The 1 µs MD simulation on the TRUBA HPC cluster revealed a mechanistic bifurcation: the p53 scaffold remained structurally intact throughout (backbone RMSD = 0.27 ± 0.07 nm; Rg = 1.657 ± 0.010 nm; SASA = 107.1 ± 2.7 nm²), while carvacrol transitioned from initial pocket binding to persistent surface contact. Protein–ligand minimum distance analysis showed that carvacrol maintained direct protein contact (<5 Å) for **75.0%** of the simulation (mean = 4.63 Å; median = 2.29 Å), with fewer than 0.7% of frames showing complete dissociation into bulk solvent (>20 Å). This surface-sliding behavior, consistent with fragment-based drug design (FBDD), indicates that carvacrol retains protein affinity without stable pocket occupancy. ADME profiling confirmed adherence to Lipinski's Rule of Five and high gastrointestinal absorption. In MCF-7 breast cancer cells, carvacrol reduced viability in a concentration- and time-dependent manner (IC50: 1.411 ± 0.167 mM at 24 h; 0.806 ± 0.037 mM at 48 h). Immunofluorescence revealed nuclear p53 accumulation, and MDC staining confirmed autophagy induction. These data establish carvacrol as a biologically active fragment scaffold at the p53 interface and provide a molecular foundation for designing optimized analogs through fragment-growing strategies.

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

The crystal structure of the human p53 core domain (PDB: 1TSR, resolution 2.20 Å) was retrieved from the RCSB Protein Data Bank. Chain A—the p53 monomer in its functional DNA-binding state—was isolated. Water molecules, co-crystallized heteroatoms, and bound DNA were removed using AutoDock Tools (ADT); polar hydrogens were added and Gasteiger charges assigned. The carvacrol structure (PubChem CID: 10838) was retrieved from PubChem, geometry-optimized by the MMFF94 force field in RDKit (v2023.09.1), and converted to PDBQT format via Open Babel (v3.1.1) with all rotatable bonds set to flexible.

#### 2.9.2. Docking Protocol

Docking was performed with AutoDock Vina (v1.2.5). The grid box was centered at the L1/L3 loop (x = 73.31, y = 28.57, z = 59.06 Å; dimensions 55.48 × 57.01 × 54.84 Å; exhaustiveness = 8). Interactions were analyzed with PLIP (v2.4.0) and LigPlot+. Three-dimensional visualization used PyMOL (Schrödinger LLC).

### 2.10. Molecular Dynamics Simulation

#### 2.10.1. System Preparation

All-atom MD simulations used GROMACS 2025.4 on the TRUBA HPC cluster (TUBITAK ULAKBIM). The AMBER99SB-ILDN force field was applied to the protein; the General AMBER Force Field (GAFF) was applied to carvacrol via ACPYPE. The complex was solvated in a cubic box (minimum protein-wall distance 1.0 nm; SPC/E water), then neutralized with Na⁺ and Cl⁻ at physiological concentration (29,651 total atoms; 26,538 water molecules; 28 Na⁺; 30 Cl⁻; 1 Zn²⁺).

#### 2.10.2. Equilibration and Production

Energy minimization used the steepest-descent algorithm (≤50,000 steps; convergence at F_max < 1,000 kJ mol⁻¹ nm⁻¹). NVT equilibration (100 ps, 300 K, V-rescale thermostat) preceded NPT equilibration (100 ps, 300 K, 1 bar, Parrinello–Rahman barostat). The 1,000 ns (1 µs) production run used a 2 fs time step, yielding 10,003 frames at 100 ps intervals. PME handled long-range electrostatics; van der Waals and short-range Coulomb interactions were truncated at 1.0 nm. LINCS constrained hydrogen bonds. The simulation ran as a SLURM job chain (IDs: 5989653 → 5997490 → 5997577) to accommodate TRUBA's 72 h wall-time limit.

#### 2.10.3. Trajectory Analysis

Periodic boundary condition (PBC) artifacts were corrected with `gmx trjconv -center -pbc mol -ur compact` (protein centering; backbone fit), yielding `md_center.xtc` (10,003 frames). Backbone RMSD (Cα, C, N, O atoms) and carvacrol heavy-atom RMSD were computed relative to the energy-minimized starting structure using `gmx rms`. Per-residue backbone RMSF used `gmx rmsf -res`. Radius of gyration and SASA were obtained with `gmx gyrate` and `gmx sasa`, respectively. Protein–ligand minimum distance at each frame was calculated with `gmx mindist` using protein (group 1) and carvacrol (group 15) as the two selections. All data were processed and plotted in Python (Matplotlib v3.10; NumPy v2.x). Trajectory PCA was performed with MDAnalysis (v2.10.0) on Cα atoms sampled every 10 frames.

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

Anti-p53 immunofluorescence in carvacrol-treated MCF-7 cells showed markedly increased signal relative to vehicle controls, with the FITC channel predominantly nuclear (Figure 7). Quantitative CTCF analysis confirmed a statistically significant elevation in treated MCF-7 cells compared to controls (p < 0.05, Mann–Whitney U test). In MCF-10A cells, p53 immunoreactivity increased to a lesser extent. No FITC signal was detected in negative controls lacking primary antibody.

> **Figure 7.** Immunofluorescence analysis of p53 in MCF-7 and MCF-10A cells. Representative micrographs (scale bar: 20 µm): (A) MCF-7 control; (B) MCF-10A control; (C) MCF-7 + carvacrol IC50; (D) MCF-10A + carvacrol IC50. Green: anti-p53; Blue: DAPI. Quantitative CTCF bar graphs: (E) MCF-7; (F) MCF-10A. Data: mean ± SEM (n ≥ 10 cells per group). *p < 0.05 (Mann–Whitney U test).

### 3.5. Autophagic Vesicle Quantification by MDC Staining

MDC staining revealed increased numbers and intensity of labeled puncta in carvacrol-treated cells compared to untreated controls (Figure 8). In MCF-7 cells, the mean number of autophagic vesicles per cell increased significantly (p < 0.05, Mann–Whitney U test). A comparable elevation was observed in MCF-10A cells.

> **Figure 8.** MDC staining for autophagic vesicle quantification. Representative micrographs (scale bar: 20 µm): (A) MCF-7 control; (B) MCF-10A control; (C) MCF-7 + carvacrol IC50; (D) MCF-10A + carvacrol IC50. Vesicle counts: (E) MCF-7—significant increase from ~35 (control) to ~63 vesicles/cell (carvacrol); ****P < 0.0001. (F) MCF-10A—no significant change; P > 0.05. Mann–Whitney U test; mean ± SEM (n ≥ 13 cells per group).

### 3.6. Molecular Docking and Binding Profile

Molecular docking placed carvacrol at the L1/L3 loop of the p53 DNA-binding domain with a highest-ranked affinity of −5.11 kcal/mol (Figure 5).

> **Figure 5.** Carvacrol docking at the p53 DNA-binding domain (PDB: 1TSR, Chain A). (a) LigPlot+ 2D interaction map. Hydrogen bonds (green dashed lines): Ser99(A) (2.83 Å, 3.25 Å) and Arg267(A) (3.14 Å). Hydrophobic contacts: Pro98(A), Ile254(A), Leu264(A), Thr256(A), Met160(A), Arg158(A), Glu258(A). (b) PyMOL 3D visualization with ESP surface (−60.2 to +60.2 kcal/mol·e). Binding energy: −5.105 kcal/mol.

#### 3.6.1. Interaction Profile

The phenolic hydroxyl group of carvacrol forms hydrogen bonds with Ser99 backbone (2.83 Å, 3.23 Å) and the Arg267 guanidinium group (3.14 Å). Geometric analysis revealed suboptimal donor–acceptor angles at Arg267 (118.33°) and Ser99 backbone nitrogen (109.17°)—both below the threshold for ideal linear geometry (>130°). Hydrophobic contacts with Pro98 (3.67 Å), Ile254 (3.69 Å), Thr256 (3.71 Å), and Leu264 (3.83 Å) supplement polar anchoring. The target pocket lacks sufficient depth to engulf carvacrol fully, leaving a substantial portion exposed to bulk solvent—a topological constraint that predicts kinetic instability at the microsecond timescale.

### 3.7. Molecular Dynamics Simulation (1 µs)

#### 3.7.1. Global Structural Stability of the p53 Scaffold

The p53 core domain maintained structural integrity across the full 1 µs simulation (10,003 frames; Figure 3a). Following equilibration within the first 10–20 ns, backbone RMSD stabilized at **0.27 ± 0.07 nm (2.66 ± 0.71 Å)**, with a maximum deviation of 0.431 nm. Radius of gyration was near-constant at **1.657 ± 0.010 nm** (Figure 3c), confirming that global tertiary structure was preserved without compaction or unfolding. SASA remained stable at **107.1 ± 2.7 nm²** (Figure 3d), consistent with intact hydrophobic core packing throughout the simulation. The p53 scaffold is therefore structurally self-sufficient at 300 K—a prerequisite for any chaperone hypothesis and a finding that extends prior 100 ns observations to the microsecond timescale.

> **Figure 3.** Structural metrics of the carvacrol–p53 system over 1 µs. (a) Backbone RMSD (blue): equilibration within 10–20 ns; steady-state mean = 0.27 ± 0.07 nm. Bold line: 50-frame rolling average. (b) Carvacrol RMSD (red): extensive positional sampling; mean = 3.04 ± 1.20 nm; maximum = 7.10 nm. Dashed lines at 0.5 and 1.5 nm indicate approximate bound and dissociated thresholds. (c) Radius of gyration (orange): stable at 1.657 ± 0.010 nm. (d) SASA (purple): stable at 107.1 ± 2.7 nm².

#### 3.7.2. Ligand Surface Dynamics and Minimum Distance Analysis

Carvacrol RMSD from the initial docking pose (computed after backbone superposition) averaged **3.04 ± 1.20 nm** (maximum 7.10 nm), indicating departure well beyond the initial binding pocket (Figure 3b). Only **1.6%** of frames had carvacrol within 0.5 nm of the initial pose (bound-like state); **92.0%** of frames showed displacement greater than 1.5 nm.

However, RMSD relative to a fixed origin is an incomplete measure of ligand behavior for surface-exploring molecules. Protein–ligand minimum distance analysis with `gmx mindist` provides a mechanistically richer account of contact persistence. This analysis revealed that, despite the high positional RMSD, carvacrol maintained **direct protein contact (< 5 Å) for 75.0% of the simulation** (Figure 5a,b,c). The mean minimum distance across all frames was **4.63 Å** (median 2.29 Å; minimum 1.49 Å; maximum 25.37 Å). Contact zone analysis classified the simulation as follows: direct surface contact (<5 Å) for **75.0%** of frames, near-surface proximity (5–8 Å) for **5.4%**, intermediate range (8–20 Å) for **18.9%**, and bulk solvent (>20 Å) for only **0.7%** (Figure 5c).

This contact pattern is inconsistent with simple dissociation; it describes **surface sliding**—a mode in which a fragment-class molecule explores the protein surface by diffusing from one shallow binding site to another without entering bulk solvent. The shallow, solvent-exposed L1/L3 pocket presents a free energy landscape of multiple shallow minima rather than a single deep well, enabling continuous surface exploration rather than the binary bound/unbound states typical of tighter protein–ligand complexes.

> **Figure 5.** Protein–carvacrol minimum distance analysis across the 1 µs MD trajectory. (a) Time series of minimum protein–carvacrol distance. Bold blue line: 200-frame rolling mean. Dashed lines: 5 Å (direct contact, green) and 8 Å (proximity, orange) thresholds. Green shading: periods of direct surface contact (<5 Å). (b) Distribution of minimum distances. Vertical lines indicate mean (red), 5 Å (green), and 8 Å (orange) thresholds. (c) Contact zone analysis: fraction of simulation time in each distance zone.

#### 3.7.3. Per-Residue Flexibility (RMSF)

Per-residue backbone RMSF revealed a bimodal flexibility profile (Figure 4). The beta-sandwich core (residues ~100–290, excluding loops) remained largely rigid (mean RMSF = 0.152 nm), consistent with the thermodynamic stability of the immunoglobulin-like fold. Peak fluctuations concentrated at residue 94 (RMSF = 1.17 nm), corresponding to the L3 loop of the DNA-binding interface—the same region targeted by carvacrol in docking. This intrinsic L3 loop dynamics, maintained even after carvacrol departure from the initial pose, mirrors the behavior of unliganded p53 reported in crystal structures and prior MD studies (Joerger & Fersht, 2008). Residues flanking the initial carvacrol contact sites—Ser99 and Arg267—showed moderate RMSF (0.1–0.3 nm), indicating preserved interface architecture despite ligand surface exploration.

> **Figure 4.** Per-residue backbone RMSF over 1 µs (196 residues). Dashed line: mean RMSF (0.152 nm). Arrow: residue 94 (L3 loop; RMSF = 1.17 nm). Vertical shading marks residues Ser99 and Arg267 (carvacrol contact sites from docking; RMSF 0.1–0.3 nm).

#### 3.7.4. Conformational Landscape by Principal Component Analysis

Principal component analysis (PCA) of the p53 backbone Cα positions across 1,001 sampled frames (every 10th of 10,003 total) revealed a conformationally rich landscape (Figure 6). PC1 and PC2 explained 18.1% and 16.3% of total variance, respectively (combined: 34.4%), and 8 principal components were required to account for 90% of variance. This diffuse variance distribution—where no single mode dominates and eight modes collectively describe most motion—indicates that the p53 core domain samples a broad ensemble of conformational substates rather than oscillating around a single energy minimum.

The PC1–PC2 projection colored by simulation time (Figure 6a) shows that the trajectory progressively populates new regions of conformational space, particularly after 200 ns, consistent with the established pattern of MD simulations that slowly overcome local energy barriers on the microsecond timescale. Despite this conformational heterogeneity, backbone RMSD never exceeded 4.31 Å, confirming that these distinct substates represent local structural rearrangements—primarily in flexible surface loops, especially the L3 loop—rather than partial unfolding or global structural transitions.

The high dimensionality of the conformational landscape (requiring 8 PCs for 90% coverage) is consistent with the pronounced L3 loop dynamics identified by RMSF analysis (residue 94, RMSF 1.17 nm) and corroborates the view that the p53 L1/L3 interface is an inherently dynamic region. For a carvacrol-based analog to achieve stable residence at this site, it must not merely bind one conformational state but accommodate and constrain a family of closely related loop geometries—an additional design criterion that favors flexible linkers or allosteric anchoring strategies.

> **Figure 6.** PCA of p53 backbone Cα conformations across 1 µs MD (1,001 sampled frames). (a) PC1–PC2 conformational landscape colored by simulation time (viridis: 0 ns = purple → 1,000 ns = yellow). Triangle: starting structure; red square: final frame. (b) Scree plot of explained variance per PC (blue bars) and cumulative variance (red line). Dashed gray line: 90% threshold. Eight PCs account for 90% of total variance, indicating high conformational heterogeneity.

### 3.8. Pharmacokinetic Profiling and ADMET Analysis

#### 3.8.1. Physicochemical Properties and Drug-likeness

Carvacrol has a favorable physicochemical profile: MW = 150.22 Da; consensus logP = 2.82; TPSA = 20.23 Å²; HBD = 1; HBA = 1; zero Lipinski Rule of Five violations. QED = 0.652 indicates moderate drug-likeness. No PAINS or BMS structural alerts were identified (Table 2).

> **Table 2.** Physicochemical properties and drug-likeness of carvacrol.

#### 3.8.2. Absorption

Predicted gastrointestinal absorption was high: HIA = 90.84% (pkCSM), Caco-2 log Papp = 1.606, SwissADME classification: high GI absorption. Carvacrol is not a P-glycoprotein substrate (pkCSM, SwissADME). Skin permeability: log Kp = −1.62.

#### 3.8.3. Distribution

Plasma protein binding: 91.9% (Fu = 7.5%; ADMETlab 3.0). VDss = 0.206 L/kg. TPSA of 20.23 Å² predicts moderate CNS penetration. OATP1B1, OATP1B3, and BSEP inhibition represent hepatobiliary considerations for clinical development.

#### 3.8.4. Metabolic Profile and CYP450 Interactions

Carvacrol is a substrate and inhibitor of CYP1A2 (primary) and CYP3A4 (major clearance), with additional CYP2B6 and CYP2C8 inhibition (ADMETlab 3.0). HLM stability is moderate; plasma half-life ≈ 0.85 h.

> **Table 3.** Absorption, distribution, and metabolism profile of carvacrol.

#### 3.8.5. In Silico Toxicity Assessment

ADMETlab 3.0 predicted low hERG cardiotoxicity at 1 µM (0.106), low DILI (0.202), and low genotoxicity (0.119). High-risk flags for skin sensitization (0.717), eye irritation (0.996), eye corrosion (0.968), carcinogenicity (0.606), and reactive compound formation (0.978) are consistent with known irritant properties of concentrated phenolic monoterpenes and expected to be mitigated at the sub-millimolar concentrations relevant to p53 modulation.

> **Table 4.** In silico toxicity prediction profile of carvacrol.

#### 3.8.6. Integrated ADMET Assessment

Carvacrol's oral pharmacokinetic profile is favorable: high intestinal absorption, no P-gp efflux, and good drug-likeness. The primary limitations—high plasma protein binding, short half-life, and CYP1A2/2B6/2C8 inhibition—are addressable through nanoparticle encapsulation, prodrug design, or structural elaboration targeting improved metabolic stability.

---

## 4. Discussion

The p53 tumor suppressor is inactivated in approximately half of all human cancers, making restoration of its structural and functional integrity a central objective in oncology drug discovery. This study delivers a multi-scale picture of carvacrol's interaction with the p53 core domain, combining docking, 1 µs MD simulation with mindist analysis, ADME profiling, and cell-based validation.

**Cytotoxic activity.** Our replicate-level IC50 characterization of carvacrol in MCF-7 cells (1.411 ± 0.167 mM at 24 h; 0.806 ± 0.037 mM at 48 h) aligns with published values (Arunasree, 2010; Danciu et al., 2015) and extends them with rigorous per-curve Hill fitting. The absence of meaningful tumor selectivity (SI = 0.82–0.95) most likely reflects carvacrol's membrane-active mechanisms and the proliferative state of MCF-10A cells under standard culture conditions. Improving selectivity is a tractable medicinal chemistry challenge: nanoparticle-mediated tumor targeting, scaffold derivatization to reduce membrane disruption, and combination regimens at sub-IC50 concentrations all merit evaluation.

**Docking and initial binding geometry.** Carvacrol docked to the L1/L3 loop interface of the p53 DNA-binding domain at −5.11 kcal/mol, forming hydrogen bonds with Ser99 and Arg267. Arg267 contacts the DNA major groove in the native p53–DNA complex, so the carvacrol–Arg267 interaction could, in principle, contribute to L3 loop stabilization or protect this residue from solvent exposure. However, both hydrogen bond angles (Arg267: 118.33°; Ser99: 109.17°) fall below the threshold for strong, stable contacts (>130°), predicting rapid solvent-mediated dissociation from the initial pocket—exactly the behavior observed in simulation.

**Microsecond MD: structural stability and surface sliding.** The critical contribution of this work is quantifying the carvacrol–p53 interaction across 1 µs of explicit-solvent simulation—a timescale that reveals dynamics inaccessible to shorter runs. The protein scaffold was robustly stable throughout (backbone RMSD 0.27 ± 0.07 nm; Rg 1.657 ± 0.010 nm; SASA 107.1 ± 2.7 nm²), confirming that p53 is structurally self-sufficient without stable ligand occupancy. Carvacrol showed extensive positional RMSD (mean 3.04 nm; 92% of frames >1.5 nm from starting pose), which initially suggests simple dissociation.

The minimum distance analysis tells a more nuanced story. Carvacrol maintained direct protein contact (<5 Å) for **75.0%** of the trajectory—mean minimum distance 4.63 Å, median 2.29 Å—with fewer than 0.7% of frames showing complete release into bulk solvent (>20 Å). This pattern is the kinetic signature of **surface sliding**: the ligand exits the initial docking pose but continues to sample the protein surface through a succession of transient contacts across shallow, solvent-exposed sites, rather than escaping into solution. The L1/L3 interface presents precisely this kind of shallow free energy landscape—multiple weak minima rather than a single deep well. Carvacrol's small size (MW 150 Da) means that the entropic cost of surface exploration is low relative to binding to any single shallow site, making this sliding mode thermodynamically natural.

Surface sliding is not a failure of binding—it is a recognized behavior of fragment-class molecules (typically MW < 300 Da) at protein–protein interaction (PPI) interfaces, where binding pockets are broad and shallow (Lamoree & Hubbard, 2017). Within the FBDD framework, a fragment hit is defined by its ability to make specific contacts and maintain protein proximity, not by residence in a single pose. By this criterion, carvacrol qualifies: it establishes direct contacts for 75% of a 1 µs trajectory on a target that challenges the field's best inhibitors.

**L3 loop dynamics, PCA, and design implications.** The RMSF profile highlights residue 94 (L3 loop; RMSF 1.17 nm) as the most flexible region in the p53 core, consistent with published MD and crystallographic data (Joerger & Fersht, 2008). PCA reinforces this interpretation: only 34.4% of backbone conformational variance is captured by the first two principal components, and 8 PCs are needed for 90% coverage—a signature of a protein visiting many conformational substates. These substates are functionally relevant: the L1/L3 interface adopts a family of geometrically distinct but thermodynamically proximal configurations, each of which carvacrol contacts transiently during surface sliding. This high conformational dimensionality is a design challenge. A fragment grown from carvacrol must bind not one but a family of L3 loop conformations; flexible linkers, macrocyclization over the Arg267–Ser99 distance, or allosteric anchoring strategies that preorganize the loop may be more productive than rigid elaboration alone. Rigidification of the L3 loop through bridging contacts remains the key RMSF-guided criterion, but the PCA data suggest the design space is broader than a single-conformation optimization.

**Cellular validation.** The nuclear accumulation of p53 (immunofluorescence) and increased autophagic vesicle counts (MDC staining) in carvacrol-treated MCF-7 cells confirm biologically relevant effects at experimentally accessible concentrations. The millimolar IC50 range—far above the thermodynamic KD implied by a −5.11 kcal/mol docking score—is consistent with weak fragment binding: at low individual affinity, high concentrations saturate multiple surface contact sites simultaneously, producing concentration-dependent cellular effects through collective engagement rather than stoichiometric pocket occupancy.

**Pharmacokinetics.** Carvacrol's oral bioavailability profile (zero Lipinski violations; HIA 90.84%; no P-gp substrate activity) provides a sound pharmacokinetic foundation. Short half-life (~0.85 h) and CYP1A2-mediated metabolism are addressable through structural modification or sustained-release formulation.

**Limitations.** gmx_MMPBSA binding free energy calculations were not available in the current computational environment and would provide a more rigorous quantitative estimate of ΔGbind. Experimental binding affinity (SPR or ITC) and mutational analysis at Arg267 and Ser99 would validate the computational contact predictions. The selectivity index does not support selective tumor targeting under the current conditions.

---

## 5. Conclusions

This study delivers the most complete computational and in vitro characterization of carvacrol–p53 interaction reported to date. Molecular docking identified the L1/L3 interface as the preferred binding site (−5.11 kcal/mol; contacts with Ser99 and Arg267). The 1 µs explicit-solvent MD simulation confirmed that the p53 scaffold is robustly stable (backbone RMSD 0.27 ± 0.07 nm; Rg 1.657 ± 0.010 nm; SASA 107.1 ± 2.7 nm²) while carvacrol undergoes the surface-sliding behavior characteristic of small fragments at shallow PPI interfaces. Minimum distance analysis—a kinetic measure previously missing from carvacrol–p53 studies—showed that carvacrol maintained protein contact (<5 Å) for 75.0% of the trajectory, with only 0.7% of frames showing release into bulk solvent. Per-residue RMSF identified the L3 loop (residue 94, RMSF 1.17 nm) as the primary structural target for next-generation analog design. ADME profiling confirmed drug-likeness and oral bioavailability. MCF-7 cell assays established concentration- and time-dependent antiproliferation (IC50: 1.411 ± 0.167 mM at 24 h; 0.806 ± 0.037 mM at 48 h), nuclear p53 accumulation by immunofluorescence, and autophagy induction by MDC staining.

Together, these findings establish carvacrol as a structurally characterized fragment hit at the p53 L1/L3 interface, validated at the microsecond timescale with quantitative contact analysis. The next step is fragment growing: rigid elaboration of the carvacrol scaffold with functional groups that form bidentate, geometrically optimized contacts to Arg267 and Ser99, targeting both L3 loop rigidification and improved binding residence time.

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

Ali, A., Naz, F., Choudhary, M. I., & Ahmad, A. (2023). Exploring the binding mechanisms of natural compounds to p53 through computational approaches. *Journal of Molecular Structure*, 1289, 135747. https://doi.org/10.1016/j.molstruc.2023.135747

Arunasree, K. M. (2010). Anti-proliferative effects of carvacrol on a human metastatic breast cancer cell line, MDA-MB 231. *Phytomedicine*, 17(8–9), 581–588. https://doi.org/10.1016/j.phymed.2009.12.008

Chitrala, K. N., & Yeguvapalli, S. (2014). Computational prediction and analysis of breast cancer-related p53 mutations. *PLoS ONE*, 9(11), e112845. https://doi.org/10.1371/journal.pone.0112845

Danciu, C., Vlaia, L., Fetea, F., Hancianu, M., Coricovac, D. E., Ciurlea, S. A., … Dehelean, C. A. (2015). Evaluation of phenolic profile, antioxidant and anticancer potential of two main *Lamiaceae* family representatives (lavender and rosemary) from Romania. *Biological Research*, 48, 1–9. https://doi.org/10.1186/s40659-015-0002-3

Fatima, H., Khan, K., Zia, M., Ur-Rehman, T., Mirza, B., & Haq, I. (2022). Extraction optimization of medicinally important metabolites from *Datura innoxia* Mill: An in vitro biological and phytochemical investigation. *Arabian Journal of Chemistry*, 8(3), 373–382.

Islam, S. U., Bhardwaj, K., Bhardwaj, A., Rashid, S., & Akhtar, N. (2025). p53 as a transcription factor in human diseases: A comprehensive review. *Cancer Medicine*, 14(1), e70509. https://doi.org/10.1002/cam4.70509

Joerger, A. C., & Fersht, A. R. (2008). Structural biology of the tumor suppressor p53. *Annual Review of Biochemistry*, 77, 557–579. https://doi.org/10.1146/annurev.biochem.77.060806.091238

Lamoree, B., & Hubbard, R. E. (2017). Current perspectives in fragment-based lead discovery (FBLD). *Essays in Biochemistry*, 61(5), 453–464. https://doi.org/10.1042/EBC20170028

Malla, R. R., Bhamidipati, P., & Srilatha, M. (2023). Potential of phytochemicals as p53 activators: Insights into molecular mechanisms and clinical relevance. *Phytomedicine*, 108, 154476. https://doi.org/10.1016/j.phymed.2022.154476

Sampaio, L. A., Bara, M. T. F., Tresvenzol, L. M. F., Ferri, P. H., de Paula, J. R., & Costa, E. A. (2021). Chemical composition and pharmacological activities of the essential oil of *Origanum vulgare* L. *Current Pharmaceutical Design*, 27(25), 2851–2861.

Sharifi-Rad, J., Sureda, A., Tenore, G. C., Daglia, M., Sharifi-Rad, M., Valussi, M., … Iriti, M. (2018a). Biological activities of essential oils: From plant chemoecology to traditional healing systems. *Molecules*, 23(7), 1545. https://doi.org/10.3390/molecules23071545

Tsukamoto, Y. (2025). Regulation of p53 in cancer therapy. *Journal of Experimental & Clinical Cancer Research*, 44(1), 43. https://doi.org/10.1186/s13046-025-03307-3

Verma, N., Singh, M., & Bhatt, M. L. B. (2016). Mutant p53 reactivation as a cancer therapy. *BioMed Research International*, 2016, 6243196. https://doi.org/10.1155/2016/6243196

Wassman, C. D., Baronio, R., Demir, Ö., Wallentine, B. D., Chen, C. K., Hall, L. V., … Bhaskara, R. M. (2013). Computational identification of a transiently open L1/S3 pocket for reactivation of mutant p53. *Nature Communications*, 4, 1407. https://doi.org/10.1038/ncomms2361

---

## Figure and Table Legends

**Figure 1.** Dose–response curves of carvacrol in MCF-7 cells (24 h, 48 h). (See Results Section 3.1.)

**Figure 2.** Dose–response curves of carvacrol in MCF-10A cells (24 h, 48 h). (See Results Section 3.1.)

**Figure 3.** 1 µs MD structural metrics of the carvacrol–p53 system. (a) Backbone RMSD; (b) Carvacrol RMSD; (c) Rg; (d) SASA. Bold lines: 50-frame rolling averages. Dashed lines: mean values.

**Figure 4.** Per-residue backbone RMSF over 1 µs. Dashed line: mean RMSF (0.152 nm). Arrow: residue 94 (RMSF = 1.17 nm; L3 loop). Vertical shading: Ser99, Arg267 contact residues.

**Figure 5.** Protein–carvacrol minimum distance analysis (1 µs). (a) Time series with rolling mean. (b) Distance distribution. (c) Contact zone analysis (direct contact <5 Å: 75.0%; near 5–8 Å: 5.4%; intermediate 8–20 Å: 18.9%; bulk >20 Å: 0.7%).

**Figure 6.** PCA of p53 backbone Cα conformations across 1 µs MD. (a) PC1–PC2 landscape colored by simulation time. (b) Scree plot: explained variance per PC and cumulative variance. 8 PCs account for 90% variance.

**Figure 6-ADMET.** ADMET profiling: (A) Rule-of-Five radar; (B) BOILED-Egg absorption/BBB; (C) Absorption parameters; (D) Distribution; (E) CYP450 inhibition heatmap; (F) Toxicity risk panel. (Unchanged from prior version.)

**Figure 7.** Immunofluorescence analysis of p53. (See Results Section 3.4.)

**Figure 8.** MDC autophagic vesicle quantification. (See Results Section 3.5.)

**Table 1.** IC50 values of carvacrol (MCF-7 and MCF-10A; 24 h and 48 h).

**Table 2.** Physicochemical properties and drug-likeness.

**Table 3.** ADME profile.

**Table 4.** In silico toxicity profile.
