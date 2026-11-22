# Revised end-state MM-GBSA (GB-Neck2, igb = 8)

This folder documents the **revised** MM-GBSA protocol used in the revised manuscript. It **supersedes**
the original-submission result in `../results/mmpbsa_final_results.txt` (gmx_MMPBSA v1.5.0.3, igb = 5,
100 frames, 298.15 K, ΔTOTAL = −3.61 kcal/mol), which is retained for provenance only.

## Revised protocol (from the manuscript Methods)

| Parameter | Value |
|-----------|-------|
| Method | MM-GBSA, end-state, single-trajectory |
| GB model | **GB-Neck2 (igb = 8)** |
| Radii set | mbondi3 |
| Frames | 199 frames, 5–995 ns, 5 ns interval |
| Temperature | 310 K |
| Salt concentration | 0.15 M |
| Receptor mask / decomposition | complete receptor (residues 94–289 + Zn²⁺; 197 units) |
| Reporting | qualitative, ensemble-level indicator only — **no Kd derived, no IC50 comparison** |

The corresponding gmx_MMPBSA input namelist matching this protocol is provided as
[`mmpbsa_revised.in`](./mmpbsa_revised.in).

## Per-replica ΔG_bind (manuscript Table 3)

| System | Contact occupancy (d ≤ 0.6 nm) | ΔG_bind (kcal/mol) |
|--------|-------------------------------|--------------------|
| Replica 1 | 74.9% | −6.13 ± 0.63 |
| Replica 2 | 77.4% | −7.26 ± 1.11 |
| Replica 3 | 87.9% | −13.56 ± 2.41 |
| **Mean** | **80.1%** | **−8.98 ± 4.00** (inter-replica SD) |

(SDs on individual replicas are block SEM; the mean SD is the inter-replica standard deviation.)
The roughly two-fold spread that tracks contact occupancy is itself the reason the manuscript treats
MM-GBSA qualitatively and derives no single affinity.

## PROVENANCE AND STATUS OF RAW FILES — read before citing

- The **numbers in the table above are transcribed from the revised manuscript (Table 3)**, which is the
  authoritative source; they are reproduced here for convenience, not re-derived in this repository.
- The **raw per-replica gmx_MMPBSA output files** for the revised (igb = 8) protocol are **not yet
  deposited in this repository.** If you have them (e.g. `FINAL_RESULTS_MMPBSA.dat` / `.csv` per
  replica, and the full run log), place them in this folder and update this README; that will make the
  archive fully self-contained for the revised MM-GBSA, matching the Data Availability statement.
- `mmpbsa_revised.in` is written to match the protocol described in the manuscript Methods. Verify it
  against the exact input used in the production run before relying on it, and replace it with the
  original if they differ.
