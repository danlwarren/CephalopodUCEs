# CephalopodUCEs

## Alignment generation

Alex to fill in everything to go from the raw UCE sequences to the alignments, with details of what software and commands were used, when humans were involved, etc.

## Gene trees

First we estimate them with standard models

```bash
./iqtree-3.0.1-Linux/bin/iqtree3 -S ../mafft-nexus-gblocks-clean-75p -m MFP -nt 128 --prefix loci_mf
```

Then we estimate them with MixtureFinder (annoyingly, `-S` doesn't work for this so we need GNU parallel)

Note that this uses MixtureFinder, and adds more than the standard set of rate classes (since we're dealing with UCEs).

```bash

ALIGN_DIR="../mafft-nexus-gblocks-clean-75p" 
OUT_DIR="loci_mixturefinder"
JOBS=128

mkdir -p "$OUT_DIR"

find "$ALIGN_DIR" -maxdepth 1 -type f -name '*.nexus' -print0 |
  parallel -0 -j "$JOBS" --eta \
    './iqtree-3.0.1-Linux/bin/iqtree3 -s {} -m MIX+MFP -mrate E,I,G,I+G,R,I+R -mrate-twice 1 -nt 1 -pre '"$OUT_DIR"'/{/.}'

# remove all but the .iqtree and .treefile files
find "$OUT_DIR" -type f ! \( -name '*.iqtree' -o -name '*.treefile' \) -delete


# put all the gene trees into a single file to use with ASTRAL later...
cat loci_mixturefinder/CIAlign_uce-*.treefile > loci_mix.treefile 
```


We then examine whether the mixture models are doing much - if they are, we'll see a lot of models with >1 class. Let's check:

```bash
cd $OUT_DIR
grep -H "Best-fit model according to BIC" ./*.iqtree > bic.txt

# Table of the number of classes in each model across alignments
echo -e "Classes\tFrequency"
awk '
  {
    if (match($0, /MIX\{([^}]*)\}/, m)) {
        n = split(m[1], a, /,/)
        print n
    } else {
        print 1
    }
  }' bic.txt |
sort -n | uniq -c |
awk '{print $2 "\t" $1}'

echo 

# Table of the RHAS models across alignments
echo -e "Model\tFrequency"
awk '
{
    line = $0
    sub(/^[^:]+:Best-fit model according to BIC:[[:space:]]*/, "", line)
    sub(/^MIX\{[^}]+\}/, "", line)
    if (match(line, /\+[IGR].*/)) {
        print substr(line, RSTART)
    }
}' bic.txt |
sort | uniq -c | sort -nr |                      
awk '{cnt=$1; $1=""; sub(/^ /,""); print $0 "\t" cnt}'

# then clean up all the files we don't need anymore
rm bic.txt
rm *.treefile
rm *.iqtree
```

This shows that we get a lot from the mixture models, so we should stick with them for our future analyses:

```
Classes Frequency
1       80
2       378
3       139
4       22
5       3

Model   Frequency
+I+G4   298
+G4     248
+I+R2   35
+R3     21
+I      11
+R2     4
+I+R3   4
+R4     1

```

We can also look at the distribution of tree lengths from the two approaches:

```bash
cd ..

Rscript tree_lengths.R
```

## ASTRAL tree

A good sanity check here is to run a tree with ASTRAL. Run this from within the `/gene_trees` folder.

```bash

astral -Xmx32G \
       -i loci_mix.treefile \
       -o astral_species_tree_mix.tre  \
       2> astral.log

astral -Xmx32G \
       -i loci_mf.treefile \
       -o astral_species_tree_mf.tre  \
       2> astral.log

```

## Concatenated tree

With normal partitioned models. Run this from within the `/gene_trees` folder.

```bash
./iqtree-3.0.1-Linux/bin/iqtree3 -p ../mafft-nexus-gblocks-clean-75p --prefix concat_merge -m MFP+MERGE -B 1000 -T 128
```

With MixtureFinder. Run this from within the `/gene_trees` folder. The first line makes a concatenated alignment.

```bash
./iqtree-3.0.1-Linux/bin/iqtree3 -p ../mafft-nexus-gblocks-clean-75p --out-aln ceph_supermatrix.fasta --out-format FASTA
./iqtree-3.0.1-Linux/bin/iqtree3 -s ceph_supermatrix.fasta --prefix concat_mix -m MIX+MFP -B 1000 -T 128
```