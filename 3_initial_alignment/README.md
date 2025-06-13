# CephalopodUCEs

## Alignment generation

Alex to fill in everything to go from the raw UCE sequences to the alignments, with details of what software and commands were used, when humans were involved, etc.

## Gene trees

```
./iqtree-3.0.1-Linux/bin/iqtree3 -S ../mafft-nexus-gblocks-clean-75p -m MFP -nt 128 --prefix loci
```

## Concat tree

With normal models
```
./iqtree-3.0.1-Linux/bin/iqtree3 -p ../mafft-nexus-gblocks-clean-75p --prefix concat -m MFP -B 1000 -T 128
```

With MixtureFinder

```
./iqtree-3.0.1-Linux/bin/iqtree3 -p ../mafft-nexus-gblocks-clean-75p/  --prefix concat -m MIX+MFP -B 1000 -T 128
```