import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from matplotlib.ticker import MultipleLocator
import warnings
warnings.filterwarnings('ignore')

# ── xvg reader ──────────────────────────────────────────────────────────────
def read_xvg(path):
    x, y = [], []
    with open(path) as fh:
        for line in fh:
            if line.startswith(('#', '@')):
                continue
            parts = line.split()
            if len(parts) >= 2:
                x.append(float(parts[0]))
                y.append(float(parts[1]))
    return np.array(x), np.array(y)

def read_xvg_multi(path):
    """Multi-column xvg (gyrate: time, Rg, Rgx, Rgy, Rgz)."""
    rows = []
    with open(path) as fh:
        for line in fh:
            if line.startswith(('#', '@')):
                continue
            parts = line.split()
            if parts:
                rows.append([float(v) for v in parts])
    data = np.array(rows)
    return data

# ── rolling average ──────────────────────────────────────────────────────────
def rolling_mean(y, w=50):
    return np.convolve(y, np.ones(w) / w, mode='same')

# ── global style ─────────────────────────────────────────────────────────────
plt.rcParams.update({
    'font.family': 'Arial',
    'font.size': 11,
    'axes.linewidth': 1.2,
    'axes.spines.top': False,
    'axes.spines.right': False,
    'xtick.direction': 'out',
    'ytick.direction': 'out',
    'figure.dpi': 300,
})

BLUE   = '#2166AC'
RED    = '#D6604D'
GREEN  = '#4DAC26'
ORANGE = '#F4A582'
GRAY   = '#888888'

# ── load data ────────────────────────────────────────────────────────────────
t_bb,  rmsd_bb  = read_xvg('rmsd_backbone.xvg')    # ns
t_lig, rmsd_lig = read_xvg('rmsd_ligand.xvg')       # ns

t_rmsf, rmsf   = read_xvg('rmsf_backbone.xvg')

gyrate_data    = read_xvg_multi('gyrate.xvg')
t_rg = gyrate_data[:, 0] / 1000  # ps → ns
rg   = gyrate_data[:, 1] * 10    # nm → Å

t_sasa, sasa   = read_xvg('sasa.xvg')
t_sasa = t_sasa / 1000           # ps → ns
sasa  = sasa * 100               # nm² → Å²

rmsd_bb  *= 10   # nm → Å
rmsd_lig *= 10   # nm → Å
rmsf     *= 10   # nm → Å

# ── FIGURE 1: RMSD (backbone + ligand) ───────────────────────────────────────
fig, axes = plt.subplots(2, 1, figsize=(8, 6), sharex=True)
fig.suptitle('1TSR / Carvacrol — 1 μs MD Simulation', fontsize=13, fontweight='bold', y=1.01)

ax1, ax2 = axes

# backbone
ax1.plot(t_bb, rmsd_bb, color=BLUE, alpha=0.3, lw=0.5)
ax1.plot(t_bb, rolling_mean(rmsd_bb), color=BLUE, lw=1.8, label='Backbone RMSD')
ax1.axhline(np.mean(rmsd_bb), color=BLUE, ls='--', lw=1, alpha=0.7,
            label=f'Mean = {np.mean(rmsd_bb):.2f} Å')
ax1.set_ylabel('RMSD (Å)', fontsize=11)
ax1.legend(fontsize=9, frameon=False)
ax1.set_ylim(bottom=0)
ax1.yaxis.set_minor_locator(MultipleLocator(0.5))

# ligand
ax2.plot(t_lig, rmsd_lig, color=RED, alpha=0.3, lw=0.5)
ax2.plot(t_lig, rolling_mean(rmsd_lig), color=RED, lw=1.8, label='Carvacrol RMSD')
ax2.axhline(np.mean(rmsd_lig), color=RED, ls='--', lw=1, alpha=0.7,
            label=f'Mean = {np.mean(rmsd_lig):.2f} Å')
ax2.set_ylabel('RMSD (Å)', fontsize=11)
ax2.set_xlabel('Time (ns)', fontsize=11)
ax2.legend(fontsize=9, frameon=False)
ax2.set_ylim(bottom=0)
ax2.yaxis.set_minor_locator(MultipleLocator(0.5))

plt.tight_layout()
plt.savefig('fig1_rmsd.png', dpi=300, bbox_inches='tight')
plt.savefig('fig1_rmsd.pdf', bbox_inches='tight')
plt.close()
print("fig1_rmsd.png saved")

# ── FIGURE 2: RMSF ───────────────────────────────────────────────────────────
fig, ax = plt.subplots(figsize=(10, 4))
ax.plot(t_rmsf, rmsf, color=GREEN, lw=1.4)
ax.fill_between(t_rmsf, rmsf, alpha=0.15, color=GREEN)
ax.axhline(np.mean(rmsf), color='k', ls='--', lw=1, alpha=0.6,
           label=f'Mean RMSF = {np.mean(rmsf):.2f} Å')
ax.set_xlabel('Residue Number', fontsize=11)
ax.set_ylabel('RMSF (Å)', fontsize=11)
ax.set_title('Per-Residue Flexibility (Backbone) — 1 μs', fontsize=12, fontweight='bold')
ax.legend(fontsize=9, frameon=False)
ax.set_xlim(t_rmsf[0], t_rmsf[-1])
ax.set_ylim(bottom=0)
plt.tight_layout()
plt.savefig('fig2_rmsf.png', dpi=300, bbox_inches='tight')
plt.savefig('fig2_rmsf.pdf', bbox_inches='tight')
plt.close()
print("fig2_rmsf.png saved")

# ── FIGURE 3: Rg + SASA (panel) ──────────────────────────────────────────────
fig, (ax3, ax4) = plt.subplots(2, 1, figsize=(8, 6), sharex=True)

ax3.plot(t_rg, rg, color=ORANGE, alpha=0.3, lw=0.5)
ax3.plot(t_rg, rolling_mean(rg), color='#D6604D', lw=1.8, label='Radius of Gyration')
ax3.axhline(np.mean(rg), color='#D6604D', ls='--', lw=1, alpha=0.7,
            label=f'Mean = {np.mean(rg):.2f} Å')
ax3.set_ylabel('Rg (Å)', fontsize=11)
ax3.legend(fontsize=9, frameon=False)
ax3.set_ylim(np.mean(rg) - 3, np.mean(rg) + 3)

ax4.plot(t_sasa, sasa, color='#762A83', alpha=0.3, lw=0.5)
ax4.plot(t_sasa, rolling_mean(sasa), color='#762A83', lw=1.8, label='SASA')
ax4.axhline(np.mean(sasa), color='#762A83', ls='--', lw=1, alpha=0.7,
            label=f'Mean = {np.mean(sasa):.0f} Å²')
ax4.set_ylabel('SASA (Å²)', fontsize=11)
ax4.set_xlabel('Time (ns)', fontsize=11)
ax4.legend(fontsize=9, frameon=False)

fig.suptitle('1TSR Structural Properties — 1 μs MD', fontsize=13, fontweight='bold', y=1.01)
plt.tight_layout()
plt.savefig('fig3_rg_sasa.png', dpi=300, bbox_inches='tight')
plt.savefig('fig3_rg_sasa.pdf', bbox_inches='tight')
plt.close()
print("fig3_rg_sasa.png saved")

# ── FIGURE 4: Combined panel (publication) ───────────────────────────────────
fig = plt.figure(figsize=(14, 10))
gs = gridspec.GridSpec(2, 2, hspace=0.45, wspace=0.35)

ax_rmsd_bb  = fig.add_subplot(gs[0, 0])
ax_rmsd_lig = fig.add_subplot(gs[0, 1])
ax_rmsf     = fig.add_subplot(gs[1, :])

# Backbone RMSD
ax_rmsd_bb.plot(t_bb, rmsd_bb, color=BLUE, alpha=0.25, lw=0.5)
ax_rmsd_bb.plot(t_bb, rolling_mean(rmsd_bb), color=BLUE, lw=1.8)
ax_rmsd_bb.axhline(np.mean(rmsd_bb), color=BLUE, ls='--', lw=1, alpha=0.7)
ax_rmsd_bb.set_xlabel('Time (ns)', fontsize=10)
ax_rmsd_bb.set_ylabel('RMSD (Å)', fontsize=10)
ax_rmsd_bb.set_title('(A) Backbone RMSD', fontsize=11, fontweight='bold', loc='left')
ax_rmsd_bb.set_ylim(bottom=0)
ax_rmsd_bb.text(0.97, 0.95, f'Mean: {np.mean(rmsd_bb):.2f} Å',
                transform=ax_rmsd_bb.transAxes, ha='right', va='top',
                fontsize=9, color=BLUE)

# Ligand RMSD
ax_rmsd_lig.plot(t_lig, rmsd_lig, color=RED, alpha=0.25, lw=0.5)
ax_rmsd_lig.plot(t_lig, rolling_mean(rmsd_lig), color=RED, lw=1.8)
ax_rmsd_lig.axhline(np.mean(rmsd_lig), color=RED, ls='--', lw=1, alpha=0.7)
ax_rmsd_lig.set_xlabel('Time (ns)', fontsize=10)
ax_rmsd_lig.set_ylabel('RMSD (Å)', fontsize=10)
ax_rmsd_lig.set_title('(B) Carvacrol RMSD', fontsize=11, fontweight='bold', loc='left')
ax_rmsd_lig.set_ylim(bottom=0)
ax_rmsd_lig.text(0.97, 0.95, f'Mean: {np.mean(rmsd_lig):.2f} Å',
                 transform=ax_rmsd_lig.transAxes, ha='right', va='top',
                 fontsize=9, color=RED)

# RMSF
ax_rmsf.plot(t_rmsf, rmsf, color=GREEN, lw=1.4)
ax_rmsf.fill_between(t_rmsf, rmsf, alpha=0.15, color=GREEN)
ax_rmsf.axhline(np.mean(rmsf), color='k', ls='--', lw=1, alpha=0.5)
ax_rmsf.set_xlabel('Residue Number', fontsize=10)
ax_rmsf.set_ylabel('RMSF (Å)', fontsize=10)
ax_rmsf.set_title('(C) Per-Residue Flexibility', fontsize=11, fontweight='bold', loc='left')
ax_rmsf.set_xlim(t_rmsf[0], t_rmsf[-1])
ax_rmsf.set_ylim(bottom=0)

fig.suptitle('1TSR (p53 Core Domain) / Carvacrol — 1 μs MD Simulation',
             fontsize=13, fontweight='bold')
plt.savefig('fig4_combined.png', dpi=300, bbox_inches='tight')
plt.savefig('fig4_combined.pdf', bbox_inches='tight')
plt.close()
print("fig4_combined.png saved")

# ── summary stats ────────────────────────────────────────────────────────────
print("\n══ MD ANALYSIS SUMMARY ══")
print(f"Backbone RMSD  — mean: {np.mean(rmsd_bb):.3f} Å  std: {np.std(rmsd_bb):.3f} Å  max: {np.max(rmsd_bb):.3f} Å")
print(f"Carvacrol RMSD — mean: {np.mean(rmsd_lig):.3f} Å  std: {np.std(rmsd_lig):.3f} Å  max: {np.max(rmsd_lig):.3f} Å")
print(f"RMSF           — mean: {np.mean(rmsf):.3f} Å  max: {np.max(rmsf):.3f} Å  (res {t_rmsf[np.argmax(rmsf)]:.0f})")
print(f"Rg             — mean: {np.mean(rg):.3f} Å  std: {np.std(rg):.3f} Å")
print(f"SASA           — mean: {np.mean(sasa):.1f} Å²  std: {np.std(sasa):.1f} Å²")
