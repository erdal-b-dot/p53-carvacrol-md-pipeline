#!/bin/bash
# ══════════════════════════════════════════════════════════════════════
#  TRUBA SLURM — 1TSR × Karvakrol  |  1 µs Üretim MD
#  GROMACS 2024.1-oneapi2024  |  ARF barbun (Intel Xeon Gold)
#
#  Otomatik devam: Job bitmeden süre dolursa otomatik yeniden gönderilir.
#  Checkpoint (md.cpt) varsa kaldığı yerden devam eder.
# ══════════════════════════════════════════════════════════════════════

#SBATCH --job-name=1TSR_carv_1us
#SBATCH --account=ebalcan
#SBATCH --partition=barbun
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --cpus-per-task=1
#SBATCH --time=72:00:00
#SBATCH --output=slurm_%j.out
#SBATCH --error=slurm_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=YOUR_EMAIL@domain   # ← E-posta adresiniz

# ══════════════════════════════════════════════════════════════════════
source /usr/share/Modules/init/bash
module purge
module load gromacs

GMX="gmx_mpi"
NP=20
NTOMP=1
export OMP_NUM_THREADS=$NTOMP
export I_MPI_HYDRA_BOOTSTRAP=fork      # tek node: fork ile rank başlat
export I_MPI_FABRICS=shm               # tek node: shared memory fabric
MDP="./mdp/md_1us.mdp"
INDEX="./index.ndx"

echo "════════════════════════════════════════════════════════════"
echo "  Job ID     : $SLURM_JOB_ID"
echo "  Node       : $SLURMD_NODENAME"
echo "  Çekirdek   : ${NP} MPI rank × ${NTOMP} OpenMP = $((NP*NTOMP)) çekirdek"
echo "  Başlangıç  : $(date)"
echo "  Hedef      : 1TSR (p53 core domain)"
echo "  Ligand     : Karvakrol (CID:10364)"
echo "  Süre       : 1 µs (500,000,000 adım)"
echo "════════════════════════════════════════════════════════════"

# ── grompp ──────────────────────────────────────────────────────────
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
    if [ $? -ne 0 ]; then
        echo "HATA: grompp başarısız, job durduruluyor."
        exit 1
    fi
fi

# ── mdrun ────────────────────────────────────────────────────────────
echo ""
if [ -f md.cpt ]; then
    echo ">>> Checkpoint bulundu: md.cpt  — kaldığı yerden devam..."
    CURRENT_NS=$(gmx_mpi check -f md.cpt 2>&1 | grep "Last frame" \
        | awk '{print $NF}' || echo "?")
    echo "    Mevcut simülasyon süresi: ~${CURRENT_NS} ps"
    # Önceki bozuk çıktıları temizle (-noappend ile yeni part dosyaları oluşur)
    rm -f md.log md.xtc md.edr md.trr

    mpirun -np $NP $GMX mdrun \
        -v \
        -deffnm md \
        -cpi md.cpt \
        -noappend \
        -ntomp $NTOMP
else
    echo ">>> İlk çalıştırma — sıfırdan başlanıyor..."
    mpirun -np $NP $GMX mdrun \
        -v \
        -deffnm md \
        -ntomp $NTOMP
fi

MDRUN_EXIT=$?

# ── Tamamlanma kontrolü ──────────────────────────────────────────────
echo ""
echo ">>> mdrun çıkış kodu: $MDRUN_EXIT"

if [ $MDRUN_EXIT -ne 0 ]; then
    # SLURM time limit veya sinyal: GROMACS SIGTERM'i yakalar ve md.cpt yazar.
    # md.cpt varsa → time limit nedeniyle sonlandı, resubmit yap.
    # md.cpt yoksa → gerçek hata, durdur.
    if [ -f md.cpt ]; then
        echo "UYARI: mdrun non-zero çıktı (exit=$MDRUN_EXIT) ama md.cpt mevcut."
        echo "  → SLURM time limit veya sinyal nedeniyle sonlandı, devam edilebilir."
    else
        echo "HATA: mdrun başarısız (exit=$MDRUN_EXIT) ve md.cpt yok — resubmit yapılmıyor."
        echo "slurm_${SLURM_JOB_ID}.err dosyasını inceleyin."
        exit $MDRUN_EXIT
    fi
fi

echo ">>> Simülasyon durumu kontrol ediliyor..."
COMPLETED_STEPS=$(gmx_mpi check -f md.cpt 2>&1 \
    | grep -oP 'Last frame\s+\K\d+' || echo "0")
TARGET_STEPS=500000000  # 1 µs

echo "  Tamamlanan adım : $COMPLETED_STEPS / $TARGET_STEPS"

if [ "$COMPLETED_STEPS" -lt "$TARGET_STEPS" ] 2>/dev/null; then
    echo "  Süre limiti aşıldı → Job yeniden gönderiliyor..."
    NEW_JOB=$(sbatch --parsable "$0")
    echo "  Yeni Job ID: $NEW_JOB"
else
    echo "  ✓ 1 µs simülasyon TAMAMLANDI!"
    echo "  md.xtc  → trajektori (her 100 ps)"
    echo "  md.edr  → enerji dosyası"
    echo "  md.log  → log dosyası"
fi

echo ""
echo ">>> Bitiş: $(date)"
echo "════════════════════════════════════════════════════════════"
