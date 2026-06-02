#!/bin/bash
# ══════════════════════════════════════════════════════════════════════
#  ADIM 4 — GROMACS Topology Kurulumu (Yerel Makine)
#  - pdb2gmx ile protein topology (AMBER14SB)
#  - Ligand ITP entegrasyonu (GAFF2 / ACPYPE)
#  - Solvatasyon (TIP3P, dodecahedron, 1.2 nm)
#  - İyon ekleme (0.15 M NaCl, nötr yük)
#  - Enerji minimizasyonu (yerel)
#  - NVT + NPT denge (yerel, ~1 saat)
#
#  ⚠  PROPKA sonucuna göre aşağıdaki HIS_PROT değişkenini doldurun!
#  Ortam: mol-sim (GROMACS)
# ══════════════════════════════════════════════════════════════════════
set -e
cd "$(dirname "$0")"

MOL_SIM_ENV="mol-sim"
GMX="conda run -n ${MOL_SIM_ENV} gmx"

PROTEIN_PDB="../01_protein_prep/1TSR_chainA.pdb"  # Zincir A monomer (PROPKA analizi sonrası)
LIG_ITP="../02_ligand_prep/carvacrol.acpype/carvacrol_GMX.itp"
LIG_GRO="../02_ligand_prep/carvacrol.acpype/carvacrol_docked_GMX.gro"  # Docked koordinatlar (Kabsch süperpozisyon)
BEST_POSE="../03_docking/carvacrol_best_pose.pdb"
MDP_DIR="./mdp"

# ── Ön kontrol ──────────────────────────────────────────────────────
for f in "$PROTEIN_PDB" "$LIG_ITP" "$LIG_GRO" "$BEST_POSE"; do
    [ -f "$f" ] || { echo "HATA: $f bulunamadı!"; exit 1; }
done

# ══════════════════════════════════════════════════════════════════════
#  PROPKA3 SONUCU — Zincir A, pH 7.4 (2026-06-02)
#
#  Zincir A His residueleri (3 adet, sırayla):
#    His115: pKa=6.26 → HIE (1)  — yüzey, standart
#    His178: pKa=5.88 → HIE (1)  — ⚠ ZN koordinasyonu (Nδ–ZN, Nε–H korunur)
#    His233: pKa=5.95 → HIE (1)  — standart
#
#  CYM (ZN-koordine, deprotonlanmış Cys): 1TSR_chainA.pdb'de zaten CYM olarak işaretlendi
#    Cys176 → CYM | Cys238 → CYM | Cys242 → CYM
#  pdb2gmx AMBER14SB, CYM residüsünü otomatik tanır (-ignh ile H çıkarılır)
# ══════════════════════════════════════════════════════════════════════
HIS_PROT="$(cat <<'HIS_EOF'
1
1
1
HIS_EOF
)"

# ── ÇALIŞMA DİZİNİ ──────────────────────────────────────────────────
WORKDIR="./gromacs_run"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

cp "$LIG_ITP" .
cp "$LIG_GRO" .
LIG_ITP_BASE=$(basename "$LIG_ITP")
LIG_GRO_BASE=$(basename "$LIG_GRO")

# ── ADIM 1: pdb2gmx — Protein Topology ─────────────────────────────
echo ""
echo ">>> [1/9] pdb2gmx — AMBER14SB protein topology..."
echo "${HIS_PROT}" | ${GMX} pdb2gmx \
    -f "../../01_protein_prep/1TSR_chainA.pdb" \
    -o protein.gro \
    -p topol.top \
    -i posre.itp \
    -ff amber14sb \
    -water tip3p \
    -ignh \
    -his

echo "  protein.gro ve topol.top oluşturuldu."

# ── ADIM 2: Ligand topology'yi topol.top'a ekle ──────────────────────
echo ""
echo ">>> [2/9] Ligand ITP dosyası topology'ye ekleniyor..."
python3 - <<PYEOF
import re

with open("topol.top") as f:
    content = f.read()

# forcefield include'undan sonra ligand ITP ekle
itp_include = f'\n; Ligand (GAFF2)\n#include "{LIG_ITP_BASE}"\n'
content = re.sub(
    r'(#include "amber14sb\.ff/forcefield\.itp")',
    r'\1' + itp_include,
    content
)

# [ molecules ] bölümüne LIG ekle
if "LIG" not in content.split("[ molecules ]")[-1]:
    content = content.rstrip() + "\nLIG              1\n"

with open("topol.top", "w") as f:
    f.write(content)
print("  topol.top güncellendi (LIG dahil edildi)")
PYEOF

# ── ADIM 3: GRO dosyalarını birleştir (protein + ligand) ─────────────
echo ""
echo ">>> [3/9] Protein + Ligand GRO birleştiriliyor..."
python3 - <<'PYEOF'
with open("protein.gro") as f:  rec = f.readlines()
with open(LIG_GRO_BASE) as f:  lig = f.readlines()

rn = int(rec[1].strip())
ln = int(lig[1].strip())
out = [rec[0].replace(rec[0].strip(), "1TSR_carvacrol_complex"),
       f" {rn + ln}\n"] + rec[2:-1] + lig[2:-1] + [rec[-1]]

with open("complex.gro", "w") as f:
    f.writelines(out)
print(f"  complex.gro: {rn + ln} atom (protein:{rn} + ligand:{ln})")
PYEOF

# ── ADIM 4: Ligand pozisyon kısıtlama dosyası ────────────────────────
echo ""
echo ">>> [4/9] Ligand pozisyon kısıtlamaları (posre_LIG.itp)..."
${GMX} make_ndx -f "$LIG_GRO_BASE" -o lig_ndx.ndx <<'EOF'
0 & ! a H*
q
EOF
# Ağır atomlar (H dışı) üzerinde kısıtlama
${GMX} genrestr -f "$LIG_GRO_BASE" -n lig_ndx.ndx -o posre_LIG.itp \
    -fc 1000 1000 1000 <<'EOF'
0
EOF

# topol.top'a POSRES_LIG ekle
python3 - <<'PYEOF'
with open("topol.top") as f:
    content = f.read()
posres_block = '''
; Ligand pozisyon kısıtlamaları (NPT/NVT için)
#ifdef POSRES_LIG
#include "posre_LIG.itp"
#endif
'''
# LIG include'undan sonra ekle
itp_line = '#include "carvacrol_GMX.itp"'
if posres_block not in content:
    content = content.replace(itp_line, itp_line + posres_block)
with open("topol.top", "w") as f:
    f.write(content)
print("  posre_LIG.itp hazırlandı ve topol.top'a eklendi")
PYEOF

# ── ADIM 5: Kutu tanımla (dodecahedron) ─────────────────────────────
echo ""
echo ">>> [5/9] Kutu tanımlanıyor (dodecahedron, 1.2 nm)..."
${GMX} editconf \
    -f complex.gro \
    -o complex_box.gro \
    -c -d 1.2 -bt dodecahedron
echo "  Kutu bilgisi:"
tail -1 complex_box.gro

# ── ADIM 6: Solvatasyon (TIP3P) ──────────────────────────────────────
echo ""
echo ">>> [6/9] Solvatasyon (TIP3P)..."
${GMX} solvate \
    -cp complex_box.gro \
    -cs spc216.gro \
    -o complex_solv.gro \
    -p topol.top
echo "  Su molekülü sayısı:"
grep "SOL" topol.top | tail -1

# ── ADIM 7: İyon ekleme (0.15 M NaCl, nötr) ──────────────────────────
echo ""
echo ">>> [7/9] İyon ekleme (0.15 M NaCl)..."
${GMX} grompp \
    -f ${MDP_DIR}/ions.mdp \
    -c complex_solv.gro \
    -p topol.top \
    -o ions.tpr \
    -maxwarn 2

echo "13" | ${GMX} genion \
    -s ions.tpr \
    -o complex_ions.gro \
    -p topol.top \
    -pname NA \
    -nname CL \
    -neutral \
    -conc 0.15
echo "  İyon eklendi."

# ── ADIM 8: Index dosyası oluştur ────────────────────────────────────
echo ""
echo ">>> [8/9] GROMACS index dosyası hazırlanıyor..."
${GMX} make_ndx -f complex_ions.gro -o index.ndx <<'EOF'
1 | 13
name 19 Protein_LIG
q
EOF
# NOT: Grup numaraları sistemin büyüklüğüne göre değişebilir.
# Hata alırsanız önce gmx make_ndx çalıştırıp mevcut grupları görün.
echo "  index.ndx oluşturuldu."

# ── ADIM 9: Enerji Minimizasyonu ─────────────────────────────────────
echo ""
echo ">>> [9/9] Enerji minimizasyonu..."
${GMX} grompp \
    -f ${MDP_DIR}/minim.mdp \
    -c complex_ions.gro \
    -p topol.top \
    -n index.ndx \
    -o em.tpr \
    -maxwarn 2

${GMX} mdrun \
    -v -deffnm em \
    -ntmpi 1 -ntomp $(nproc)

echo ""
echo "=== EM Tamamlandı ==="
${GMX} energy -f em.edr -o em_potential.xvg <<'EOF'
10
0
EOF
echo "  em_potential.xvg: enerji profili"

# ── NVT Dengesi ───────────────────────────────────────────────────────
echo ""
echo ">>> NVT dengesi (100 ps, 310 K)..."
echo "1" | ${GMX} genrestr -f em.gro -n index.ndx -o posre.itp \
    -fc 1000 1000 1000
${GMX} grompp \
    -f ${MDP_DIR}/nvt.mdp \
    -c em.gro \
    -r em.gro \
    -p topol.top \
    -n index.ndx \
    -o nvt.tpr \
    -maxwarn 2
${GMX} mdrun -v -deffnm nvt -ntmpi 1 -ntomp $(nproc)

# ── NPT Dengesi ───────────────────────────────────────────────────────
echo ""
echo ">>> NPT dengesi (1 ns, 310 K / 1 bar)..."
${GMX} grompp \
    -f ${MDP_DIR}/npt.mdp \
    -c nvt.gro \
    -r nvt.gro \
    -t nvt.cpt \
    -p topol.top \
    -n index.ndx \
    -o npt.tpr \
    -maxwarn 2
${GMX} mdrun -v -deffnm npt -ntmpi 1 -ntomp $(nproc)

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  YEREL HAZIRLIK TAMAMLANDI                               ║"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║  TRUBA'ya gönderilecek dosyalar (gromacs_run/ dizini):   ║"
echo "║    npt.gro        → başlangıç koordinatı                 ║"
echo "║    npt.cpt        → checkpoint (hız bilgisi)             ║"
echo "║    topol.top      → topology                             ║"
echo "║    *.itp          → topology ek dosyaları                ║"
echo "║    index.ndx      → index dosyası                        ║"
echo "║    mdp/md_1us.mdp → üretim MD parametreleri              ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  Sonraki adım: 05_truba/slurm_1us.sh → TRUBA'ya sbatch"
