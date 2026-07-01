from rdkit import Chem
from rdkit.Chem import AllChem
from meeko import MoleculePreparation, PDBQTWriterLegacy
from vina import Vina
import numpy as np

RECEPTOR = "receptor.pdbqt"
CENTER = [57.767, 1.858, 76.828]  # validated carvacrol pocket centroid

smi = "Cc1ccc(C(C)C)cc1O"
mol = Chem.MolFromSmiles(smi)
mol = Chem.AddHs(mol)
AllChem.EmbedMolecule(mol, randomSeed=42, useRandomCoords=True)
AllChem.MMFFOptimizeMolecule(mol)
prep = MoleculePreparation()
setups = prep.prepare(mol)
pdbqt_str, ok, err = PDBQTWriterLegacy.write_string(setups[0])

configs = [
    (20, 20, "box20_ex8"),
    (20, 32, "box20_ex32"),
    (40, 8, "box40_ex8"),
    (40, 32, "box40_ex32"),
    (60, 32, "box60_ex32"),
    (99, 32, "box99_ex32_like_repo"),
]

for box_size, exh, label in configs:
    scores = []
    for seed in [1, 42, 123]:
        v = Vina(sf_name="vina", cpu=4, verbosity=0, seed=seed)
        v.set_receptor(RECEPTOR)
        v.set_ligand_from_string(pdbqt_str)
        v.compute_vina_maps(center=CENTER, box_size=[box_size, box_size, box_size])
        v.dock(exhaustiveness=exh, n_poses=5)
        e = v.energies(n_poses=5)
        scores.append(e[0][0])
    print(f"{label}: seeds scores = {scores}  mean={np.mean(scores):.3f}  best={min(scores):.3f}")
