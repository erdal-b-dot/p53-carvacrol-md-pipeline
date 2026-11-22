# Reproducibility: three holo replicas + apo control

Processed MD analysis outputs supporting the manuscript's reproducibility section (three independent
1 µs holo replicas and one 1 µs ligand-free control). All files are the direct output of `gmx` analysis
tools (GROMACS 2024.1) on the production trajectories. **No value here is fabricated, modelled, or
upscaled.**

## How the replicas were produced

- **Replica 1** is the originally published trajectory (same one analysed in v1.0.0), re-analysed here
  with the same scripts so that all four systems are processed identically.
- **Replicas 2 and 3** differ from replica 1 **only** in the random seed used to generate initial
  velocities (`gen-vel`/`gen-seed` in the production `.mdp`); force fields, box, salt, thermostat,
  barostat, and 1 µs length are identical (see `../../04_gromacs_setup/` and `../../PIPELINE_SUMMARY.txt`).
- **apo** is the same p53 core domain simulated for 1 µs **without carvacrol**, under identical protein
  settings.

The analysis commands are the standard GROMACS tools used for replica 1 (documented in
`../scripts/`): `gmx rms` (backbone RMSD), `gmx rmsf -res` (per-residue RMSF), `gmx gyrate`
(radius of gyration), `gmx sasa` (SASA), `gmx mindist` (minimum protein–ligand distance and contact
count at 0.5 nm), `gmx hbond` / in-house tallying (H-bond occupancy, per-residue contact frequency),
and `gmx covar` + `gmx anaeig` (PCA). Each tool was applied identically to every system.

## File manifest

Per system `rep1`, `rep2`, `rep3` (holo) and `apo`:

| File pattern | Content |
|--------------|---------|
| `*_rmsd_bb.xvg` | Backbone RMSD vs time |
| `*_rmsd_lig.xvg` | Carvacrol heavy-atom RMSD vs time (holo only) |
| `*_rmsf.xvg` | Per-residue backbone RMSF |
| `*_gyrate.xvg` | Radius of gyration vs time |
| `*_sasa.xvg` | Solvent-accessible surface area vs time |
| `*_mindist.xvg` | Minimum protein–ligand distance vs time (holo only) |
| `*_numcont05.xvg` | Number of protein–ligand contacts < 0.5 nm vs time (holo only) |
| `*_pca2d.xvg` | PC1 vs PC2 projection (10,001 frames) |
| `*_eigenval.xvg` | PCA eigenvalues (10,001 frames, 100 ps interval) |
| `*_eigenval_1ns.xvg` | PCA eigenvalues (1,001 frames, 1 ns interval) |
| `*_hbond_occ.dat` | Per-residue H-bond occupancy (holo only) |
| `*_resfreq.dat` | Per-residue carvacrol contact frequency, % (holo only) |

Summary and figures:

- `replika_ozet.csv` — cross-system summary (structural stability, carvacrol surface behaviour, PCA).
- `replika_karsilastirma.png` — replica comparison figure (source for the manuscript reproducibility figure).
- `temas_frekansi_karsilastirma.png` — per-residue contact-frequency comparison (source for the
  supplementary per-residue figure).

## Two points a careful reader should note (both disclosed in the manuscript)

1. **Two different contact-occupancy definitions.** `replika_ozet.csv` reports *full-trajectory* contact
   occupancy (all 10,001 frames) at both 0.5 nm and 0.6 nm cut-offs. The manuscript's Table 3 column
   "Contact occupancy (d ≤ 0.6 nm)" instead reports occupancy over the **199-frame MM-GBSA ensemble**
   (5–995 ns, 5 ns interval). Because the two use different frame sets, the percentages differ slightly
   (e.g. for replica 1, ≈ 77% full-trajectory vs 74.9% over the MM-GBSA frames). Both are correct for
   their respective frame sets; they are not meant to be identical.

2. **PCA depends on frame count (sampling).** The `*_eigenval.xvg` / `*_pca2d.xvg` files use the full
   10,001-frame trajectories and give, for replica 1, PC1 ≈ 30% with ~30 PCs needed for 90% of the
   variance. The manuscript's Figure 8 reports the published replica-1 PCA computed on the coarser
   1,001-frame set (`*_eigenval_1ns.xvg`), giving PC1 ≈ 18% and 8 PCs for 90%. This frame-count /
   sampling dependence is exactly the point discussed in the manuscript (PCA convergence vs sampling
   ambiguity). Both resolutions are provided here so the effect is fully transparent.

## Not included here

The end-state MM-GBSA ΔG_bind values per replica are **not** in this folder; the revised MM-GBSA
protocol and the per-replica summary (manuscript Table 3) are documented in `../mmgbsa_revised/`.
