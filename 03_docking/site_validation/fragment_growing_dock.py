import sys
from rdkit import Chem
from rdkit.Chem import AllChem, Descriptors, rdMolDescriptors
from meeko import MoleculePreparation, PDBQTWriterLegacy
from vina import Vina

RECEPTOR = "receptor.pdbqt"
CENTER = [57.767, 1.858, 76.828]
BOX = [20.0, 20.0, 20.0]
EXHAUST = 32

compounds = {
    "carvacrol_parent": "Cc1ccc(C(C)C)cc1O",
    "B1_hydroxymethyl": "OCc1ccc(C(C)C)cc1O",
    "B2_aminomethyl":   "NCc1ccc(C(C)C)cc1O",
    "B3_cyclohexyl":    "Cc1ccc(C2CCCCC2)cc1O",
    "B4_hydroxyethyl":  "OCCc1ccc(C(C)C)cc1O",
    "B5_carboxyl":      "OC(=O)c1ccc(C(C)C)cc1O",
}

def prep_ligand(smiles, seed=42):
    mol = Chem.MolFromSmiles(smiles)
    mol = Chem.AddHs(mol)
    cid = AllChem.EmbedMolecule(mol, randomSeed=seed, useRandomCoords=True, maxAttempts=1000)
    if cid < 0:
        raise RuntimeError("embed failed")
    AllChem.MMFFOptimizeMolecule(mol)
    prep = MoleculePreparation()
    setups = prep.prepare(mol)
    pdbqt_str, ok, err = PDBQTWriterLegacy.write_string(setups[0])
    if not ok:
        raise RuntimeError(f"PDBQT write failed: {err}")
    return mol, pdbqt_str

results = []
for name, smi in compounds.items():
    mol = Chem.MolFromSmiles(smi)
    mw = Descriptors.MolWt(mol)
    logp = Descriptors.MolLogP(mol)
    tpsa = rdMolDescriptors.CalcTPSA(mol)
    hbd = rdMolDescriptors.CalcNumHBD(mol)
    hba = rdMolDescriptors.CalcNumHBA(mol)
    heavy = mol.GetNumHeavyAtoms()

    try:
        molH, pdbqt_str = prep_ligand(smi)
    except Exception as e:
        print(f"{name}: PREP FAILED: {e}")
        results.append(dict(name=name, smiles=smi, mw=mw, logp=logp, tpsa=tpsa,
                             hbd=hbd, hba=hba, heavy=heavy, score=None, le=None))
        continue

    v = Vina(sf_name="vina", cpu=4, verbosity=0)
    v.set_receptor(RECEPTOR)
    v.set_ligand_from_string(pdbqt_str)
    v.compute_vina_maps(center=CENTER, box_size=BOX)
    v.dock(exhaustiveness=EXHAUST, n_poses=9)
    energies = v.energies(n_poses=9)
    best = energies[0][0]
    le = best / heavy
    v.write_poses(f"{name}_docked.pdbqt", n_poses=1, overwrite=True)

    print(f"{name}: MW={mw:.1f} logP={logp:.2f} TPSA={tpsa:.1f} score={best:.3f} LE={le:.3f}")
    results.append(dict(name=name, smiles=smi, mw=mw, logp=logp, tpsa=tpsa,
                         hbd=hbd, hba=hba, heavy=heavy, score=best, le=le))

print("\n\n=== SUMMARY (sorted by score) ===")
for r in sorted(results, key=lambda x: (x['score'] is None, x['score'])):
    if r['score'] is not None:
        print(f"{r['name']:<22} MW={r['mw']:6.1f} logP={r['logp']:5.2f} TPSA={r['tpsa']:5.1f} "
              f"HBD={r['hbd']} HBA={r['hba']} score={r['score']:7.3f} LE={r['le']:7.4f}")
    else:
        print(f"{r['name']:<22} FAILED")
