#!/usr/bin/env python3
"""
MDAnalysis PCA analysis of 1TSR/Carvacrol 1µs MD trajectory
Based on mdanalysis-trajectory skill
"""
import MDAnalysis as mda
from MDAnalysis.analysis import align, pca, rms
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')
import os
os.chdir('/Users/erdal/md_1tsr_carvacrol')

print(f"MDAnalysis {mda.__version__}")
print("Loading trajectory...")

# Load with topology (use .tpr)
# md.tpr has all atoms; md_center.xtc is PBC-corrected
try:
    u = mda.Universe('md.tpr', 'md_center.xtc')
    print(f"Atoms: {u.atoms.n_atoms}")
    print(f"Frames: {u.trajectory.n_frames}")

    # Select protein backbone Cα atoms
    ca_atoms = u.select_atoms("protein and name CA")
    protein_bb = u.select_atoms("backbone")
    print(f"Protein CA atoms: {ca_atoms.n_atoms}")
    print(f"Backbone atoms: {protein_bb.n_atoms}")

    # Use every 10th frame to keep memory manageable (10003 frames / 10 = ~1000)
    # PCA on backbone
    print("Aligning trajectory (every 10th frame)...")

    # Align trajectory to first frame backbone
    aligner = align.AlignTraj(u, u, select="protein and backbone",
                               in_memory=False)
    aligner.run(step=10)
    print("Alignment done.")

    # PCA
    print("Running PCA...")
    pc = pca.PCA(u, select="protein and name CA", n_components=10)
    pc.run(step=10, verbose=True)

    # Results
    variance = pc.results.variance
    total_var = variance.sum()
    cumvar = np.cumsum(variance) / total_var * 100

    print("\n═══ PCA Results ═══")
    for i in range(5):
        print(f"PC{i+1}: {variance[i]/total_var*100:.1f}% variance (cumulative: {cumvar[i]:.1f}%)")
    n_90 = np.searchsorted(cumvar, 90) + 1
    print(f"PCs for 90% variance: {n_90}")

    # Project trajectory onto PC1-PC2
    print("Projecting onto PC1-PC2...")
    transformed = pc.transform(ca_atoms, n_components=2)

    # Time vector (every 10th frame → step 100ps → 1ns per step, scaled to ns)
    n_frames = transformed.shape[0]
    times_ns = np.linspace(0, 1000, n_frames)

    # ── PCA landscape plot ─────────────────────────────────────────────────
    plt.rcParams.update({
        'font.family': 'Arial',
        'font.size': 10,
        'axes.linewidth': 1.0,
        'axes.spines.top': False,
        'axes.spines.right': False,
        'figure.dpi': 300,
    })

    fig, axes = plt.subplots(1, 2, figsize=(10, 4.5))

    # PC1-PC2 scatter colored by time
    sc = axes[0].scatter(transformed[:, 0], transformed[:, 1],
                         c=times_ns, cmap='viridis', s=4, alpha=0.6, linewidths=0)
    cbar = plt.colorbar(sc, ax=axes[0])
    cbar.set_label('Time (ns)', fontsize=9)
    axes[0].set_xlabel(f'PC1 ({variance[0]/total_var*100:.1f}% variance)', fontsize=10)
    axes[0].set_ylabel(f'PC2 ({variance[1]/total_var*100:.1f}% variance)', fontsize=10)
    axes[0].set_title('(A) Conformational Landscape (PC1–PC2)', fontsize=11,
                      fontweight='bold', loc='left')

    # Add start/end markers
    axes[0].plot(transformed[0, 0], transformed[0, 1], 'k^', ms=8,
                label='0 ns (start)', zorder=10)
    axes[0].plot(transformed[-1, 0], transformed[-1, 1], 'rs', ms=8,
                label='1000 ns (end)', zorder=10)
    axes[0].legend(fontsize=8, frameon=False)

    # Scree plot (explained variance)
    n_show = min(10, len(variance))
    pc_nums = range(1, n_show + 1)
    axes[1].bar(pc_nums, variance[:n_show] / total_var * 100,
                color='#0072B2', alpha=0.8, edgecolor='white')
    axes[1].plot(pc_nums, cumvar[:n_show], 'r-o', ms=5, lw=1.5, label='Cumulative')
    axes[1].axhline(90, color='gray', ls='--', lw=1, alpha=0.7, label='90% threshold')
    axes[1].set_xlabel('Principal Component', fontsize=10)
    axes[1].set_ylabel('Variance Explained (%)', fontsize=10)
    axes[1].set_title('(B) Scree Plot', fontsize=11, fontweight='bold', loc='left')
    axes[1].legend(fontsize=8, frameon=False)
    axes[1].set_xticks(list(pc_nums))

    fig.suptitle('PCA of p53 Backbone Conformations — 1 µs MD Simulation',
                 fontsize=12, fontweight='bold')
    plt.tight_layout()
    plt.savefig('fig6_pca.png', dpi=300, bbox_inches='tight', facecolor='white')
    plt.savefig('fig6_pca.pdf', bbox_inches='tight')
    plt.close()
    print("\nfig6_pca.png saved.")

    # Save PCA data for manuscript
    np.savetxt('pca_variance.txt',
               np.column_stack([list(range(1, n_show+1)),
                                variance[:n_show]/total_var*100,
                                cumvar[:n_show]]),
               header='PC  variance_pct  cumulative_pct',
               fmt=['%d', '%.2f', '%.2f'])

    print("\n═══ Summary for Manuscript ═══")
    print(f"PC1 variance: {variance[0]/total_var*100:.1f}%")
    print(f"PC2 variance: {variance[1]/total_var*100:.1f}%")
    print(f"PC1+PC2: {(variance[0]+variance[1])/total_var*100:.1f}%")
    print(f"PCs for 90% variance: {n_90}")

except Exception as e:
    print(f"ERROR: {e}")
    import traceback
    traceback.print_exc()
