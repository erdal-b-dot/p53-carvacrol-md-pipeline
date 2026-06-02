#!/bin/bash
# ══════════════════════════════════════════════════════════════════════
#  ADIM 3 — AutoDock Vina Docking: 1TSR ← Karvakrol
#  - Meeko ile receptor + ligand PDBQT hazırlama
#  - Tüm protein yüzeyini kapsayan kör docking (blind docking)
#  - En iyi poz seçimi ve PDB olarak kaydetme
#  Ortam: mol-sim (meeko 0.7.1 + vina 1.2.6)
# ══════════════════════════════════════════════════════════════════════
set -e
cd "$(dirname "$0")"

MOL_SIM_ENV="mol-sim"
PROTEIN_PDB="../01_protein_prep/1TSR_protein.pdb"
LIGAND_SDF="/Users/erdalbalcan/carvacrol.sdf"

if [ ! -f "$PROTEIN_PDB" ]; then
    echo "HATA: $PROTEIN_PDB bulunamadı! Önce 01_protein_prep/prepare_protein.sh çalıştırın."
    exit 1
fi

cp "$PROTEIN_PDB" receptor_clean.pdb

# ── Box merkezi ve boyutunu hesapla ─────────────────────────────────
echo ">>> Grid box parametreleri hesaplanıyor..."
python3 - <<'PYEOF'
import numpy as np

coords = []
with open("receptor_clean.pdb") as f:
    for line in f:
        if line[:4] in ("ATOM", "HEAT"):
            try:
                x = float(line[30:38])
                y = float(line[38:46])
                z = float(line[46:54])
                coords.append([x, y, z])
            except:
                pass

coords = np.array(coords)
center = coords.mean(axis=0)
span = coords.max(axis=0) - coords.min(axis=0)
# Kör docking için protein boyutuna 10 Å ekle
box_size = span + 20.0

print(f"Protein merkezi:  x={center[0]:.2f}  y={center[1]:.2f}  z={center[2]:.2f}")
print(f"Protein boyutu:   {span[0]:.1f} x {span[1]:.1f} x {span[2]:.1f} Å")
print(f"Box boyutu:       {box_size[0]:.1f} x {box_size[1]:.1f} x {box_size[2]:.1f} Å")

# vina_config.txt yaz
with open("vina_config.txt", "w") as f:
    f.write(f"center_x = {center[0]:.3f}\n")
    f.write(f"center_y = {center[1]:.3f}\n")
    f.write(f"center_z = {center[2]:.3f}\n")
    f.write(f"size_x   = {min(box_size[0], 126):.1f}\n")
    f.write(f"size_y   = {min(box_size[1], 126):.1f}\n")
    f.write(f"size_z   = {min(box_size[2], 126):.1f}\n")
    f.write(f"\nexhaustiveness = 32\n")
    f.write(f"num_modes      = 10\n")
    f.write(f"energy_range   = 3\n")
    f.write(f"cpu            = 4\n")
    f.write(f"seed           = 42\n")
print("vina_config.txt oluşturuldu.")
PYEOF

echo ""
cat vina_config.txt

# ── Receptor PDBQT ───────────────────────────────────────────────────
echo ""
echo ">>> Receptor PDBQT hazırlanıyor (Meeko)..."
conda run -n ${MOL_SIM_ENV} mk_prepare_receptor.py \
    -i receptor_clean.pdb \
    -o receptor.pdbqt \
    --skip_gpf \
    2>/dev/null \
|| {
    echo "  mk_prepare_receptor.py başarısız, obabel ile deneniyor..."
    obabel receptor_clean.pdb -O receptor.pdbqt -xr 2>/dev/null
}
echo "  receptor.pdbqt oluşturuldu."

# ── Ligand PDBQT ─────────────────────────────────────────────────────
echo ""
echo ">>> Karvakrol PDBQT hazırlanıyor (Meeko)..."
conda run -n ${MOL_SIM_ENV} mk_prepare_ligand.py \
    -i "$LIGAND_SDF" \
    -o carvacrol.pdbqt \
    2>/dev/null \
|| {
    echo "  mk_prepare_ligand.py başarısız, obabel ile deneniyor..."
    obabel "$LIGAND_SDF" -O carvacrol.pdbqt 2>/dev/null
}
echo "  carvacrol.pdbqt oluşturuldu."

# ── AutoDock Vina çalıştır ───────────────────────────────────────────
echo ""
echo ">>> AutoDock Vina çalıştırılıyor (exhaustiveness=32)..."
echo "    Bu işlem birkaç dakika sürebilir..."
conda run -n ${MOL_SIM_ENV} vina \
    --receptor receptor.pdbqt \
    --ligand   carvacrol.pdbqt \
    --config   vina_config.txt \
    --out      carvacrol_docked.pdbqt \
    --log      vina_log.txt

echo ""
echo "=== Docking Sonuçları ==="
grep "^   [0-9 ]" vina_log.txt || cat vina_log.txt | grep -A 20 "mode"

# ── En iyi pozu PDB olarak çıkar ────────────────────────────────────
echo ""
echo ">>> En iyi poz PDB olarak çıkarılıyor..."
python3 - <<'PYEOF'
best_pose = []
in_model1 = False
with open("carvacrol_docked.pdbqt") as f:
    for line in f:
        if line.startswith("MODEL        1"):
            in_model1 = True
        elif line.startswith("ENDMDL") and in_model1:
            break
        elif in_model1 and line[:6].strip() in ("ATOM", "HETATM"):
            # PDBQT → PDB (son 2 sütun çıkar)
            pdb_line = line[:66] + "\n"
            best_pose.append(pdb_line)

with open("carvacrol_best_pose.pdb", "w") as f:
    f.write("REMARK  Best docking pose - AutoDock Vina\n")
    f.write("REMARK  Ligand: Carvacrol (CID:10364) | Target: 1TSR (p53)\n")
    for line in best_pose:
        f.write(line)
    f.write("END\n")
print(f"carvacrol_best_pose.pdb oluşturuldu ({len(best_pose)} atom)")
PYEOF

# ── Protein + Ligand kompleksi ───────────────────────────────────────
echo ""
echo ">>> Protein-ligand kompleksi oluşturuluyor..."
python3 - <<'PYEOF'
with open("receptor_clean.pdb") as f:
    protein_lines = [l for l in f if l[:6].strip() in ("ATOM","TER") or l.startswith("HETATM")]

with open("carvacrol_best_pose.pdb") as f:
    lig_lines = [l for l in f if l[:6].strip() in ("ATOM","HETATM")]

# Ligand atom isimlerini HETATM olarak işaretle
lig_hetatm = []
for l in lig_lines:
    lig_hetatm.append("HETATM" + l[6:21] + "LIG A 999" + l[30:])

with open("1TSR_carvacrol_complex.pdb", "w") as f:
    f.write("REMARK  1TSR p53 + Carvacrol complex (docked)\n")
    for l in protein_lines:
        if not l.startswith("END"):
            f.write(l)
    f.write("TER\n")
    for l in lig_hetatm:
        f.write(l)
    f.write("END\n")
print("1TSR_carvacrol_complex.pdb oluşturuldu")
PYEOF

echo ""
echo ">>> TAMAMLANDI. Docking bitti."
echo ""
echo "=== Önemli Sonuçlar ==="
echo "  vina_log.txt                  → Tüm docking sonuçları (affinity kcal/mol)"
echo "  carvacrol_docked.pdbqt        → 10 docking pozu"
echo "  carvacrol_best_pose.pdb       → En iyi poz (GROMACS için)"
echo "  1TSR_carvacrol_complex.pdb    → Kompleks (görselleştirme için)"
echo ""
echo "  Sonraki adım: 04_gromacs_setup/setup_topology.sh"
