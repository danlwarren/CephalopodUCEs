# Phylogenetic analyses

Here we use the final cleaned alignments from `5_final_alignments/3_final_alignments` to build various trees. This follows the concordance vector tutorial from the IQ-TREE docs for the most part.

Note that here I first edited the filenames of the final alignments exported from Geneious to remove the dashes and `(modified)` suffixes, because IQ-TREE doesn't like special characters in filenames.

### 1. Get set up

```bash
conda create --name concordance
conda activate concordance

# install what we need for this recipe
conda install -c bioconda iqtree astral-tree
conda install -c conda-forge r-base r-tidyverse r-boot r-ape r-ggtext

# get the R script
wget https://raw.githubusercontent.com/roblanf/concordance_vectors/main/concordance_vector.R
wget https://raw.githubusercontent.com/roblanf/concordance_vectors/main/concordance_table.R
wget https://raw.githubusercontent.com/roblanf/concordance_vectors/main/change_labels.R
```

### 2. Run gene trees

```bash
iq3=../3_initial_alignment/gene_trees/iqtree-3.0.1-Linux/bin/iqtree3
aln=../5_final_alignments/3_final_alignments/
$iq3 -S $aln -m MFP --prefix loci -T 128
```

### 3. Estimate the species tree

Given that we have UCEs, and that stochastic error in gene trees will be extremely high, we will estimate the species tree using a partitioned model on a concatenated dataset as follows:

```bash
$iq3 -p $aln --prefix concat_species_tree -m MFP+MERGE -B 1000 -T 32
```

### 4. Get the qCFs from ASTRAL

Here we map the gene trees to the species tree using ASTRAL to get the qCF values

```bash
astral -q concat_species_tree.treefile -i loci.treefile -t 2 -o astral_species_annotated.tree 2> astral_species_annotated.log
```

### 5. Get the gCF and sCF values with IQ-TREE

Since I estimated a partitioning scheme first, I use that here. 

```bash
# sCF
$iq3 -te astral_species_annotated.tree -p concat_species_tree.best_scheme.nex --scfl 100 --prefix scfl -T 128

# gCF
$iq3 -te scfl.cf.tree --gcf loci.treefile --prefix gcf -T 128

# coalescent branch lengths
$iq3 -te astral_species_annotated.tree -blfix -p loci.best_model.nex --scfl 1 --prefix coalescent_bl -T 128

```

### 6. Process the data to get concordance vectors

Here we just process the branch labels to put them in various more convenient formats.

```bash
Rscript concordance_vector.R
Rscript change_labels.R

```