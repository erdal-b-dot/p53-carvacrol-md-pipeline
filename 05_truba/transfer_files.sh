#!/bin/bash
# ══════════════════════════════════════════════════════════════════════
#  TRUBA'ya Dosya Transferi
#  Yerel setup bittikten sonra çalıştırın
# ══════════════════════════════════════════════════════════════════════

TRUBA_USER="ebalcan"
TRUBA_HOST="172.16.6.15"
TRUBA_DIR="/arf/scratch/${TRUBA_USER}/md_1tsr_carvacrol"

LOCAL_GROMACS="$(dirname "$0")/../04_gromacs_setup/gromacs_run"

echo ">>> TRUBA dizini oluşturuluyor..."
ssh ${TRUBA_USER}@${TRUBA_HOST} "mkdir -p ${TRUBA_DIR}/mdp"

echo ">>> Dosyalar transfer ediliyor (rsync)..."
rsync -avz --progress \
    "${LOCAL_GROMACS}/npt.gro" \
    "${LOCAL_GROMACS}/npt.cpt" \
    "${LOCAL_GROMACS}/topol.top" \
    "${LOCAL_GROMACS}/"*.itp \
    "${LOCAL_GROMACS}/index.ndx" \
    "${TRUBA_USER}@${TRUBA_HOST}:${TRUBA_DIR}/"

# MDP dosyaları
rsync -avz \
    "$(dirname "$0")/../04_gromacs_setup/mdp/md_1us.mdp" \
    "${TRUBA_USER}@${TRUBA_HOST}:${TRUBA_DIR}/mdp/"

# SLURM script
rsync -avz \
    "$(dirname "$0")/slurm_1us.sh" \
    "${TRUBA_USER}@${TRUBA_HOST}:${TRUBA_DIR}/"

echo ""
echo ">>> Transfer tamamlandı!"
echo ""
echo "  Şimdi TRUBA'ya bağlanın ve job gönderin:"
echo "    ssh ${TRUBA_USER}@${TRUBA_HOST}"
echo "    cd ${TRUBA_DIR}"
echo "    nano slurm_1us.sh   # ← YOUR_ACCOUNT ve YOUR_EMAIL düzenleyin"
echo "    sbatch slurm_1us.sh"
echo ""
echo "  Job durumu takibi:"
echo "    squeue -u ${TRUBA_USER}"
echo "    squeue -j JOB_ID"
