# CephalopodUCEs

## Alignment generation

## Gene trees

These were estimated as follows:

```
./iqtree-3.0.1-macOS/bin/iqtree3 -S mafft-nexus-gblocks-clean-75p -m MFP -nt 8
```

## Concat tree

With normal models
```
./iqtree-3.0.1-macOS/bin/iqtree3 -p ../mafft-nexus-gblocks-clean-75p/  --prefix concat -m MFP -B 1000 -T 8
```

With MixtureFinder

```
./iqtree-3.0.1-macOS/bin/iqtree3 -p ../mafft-nexus-gblocks-clean-75p/  --prefix concat -m MIX+MFP -B 1000 -T 8
```