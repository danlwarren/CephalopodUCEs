# CephalopodUCEs

## Alignment generation

Alex to fill in everything to go from the raw UCE sequences to the alignments, with details of what software and commands were used, when humans were involved, etc.

## Gene trees

First we estimate them with standard models

```bash
./iqtree-3.0.1-Linux/bin/iqtree3 -S ../mafft-nexus-gblocks-clean-75p -m MFP -nt 128 --prefix loci
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
```

This shows that we get a lot from the mixture models, so we should stick with them for our future analyses:

```
Classes Frequency
1       83
2       365
3       153
4       18
5       3

Model   Frequency
+I+G4   285
+G4     249
+I+R2   44
+R3     23
+I      10
+R2     5
+I+R3   5
+R4     1
```


## Concat tree

With normal partitioned models
```
./iqtree-3.0.1-Linux/bin/iqtree3 -p ../mafft-nexus-gblocks-clean-75p --prefix concat_part -m MFP -B 1000 -T 128
./iqtree-3.0.1-Linux/bin/iqtree3 -p ../mafft-nexus-gblocks-clean-75p --prefix concat_merge -m MFP+MERGE -B 1000 -T 128

```

With MixtureFinder

```
./iqtree-3.0.1-Linux/bin/iqtree3 -p ../mafft-nexus-gblocks-clean-75p/  --prefix concat -m MIX+MFP -B 1000 -T 128
```