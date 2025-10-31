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

I began by manually re-rooting the tree in treeviewer, saving it in this directory as "rooted.tre"

```bash
aln=../5_final_alignments/3_final_alignments/

iqtree3 -s $aln -m GTR+G4 --date datefile.txt -te rooted.tre --dating mcmctree --prefix dating
mcmctree dating.mcmctree.ctl
```