# Fossil calibration

Here we use the species tree and fossil calibration points to estimate divergence times for the nodes in the phylogeny.


### 1. Get set up

```bash
conda create --name calibration
conda activate calibration

# install what we need for this recipe
conda install -c bioconda paml iqtree
```

### 2. Running iqtree

At present I'm just using a random alignment because I'm not sure where the concatenated alignment is, if there is one.

```bash
iqtree3 -s ../5_final_alignments/3_final_alignments/CIAlign_uce-16542.fasta -m GTR+G4 -te ../6_phylogenetic_analysis/concat_species_tree.treefile --dating mcmctree --prefix example
```