# ELAV gene

# OrthoDB

## Nucleotide alignment

I downloaded all ELAV seuqences from ORTHODB, and aligned them using a translation alignment in Geneious with MAFFT default settings.

This givesan alignment of 9012 sequeces, 41% pairwise ID, length 41K. It's messy, but that's because there are lots of different ELAV and ELAV-like proteins in this OrthoDB set.

Then I blasted the Octopus bimaculoides sequence from our alignment, took the top hit (100% identity) and added that to the alignment with consensus align in Geneious. Now we can orient ourselves to what is like the copy we are interested in.

I exported the file as: `metazoa_prot_alignment.fasta`

Now we want to pull out the sequences most similar to what we're interested in.

So first I ran a tree of all 9013 seuqences like this in raxml-ng. Here it's set up just to be quick. This is the fastest way I can think of to find just the sequences that are similar to the ELAV sequences we're interested in. 

```bash
# fix taxon names because raxml doesn't like ':'
sed '/^>/s/:/____/g' metazoa_prot_alignment.fasta  > metazoa_prot_alignment_fixed.fasta

# run raxml
raxml-ng --msa metazoa_prot_alignment_fixed.fasta --model GTR+G --threads 64

# put taxon names back in tree

sed '/^>/s/__/:/g' fixed.tree  > seqs.tree

```

## AA alignment

As above, but first I translated everything in Geneious, then I aligned with MAFFT default settings.

Then exported as `metazoa_AA_alignment.fasta`

Then ran in raxml:

```bash
# fix taxon names because raxml doesn't like ':'
sed '/^>/s/:/____/g' metazoa_AA_alignment.fasta  > metazoa_AA_alignment_fixed.fasta

# run raxml
raxml-ng --msa metazoa_AA_alignment_fixed.fasta --model LG+F+G --threads 64

# put taxon names back in tree

sed '/^>/s/__/:/g' fixed.tree  > seqs.tree

```

I also tried it trimmed like so

```bash
# trim with trimal
trimal -in metazoa_AA_alignment_fixed.fasta -out metazoa_AA_alignment_fixed_gappyout.fasta -gappyout

# run raxml
raxml-ng --msa metazoa_AA_alignment_fixed_gappyout.fasta --model LG+F+G --threads 8

# run IQ-TREE
iqtree -s metazoa_AA_alignment_fixed_gappyout.fasta -m LG+C60+I+G -T 16


# put taxon names back in tree

sed '/^>/s/__/:/g' fixed.tree  > seqs.tree

```
