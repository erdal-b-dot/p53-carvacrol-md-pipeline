#!/bin/bash
# ══════════════════════════════════════════════════════════════════════
#  ADIM 2 — Karvakrol Hazırlama (PubChem CID:10364)
#  - SDF → MOL2 (obabel)
#  - GAFF2 atom tipleri + AM1-BCC yükleri (ACPYPE)
#  - Çıktı: carvacrol.acpype/  (GROMACS .itp + .gro dosyaları)
#  Ortam: mol-sim (GROMACS + ACPYPE)
# ══════════════════════════════════════════════════════════════════════
set -e
cd "$(dirname "$0")"

MOL_SIM_ENV="mol-sim"

# ── ACPYPE kurulumu (ilk çalıştırmada) ──────────────────────────────
echo ">>> ACPYPE kontrol ediliyor..."
if ! conda run -n ${MOL_SIM_ENV} python -c "import acpype" 2>/dev/null; then
    echo "    ACPYPE bulunamadı, kuruluyor..."
    conda run -n ${MOL_SIM_ENV} pip install acpype --quiet
    echo "    ACPYPE kuruldu."
fi

# ── Karvakrol SDF'yi kopyala ─────────────────────────────────────────
SDF_SOURCE="/Users/erdalbalcan/carvacrol.sdf"
if [ ! -f "$SDF_SOURCE" ]; then
    echo ">>> carvacrol.sdf bulunamadı, PubChem'den indiriliyor..."
    curl -sf "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/10364/record/SDF/?record_type=3d" \
        -o carvacrol.sdf
else
    cp "$SDF_SOURCE" carvacrol.sdf
    echo ">>> carvacrol.sdf kopyalandı: $SDF_SOURCE"
fi

# ── SDF → MOL2 (3D geometri koru) ───────────────────────────────────
echo ">>> SDF → MOL2 dönüştürülüyor (obabel)..."
obabel carvacrol.sdf -O carvacrol.mol2 --gen3d best 2>/dev/null \
    || obabel carvacrol.sdf -O carvacrol.mol2 2>/dev/null

echo ""
echo "=== Karvakrol mol2 içeriği ==="
python3 - <<'PYEOF'
with open("carvacrol.mol2") as f:
    lines = f.readlines()
    for i, l in enumerate(lines[:30]):
        print(l, end="")
PYEOF

# ── ACPYPE: GAFF2 + AM1-BCC yükleri ─────────────────────────────────
echo ""
echo ">>> ACPYPE çalıştırılıyor (GAFF2, AM1-BCC, net yük = 0)..."
echo "    Bu işlem 5-15 dakika sürebilir..."
conda run -n ${MOL_SIM_ENV} acpype \
    -i carvacrol.mol2 \
    -c bcc \
    -a gaff2 \
    -n 0 \
    -b carvacrol

# ── Çıktıları kontrol et ─────────────────────────────────────────────
echo ""
echo "=== ACPYPE Çıktıları ==="
if [ -d "carvacrol.acpype" ]; then
    ls -lh carvacrol.acpype/
    echo ""
    echo "  Kritik dosyalar:"
    echo "    carvacrol.acpype/carvacrol_GMX.itp   → GROMACS topology"
    echo "    carvacrol.acpype/carvacrol_GMX.gro   → Koordinatlar"
    echo "    carvacrol.acpype/carvacrol_GMX.top   → Bağımsız top (referans)"
    echo ""

    # Atom sayısı ve yükü kontrol et
    python3 - <<'PYEOF2'
import re
itp_file = "carvacrol.acpype/carvacrol_GMX.itp"
with open(itp_file) as f:
    content = f.read()

# Toplam yük
charges = re.findall(r';\s+qtot\s+([\-\d\.]+)', content)
if charges:
    print(f"  Toplam yük kontrolü (son qtot): {charges[-1]}")

# Atom tiplerine bak
atoms_section = re.search(r'\[ atoms \](.*?)\[ bonds \]', content, re.DOTALL)
if atoms_section:
    atoms = [l for l in atoms_section.group(1).split('\n')
             if l.strip() and not l.strip().startswith(';')]
    print(f"  Toplam atom sayısı: {len(atoms)}")
PYEOF2

    # Rezidü adını LIG yap (GROMACS standardı)
    python3 - <<'PYEOF3'
import re
itp_path = "carvacrol.acpype/carvacrol_GMX.itp"
with open(itp_path) as f:
    content = f.read()

# Rezidü adını LIG olarak standardize et (genellikle MOL veya carvacrol olur)
content_new = re.sub(r'(\s+)\d+\s+(MOL|carvacrol|CAR|LIG)\s+',
                     lambda m: m.group(0).replace(m.group(2), 'LIG'),
                     content)
# [ moleculetype ] bölümünde de düzelt
content_new = re.sub(r'(\[ moleculetype \].*?\n\s*\n)\S+',
                     r'\g<1>LIG', content_new, flags=re.DOTALL)

# Basit yaklaşım: resname alanını LIG yap
lines = content.split('\n')
new_lines = []
in_atoms = False
for line in lines:
    if '[ atoms ]' in line:
        in_atoms = True
    elif line.startswith('[') and in_atoms:
        in_atoms = False
    if in_atoms and line.strip() and not line.strip().startswith(';'):
        parts = line.split()
        if len(parts) >= 4:
            parts[3] = 'LIG'
            line = '  '.join(parts)
    new_lines.append(line)
# moleculetype adını LIG yap
mol_lines = []
in_moltype = False
for line in new_lines:
    if '[ moleculetype ]' in line:
        in_moltype = True
        mol_lines.append(line)
        continue
    if in_moltype and line.strip() and not line.strip().startswith(';'):
        parts = line.split()
        if len(parts) >= 2:
            parts[0] = 'LIG'
            line = '   '.join(parts)
        in_moltype = False
    mol_lines.append(line)

with open(itp_path, 'w') as f:
    f.write('\n'.join(mol_lines))
print("  Rezidü adı 'LIG' olarak güncellendi")
PYEOF3
else
    echo "  HATA: carvacrol.acpype dizini oluşturulamadı!"
    echo "  Lütfen ACPYPE çıktısını ve AM1-BCC yük hesabını kontrol edin."
    exit 1
fi

echo ""
echo ">>> TAMAMLANDI. Karvakrol GAFF2 parametreleri hazır."
echo "    Sonraki adım: 03_docking/run_docking.sh"
