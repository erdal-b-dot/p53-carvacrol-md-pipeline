#!/bin/bash
# ══════════════════════════════════════════════════════════════════════
#  TRUBA SLURM — 1TSR × Karvakrol  |  1 µs Üretim MD
#  GROMACS 2024.1-oneapi-2024
#
#  Kullanım:
#    1. TRUBA'da çalışma dizinine geçin
#    2. Dosyaları transfer edin (bkz. transfer_files.sh)
#    3. sbatch slurm_1us.sh
#
#  Otomatik devam: Job bitmeden süre dolursa otomatik yeniden gönderilir.
#  Checkpoint (md.cpt) varsa kaldığı yerden devam eder.
# ══════════════════════════════════════════════════════════════════════

#SBATCH --job-name=1TSR_carv_1us
#SBATCH --account=YOUR_ACCOUNT          # ← TRUBA hesap adınız
#SBATCH --partition=hamsi               # AMD EPYC 7742, 128 çekirdek/node
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1             # GROMACS: tek MPI, çok OpenMP
#SBATCH --cpus-per-task=56              # 56 çekirdek (hamsi'de 128 max)
#SBATCH --time=72:00:00                 # 3 gün (hamsi limiti)
#SBATCH --output=slurm_%j.out
#SBATCH --error=slurm_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=YOUR_EMAIL@domain   # ← E-posta adresiniz

# ── Alternatif: barbun (Intel, oneapi için daha optimize) ────────────
# #SBATCH --partition=barbun
# #SBATCH --ntasks-per-node=1
# #SBATCH --cpus-per-task=40           # barbun: 40 çekirdek/node

# ══════════════════════════════════════════════════════════════════════
module purge
module load centos7.9/app/gromacs/2024.1-oneapi-2024

GMX="gmx"                              # oneapi versiyonu tek binary
NTOMP=$SLURM_CPUS_PER_TASK            # OpenMP thread sayısı
MDP="./mdp/md_1us.mdp"
INDEX="./index.ndx"

echo "════════════════════════════════════════════════════════════"
echo "  Job ID     : $SLURM_JOB_ID"
echo "  Node       : $SLURMD_NODENAME"
echo "  Çekirdek   : $NTOMP OpenMP thread"
echo "  Başlangıç  : $(date)"
echo "  Hedef      : 1TSR (p53 core domain)"
echo "  Ligand     : Karvakrol (CID:10364)"
echo "  Süre       : 1 µs (500,000,000 adım)"
echo "════════════════════════════════════════════════════════════"

# ── grompp: .tpr dosyası yalnızca ilk çalıştırmada oluşturulur ──────
if [ ! -f md.tpr ]; then
    echo ""
    echo ">>> md.tpr oluşturuluyor..."
    $GMX grompp \
        -f "$MDP" \
        -c npt.gro \
        -t npt.cpt \
        -p topol.top \
        -n "$INDEX" \
        -o md.tpr \
        -maxwarn 2
fi

# ── mdrun: Checkpoint varsa devam et ────────────────────────────────
echo ""
if [ -f md.cpt ]; then
    echo ">>> Checkpoint bulundu: md.cpt  — kaldığı yerden devam..."
    CURRENT_NS=$($GMX check -f md.cpt 2>&1 | grep "Last frame" \
        | awk '{print $NF}' || echo "?")
    echo "    Mevcut simülasyon süresi: ~${CURRENT_NS} ps"

    $GMX mdrun \
        -v \
        -deffnm md \
        -cpi md.cpt \
        -append \
        -ntmpi 1 \
        -ntomp $NTOMP \
        -pin on \
        -pinstride 1
else
    echo ">>> İlk çalıştırma — sıfırdan başlanıyor..."
    $GMX mdrun \
        -v \
        -deffnm md \
        -ntmpi 1 \
        -ntomp $NTOMP \
        -pin on \
        -pinstride 1
fi

# ── Tamamlanma kontrolü ve otomatik yeniden gönderme ────────────────
echo ""
echo ">>> Simülasyon durumu kontrol ediliyor..."

COMPLETED_STEPS=$($GMX check -f md.cpt 2>&1 \
    | grep -oP 'Last frame\s+\K\d+' || echo "0")
TARGET_STEPS=500000000  # 1 µs

echo "  Tamamlanan adım : $COMPLETED_STEPS / $TARGET_STEPS"

if [ "$COMPLETED_STEPS" -lt "$TARGET_STEPS" ] 2>/dev/null; then
    echo "  Simülasyon henüz tamamlanmadı → Job yeniden gönderiliyor..."
    # Yeni job gönder (mevcut script kendini yeniden çalıştırır)
    NEW_JOB=$(sbatch --parsable "$0")
    echo "  Yeni Job ID: $NEW_JOB"
    echo "  md.cpt checkpoint ile devam edilecek."
else
    echo "  ✓ 1 µs simülasyon TAMAMLANDI!"
    echo "  md.xtc  → trajektori (her 100 ps)"
    echo "  md.edr  → enerji dosyası"
    echo "  md.log  → log dosyası"
fi

echo ""
echo ">>> Bitiş: $(date)"
echo "════════════════════════════════════════════════════════════"
