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
# conda run stdin iletmiyor — doğrudan binary yolu kullan
CONDA_MOL_SIM="$(conda info --base 2>/dev/null)/envs/${MOL_SIM_ENV}"
export PATH="${CONDA_MOL_SIM}/bin.AVX2_256:${CONDA_MOL_SIM}/bin:$PATH"
export LD_LIBRARY_PATH="${CONDA_MOL_SIM}/lib:${LD_LIBRARY_PATH:-}"
GMX="${CONDA_MOL_SIM}/bin.AVX2_256/gmx"
[ -f "$GMX" ] || GMX="${CONDA_MOL_SIM}/bin/gmx"

# Mutlak yollar — gromacs_run/ alt dizinine cd sonrası da geçerli
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

PROTEIN_PDB="${PROJECT_DIR}/01_protein_prep/1TSR_chainA_H.pdb"  # HIS→HIE pre-renamed
LIG_ITP="${PROJECT_DIR}/02_ligand_prep/carvacrol.acpype/carvacrol_GMX.itp"
LIG_GRO="${PROJECT_DIR}/02_ligand_prep/carvacrol.acpype/carvacrol_docked_GMX.gro"
BEST_POSE="${PROJECT_DIR}/03_docking/carvacrol_best_pose.pdb"
MDP_DIR="${SCRIPT_DIR}/mdp"

# ── Ön kontrol ──────────────────────────────────────────────────────
for f in "$PROTEIN_PDB" "$LIG_ITP" "$LIG_GRO" "$BEST_POSE"; do
    [ -f "$f" ] || { echo "HATA: $f bulunamadı!"; exit 1; }
done

# ══════════════════════════════════════════════════════════════════════
#  PROPKA3 SONUCU — Zincir A, pH 7.4 (2026-06-02)
#  Kristalografik ZN koordinasyonu doğrulandı (ND1–ZN: 2.00 Å)
#
#  Zincir A His residueleri (7 adet, PDB sırasıyla):
#    His115: pKa=6.26 → HIE (1)  — yüzey, standart
#    His168: pKa=4.81 → HIE (1)  — standart
#    His178: pKa=5.88 → HIE (1)  — standart
#    His179: pKa=4.04 → HIE (1)  — ⚠ ZN koordinasyonu: ND1–ZN=2.00 Å (Nδ koordine, Nε–H=HIE)
#    His193: pKa=5.18 → HIE (1)  — standart
#    His214: pKa=3.31 → HIE (1)  — standart
#    His233: pKa=5.95 → HIE (1)  — standart
#
#  CYM (ZN-koordine, deprotonlanmış Cys): 1TSR_chainA.pdb'de zaten CYM olarak işaretlendi
#    Cys176→CYM (SG–ZN:2.32Å) | Cys238→CYM (2.29Å) | Cys242→CYM (2.22Å)
# ══════════════════════════════════════════════════════════════════════
HIS_PROT="$(cat <<'HIS_EOF'
1
1
1
1
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
echo ">>> [1/9] pdb2gmx — AMBER99SB-ILDN protein topology..."
# HIS residueleri PDB'de zaten HIE olarak adlandırıldı → -his flag gerekmez
${GMX} pdb2gmx \
    -f "${PROTEIN_PDB}" \
    -o protein.gro \
    -p topol.top \
    -i posre.itp \
    -ff amber99sb-ildn \
    -water tip3p \
    -ignh

echo "  protein.gro ve topol.top oluşturuldu."

# ── ADIM 2: Ligand topology'yi topol.top'a ekle ──────────────────────
echo ""
echo ">>> [2/9] Ligand ITP dosyası topology'ye ekleniyor..."
python3 -c "
import re, sys
itp_base = sys.argv[1]
with open('topol.top') as f:
    content = f.read()
itp_include = '\n; Ligand (GAFF2)\n#include \"' + itp_base + '\"\n'
content = re.sub(
    r'(#include \"amber99sb-ildn\.ff/forcefield\.itp\")',
    r'\1' + itp_include,
    content
)
if 'LIG' not in content.split('[ molecules ]')[-1]:
    content = content.rstrip() + '\nLIG              1\n'
with open('topol.top', 'w') as f:
    f.write(content)
print('  topol.top güncellendi (LIG dahil edildi)')
" "$LIG_ITP_BASE"

# ── ADIM 3: GRO dosyalarını birleştir (protein + ligand) ─────────────
echo ""
echo ">>> [3/9] Protein + Ligand GRO birleştiriliyor..."
python3 -c "
import sys
lig_gro = sys.argv[1]
with open('protein.gro') as f:  rec = f.readlines()
with open(lig_gro) as f:  lig = f.readlines()

rn = int(rec[1].strip())
ln = int(lig[1].strip())
out = [rec[0].replace(rec[0].strip(), '1TSR_carvacrol_complex'),
       f' {rn + ln}\n'] + rec[2:-1] + lig[2:-1] + [rec[-1]]

with open('complex.gro', 'w') as f:
    f.writelines(out)
print(f'  complex.gro: {rn + ln} atom (protein:{rn} + ligand:{ln})')
" "$LIG_GRO_BASE"

# ── Yardımcı fonksiyon: stdin'i dosyaya yaz, komuta ilet, sil ────────
run_with_input() {
    # Kullanım: run_with_input "satır1\nsatır2" komut [argümanlar...]
    local input="$1"; shift
    local tmpf=$(mktemp /tmp/gmx_input.XXXXXX)
    printf "%b\n" "$input" > "$tmpf"
    "$@" < "$tmpf"
    rm -f "$tmpf"
}

# ── ADIM 4: Ligand pozisyon kısıtlama dosyası ────────────────────────
echo ""
echo ">>> [4/9] Ligand pozisyon kısıtlamaları (posre_LIG.itp)..."
run_with_input "0 & ! a H*\nq" \
    ${GMX} make_ndx -f "$LIG_GRO_BASE" -o lig_ndx.ndx
run_with_input "3" \
    ${GMX} genrestr -f "$LIG_GRO_BASE" -n lig_ndx.ndx -o posre_LIG.itp \
    -fc 1000 1000 1000

# topol.top'a POSRES_LIG ekle
python3 -c "
import sys
itp_base = sys.argv[1].replace('_docked_GMX', '_GMX')
with open('topol.top') as f:
    content = f.read()
posres_block = '\n; Ligand posre\n#ifdef POSRES_LIG\n#include \"posre_LIG.itp\"\n#endif\n'
itp_line = '#include \"' + itp_base + '\"'
if 'posre_LIG' not in content:
    content = content.replace(itp_line, itp_line + posres_block)
with open('topol.top', 'w') as f:
    f.write(content)
print('  posre_LIG.itp hazirlandı ve topol.top a eklendi')
" "$LIG_ITP_BASE"

# ── ADIM 5: Kutu tanımla (dodecahedron) ─────────────────────────────
echo ""
echo ">>> [5/9] Kutu tanımlanıyor (dodecahedron, 1.2 nm)..."
${GMX} editconf \
    -f complex.gro \
    -o complex_box.gro \
    -c -d 1.2 -bt dodecahedron
echo "  Kutu bilgisi:"; tail -1 complex_box.gro

# ── ADIM 6: Solvatasyon (TIP3P) ──────────────────────────────────────
echo ""
echo ">>> [6/9] Solvatasyon (TIP3P)..."
${GMX} solvate \
    -cp complex_box.gro -cs spc216.gro \
    -o complex_solv.gro -p topol.top
echo "  Su molekülü sayısı:"; grep "SOL" topol.top | tail -1

# ── ADIM 7: İyon ekleme (0.15 M NaCl, nötr) ──────────────────────────
echo ""
echo ">>> [7/9] İyon ekleme (0.15 M NaCl)..."
${GMX} grompp \
    -f ${MDP_DIR}/ions.mdp -c complex_solv.gro \
    -p topol.top -o ions.tpr -maxwarn 2

# SOL grubunu bul (genellikle "SOL" adlı, numarası değişebilir)
SOL_GROUP=$(run_with_input "q" ${GMX} make_ndx -f complex_solv.gro -o /dev/null 2>&1 \
    | grep -i "^\s*[0-9]* SOL" | awk '{print $1}' | head -1)
[ -z "$SOL_GROUP" ] && SOL_GROUP="13"
echo "  SOL grubu: $SOL_GROUP"
run_with_input "${SOL_GROUP}" \
    ${GMX} genion -s ions.tpr -o complex_ions.gro -p topol.top \
    -pname NA -nname CL -neutral -conc 0.15
echo "  İyon eklendi."

# ── ADIM 8: Index dosyası oluştur ────────────────────────────────────
echo ""
echo ">>> [8/9] GROMACS index dosyası hazırlanıyor..."
# Mevcut grupları listele, Protein ve LIG numaralarını bul
NDX_LIST=$(run_with_input "q" ${GMX} make_ndx -f complex_ions.gro -o /dev/null 2>&1)
PROT_GRP=$(echo "$NDX_LIST" | grep -E "^\s+[0-9]+ Protein " | awk '{print $1}' | head -1)
LIG_GRP=$(echo  "$NDX_LIST" | grep -E "^\s+[0-9]+ LIG"      | awk '{print $1}' | head -1)
[ -z "$PROT_GRP" ] && PROT_GRP="1"
[ -z "$LIG_GRP"  ] && LIG_GRP="13"
NEW_GRP=$(( $(echo "$NDX_LIST" | grep -E "^\s+[0-9]+" | tail -1 | awk '{print $1}') + 1 ))
echo "  Protein grubu: $PROT_GRP | LIG grubu: $LIG_GRP | Yeni grup: $NEW_GRP"
run_with_input "${PROT_GRP} | ${LIG_GRP}\nname ${NEW_GRP} Protein_LIG\nq" \
    ${GMX} make_ndx -f complex_ions.gro -o index.ndx
echo "  index.ndx oluşturuldu."

# ── CPU sayısı (macOS + Linux uyumlu) ────────────────────────────────
NCPU=$(sysctl -n hw.logicalcpu 2>/dev/null || nproc 2>/dev/null || echo 4)
echo "  Kullanılacak CPU: $NCPU"

# ── ADIM 9: Enerji Minimizasyonu ─────────────────────────────────────
echo ""
echo ">>> [9/9] Enerji minimizasyonu..."
${GMX} grompp \
    -f ${MDP_DIR}/minim.mdp -c complex_ions.gro \
    -p topol.top -n index.ndx -o em.tpr -maxwarn 2
${GMX} mdrun -v -deffnm em -ntmpi 1 -ntomp ${NCPU}

echo ""
echo "=== EM Tamamlandı ==="
run_with_input "10\n0" ${GMX} energy -f em.edr -o em_potential.xvg
echo "  em_potential.xvg: enerji profili"

# ── NVT Dengesi ───────────────────────────────────────────────────────
echo ""
echo ">>> NVT dengesi (100 ps, 310 K)..."
run_with_input "${PROT_GRP}" \
    ${GMX} genrestr -f em.gro -n index.ndx -o posre.itp -fc 1000 1000 1000
${GMX} grompp \
    -f ${MDP_DIR}/nvt.mdp -c em.gro -r em.gro \
    -p topol.top -n index.ndx -o nvt.tpr -maxwarn 2
${GMX} mdrun -v -deffnm nvt -ntmpi 1 -ntomp ${NCPU}

# ── NPT Dengesi ───────────────────────────────────────────────────────
echo ""
echo ">>> NPT dengesi (1 ns, 310 K / 1 bar)..."
${GMX} grompp \
    -f ${MDP_DIR}/npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt \
    -p topol.top -n index.ndx -o npt.tpr -maxwarn 2
${GMX} mdrun -v -deffnm npt -ntmpi 1 -ntomp ${NCPU}

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
