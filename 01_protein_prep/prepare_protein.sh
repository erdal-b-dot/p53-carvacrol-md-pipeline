#!/bin/bash
# ══════════════════════════════════════════════════════════════════════
#  ADIM 1 — Protein Hazırlama: 1TSR.pdb  (p53 core domain)
#  - DNA zincirlerini çıkar, ZN iyonunu koru
#  - PROPKA3 ile pH 7.4 protonasyon analizi
#  - pdb2gmx için PROPKA sonuçlarına dayalı -his argümanı oluştur
#  Ortam: conda run -n docking_env
# ══════════════════════════════════════════════════════════════════════
set -e
cd "$(dirname "$0")"

DOCKING_ENV="docking_env"
PDB_ID="1TSR"

echo ">>> 1TSR indiriliyor..."
wget -q -O ${PDB_ID}_raw.pdb \
    "https://files.rcsb.org/download/${PDB_ID}.pdb" \
    || curl -sf -o ${PDB_ID}_raw.pdb \
    "https://files.rcsb.org/download/${PDB_ID}.pdb"

# ── Zincir içeriğini göster ──────────────────────────────────────────
echo ""
echo "=== 1TSR Zincir İçeriği ==="
python3 - <<'PYEOF'
chains = {}
with open("1TSR_raw.pdb") as f:
    for line in f:
        rec = line[:6].strip()
        if rec in ("ATOM", "HETATM"):
            chain = line[21]
            resname = line[17:20].strip()
            key = f"{chain}:{resname}"
            if chain not in chains:
                chains[chain] = set()
            chains[chain].add(resname)

print(f"{'Zincir':<8} {'İçerik (benzersiz residue)'}")
print("-"*50)
dna_res = {"DA","DC","DG","DT","DI","A","C","G","U","DA5","DT3"}
for ch, res in sorted(chains.items()):
    is_dna = any(r in dna_res for r in res)
    tag = " [DNA — çıkarılacak]" if is_dna else " [Protein]"
    print(f"  {ch:<6} {sorted(res)}{tag}")
PYEOF

# ── Protein + ZN koru, DNA ve su çıkar ──────────────────────────────
echo ""
echo ">>> Protein zincirleri ayıklanıyor (ZN korunuyor)..."
python3 - <<'PYEOF'
dna_res = {"DA","DC","DG","DT","DI","A","C","G","U",
           "DA5","DT3","DA3","DC5","DC3","DG5","DG3","DT5"}

protein_lines = []
with open("1TSR_raw.pdb") as f:
    for line in f:
        rec = line[:6].strip()
        if rec == "ATOM":
            resname = line[17:20].strip()
            if resname not in dna_res:
                protein_lines.append(line)
        elif rec == "HETATM":
            resname = line[17:20].strip()
            # ZN iyonunu koru, su ve DNA'yı çıkar
            if resname in ("ZN", "ZN2"):
                protein_lines.append(line)
        elif rec == "TER":
            protein_lines.append(line)

with open("1TSR_protein.pdb", "w") as f:
    f.writelines(protein_lines)
    f.write("END\n")

atom_count = sum(1 for l in protein_lines if l[:4] in ("ATOM", "HEAT"))
print(f"1TSR_protein.pdb oluşturuldu: {atom_count} atom satırı")
PYEOF

# ── PROPKA3 analizi ──────────────────────────────────────────────────
echo ""
echo ">>> PROPKA3 çalıştırılıyor (pH 7.4)..."
conda run -n ${DOCKING_ENV} propka3 1TSR_protein.pdb

echo ""
echo "=== PROPKA Özet — pKa > 6.0 ve < 8.5 arası kritik residueler ==="
python3 - <<'PYEOF'
import re, os

pka_file = "1TSR_protein.pka"
if not os.path.exists(pka_file):
    print("  PROPKA çıktı dosyası bulunamadı!")
    exit()

his_list = []     # pdb2gmx için His protonasyon kararları
print(f"{'Residue':<12} {'Zincir':<8} {'pKa':<8} {'Durum@pH7.4'}")
print("-"*45)
with open(pka_file) as f:
    in_summary = False
    for line in f:
        if "SUMMARY OF THIS PREDICTION" in line:
            in_summary = True
        if in_summary and re.match(r'\s+[A-Z]{3}\s+\d+', line):
            parts = line.split()
            if len(parts) >= 4:
                resname, resnum, chain, pka_str = parts[0], parts[1], parts[2], parts[3]
                try:
                    pka = float(pka_str)
                except:
                    continue
                if 5.5 <= pka <= 8.5:
                    if pka >= 7.4:
                        state = "PROTONATED (HIP/ASH/GLH)"
                    else:
                        state = "nötr"
                    print(f"  {resname:<10} {chain}{resnum:<7} {pka:<8.2f} {state}")
                    if resname == "HIS":
                        proton = "HIP" if pka >= 7.4 else "HIE"
                        his_list.append(f"    {chain}{resnum}: pKa={pka:.2f} → {proton}")

if his_list:
    print("\n=== pdb2gmx için -his argümanı (HID=0 / HIE=1 / HIP=2) ===")
    print("  Her His için sırayla: 0=HID(delta), 1=HIE(epsilon), 2=HIP(her ikisi)")
    for h in his_list:
        print(h)
    print("\n  Örnek: gmx pdb2gmx ... -his << 'EOF'")
    print("  [Her His için bir satır: 0, 1 veya 2]")
    print("  EOF")
PYEOF

echo ""
echo ">>> TAMAMLANDI. Sonraki adım:"
echo "    1. 1TSR_protein.pka dosyasını inceleyin"
echo "    2. Her His için protonasyon durumunu belirleyin"
echo "    3. 02_ligand_prep/prepare_ligand.sh çalıştırın"
echo "    4. 03_docking/run_docking.sh çalıştırın"
echo "    5. 04_gromacs_setup/setup_topology.sh içinde pdb2gmx -his argümanlarını güncelleyin"
