#!/usr/bin/env python3
"""
Create publication-quality mindist figure + run MDAnalysis PCA
Scientific visualization skill guidelines applied:
- Arial font, 300 DPI, proper axis labels, CVD-safe colors
- Single-column width (89mm = 3.5in) and double-column (183mm = 7.2in)
- Line charts for time series (correct chart type for temporal data)
"""
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from matplotlib.ticker import MultipleLocator
import warnings
warnings.filterwarnings('ignore')
import os
os.chdir('/Users/erdal/md_1tsr_carvacrol')

# ── global style (scientific-visualization skill: Arial, 300dpi, spines) ───
plt.rcParams.update({
    'font.family': 'Arial',
    'font.size': 10,
    'axes.linewidth': 1.0,
    'axes.spines.top': False,
    'axes.spines.right': False,
    'xtick.direction': 'out',
    'ytick.direction': 'out',
    'figure.dpi': 300,
    'lines.linewidth': 1.2,
})

# CVD-safe colors (Okabe-Ito palette)
BLUE   = '#0072B2'  # Okabe-Ito blue
RED    = '#D55E00'  # Okabe-Ito vermillion
GREEN  = '#009E73'  # Okabe-Ito green
ORANGE = '#E69F00'  # Okabe-Ito orange
PURPLE = '#CC79A7'  # Okabe-Ito pink/purple
GRAY   = '#888888'

def read_xvg(path):
    x, y = [], []
    with open(path) as fh:
        for line in fh:
            if line.startswith(('#', '@')): continue
            parts = line.split()
            if len(parts) >= 2:
                x.append(float(parts[0]))
                y.append(float(parts[1]))
    return np.array(x), np.array(y)

def rolling_mean(y, w=100):
    return np.convolve(y, np.ones(w) / w, mode='same')

# Load mindist data
t_md, mindist = read_xvg('mindist_prot_lig.xvg')
t_md = t_md / 1000  # ps -> ns
mindist = mindist * 10  # nm -> Å

# Statistics
mean_md = mindist.mean()
median_md = np.median(mindist)
frac_5  = (mindist < 5).sum() / len(mindist) * 100
frac_8  = (mindist < 8).sum() / len(mindist) * 100
frac_20 = (mindist > 20).sum() / len(mindist) * 100

print(f"Mindist stats:")
print(f"  Min: {mindist.min():.2f} Å  Max: {mindist.max():.2f} Å")
print(f"  Mean: {mean_md:.2f} Å  Median: {median_md:.2f} Å")
print(f"  <5Å: {frac_5:.1f}%  <8Å: {frac_8:.1f}%  >20Å: {frac_20:.1f}%")

# ── FIGURE 5: Protein–Ligand Minimum Distance ─────────────────────────────
# Scientific-visualization: double-column width for combined panel (7.2 in)
fig = plt.figure(figsize=(7.2, 5.5))
gs = gridspec.GridSpec(2, 2, height_ratios=[2, 1], hspace=0.45, wspace=0.38)

ax_time  = fig.add_subplot(gs[0, :])   # top: time series (full width)
ax_hist  = fig.add_subplot(gs[1, 0])   # bottom left: histogram
ax_pie   = fig.add_subplot(gs[1, 1])   # bottom right: contact zone pie

# ── TOP: Time series ──────────────────────────────────────────────────────
ax_time.plot(t_md, mindist, color=BLUE, alpha=0.2, lw=0.4, zorder=1)
rm = rolling_mean(mindist, w=200)
ax_time.plot(t_md, rm, color=BLUE, lw=1.8, zorder=2, label='100-frame rolling mean')

# Threshold bands
ax_time.axhline(5.0, color=GREEN, ls='--', lw=1.0, alpha=0.8, label='5 Å contact threshold')
ax_time.axhline(8.0, color=ORANGE, ls=':', lw=1.0, alpha=0.8, label='8 Å proximity threshold')

# Shade contact zone
ax_time.fill_between(t_md, 0, np.minimum(mindist, 5.0),
                     where=(mindist < 5.0), color=GREEN, alpha=0.08, zorder=0)

ax_time.set_xlabel('Time (ns)', fontsize=10)
ax_time.set_ylabel('Min. Distance (Å)', fontsize=10)
ax_time.set_title('(A) Protein–Carvacrol Minimum Distance — 1 µs MD',
                  fontsize=11, fontweight='bold', loc='left')
ax_time.set_ylim(-0.5, 28)
ax_time.set_xlim(0, 1000)
ax_time.yaxis.set_minor_locator(MultipleLocator(2.5))
ax_time.legend(fontsize=8, frameon=False, loc='upper right')
ax_time.text(0.02, 0.92, f'Mean = {mean_md:.2f} Å', transform=ax_time.transAxes,
             fontsize=9, color=BLUE, va='top')

# ── BOTTOM LEFT: Histogram ────────────────────────────────────────────────
bins = np.linspace(0, 28, 57)  # 0.5 Å bins
ax_hist.hist(mindist, bins=bins, color=BLUE, alpha=0.7, edgecolor='white', lw=0.3)
ax_hist.axvline(5.0, color=GREEN, ls='--', lw=1.2, alpha=0.9)
ax_hist.axvline(8.0, color=ORANGE, ls=':', lw=1.2, alpha=0.9)
ax_hist.axvline(mean_md, color=RED, ls='-', lw=1.0, alpha=0.8, label=f'Mean ({mean_md:.2f} Å)')
ax_hist.set_xlabel('Min. Distance (Å)', fontsize=9)
ax_hist.set_ylabel('Frame Count', fontsize=9)
ax_hist.set_title('(B) Distance Distribution', fontsize=10, fontweight='bold', loc='left')
ax_hist.legend(fontsize=7.5, frameon=False)
ax_hist.set_xlim(0, 28)

# ── BOTTOM RIGHT: Contact zone pie ───────────────────────────────────────
# Three zones: contact (<5Å), near (<8Å), intermediate (8–20Å), distant (>20Å)
near_5 = (mindist < 5).sum() / len(mindist) * 100
near_8_5 = ((mindist >= 5) & (mindist < 8)).sum() / len(mindist) * 100
mid = ((mindist >= 8) & (mindist <= 20)).sum() / len(mindist) * 100
dist = (mindist > 20).sum() / len(mindist) * 100

# Use bar chart (scientific-visualization: bar for categorical proportions)
zones = ['<5 Å\n(Contact)', '5–8 Å\n(Near)', '8–20 Å\n(Distant)', '>20 Å\n(Bulk)']
fracs = [near_5, near_8_5, mid, dist]
colors_z = [GREEN, ORANGE, PURPLE, GRAY]

bars = ax_pie.bar(zones, fracs, color=colors_z, edgecolor='white', linewidth=0.8, alpha=0.85)
for bar, frac in zip(bars, fracs):
    ax_pie.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.8,
                f'{frac:.1f}%', ha='center', va='bottom', fontsize=8.5, fontweight='bold')

ax_pie.set_ylabel('Time Fraction (%)', fontsize=9)
ax_pie.set_title('(C) Contact Zone Analysis', fontsize=10, fontweight='bold', loc='left')
ax_pie.set_ylim(0, 90)
ax_pie.set_yticks([0, 20, 40, 60, 80])
ax_pie.tick_params(axis='x', labelsize=8)

plt.savefig('fig5_mindist.png', dpi=300, bbox_inches='tight', facecolor='white')
plt.savefig('fig5_mindist.pdf', bbox_inches='tight')
plt.close()
print("\nfig5_mindist.png saved.")

print(f"\nContact zone summary:")
print(f"  Direct contact (<5Å):  {near_5:.1f}% of simulation")
print(f"  Near surface (5–8Å):   {near_8_5:.1f}% of simulation")
print(f"  Intermediate (8–20Å):  {mid:.1f}% of simulation")
print(f"  Bulk solvent (>20Å):   {dist:.1f}% of simulation")
