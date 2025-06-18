# Retrieving UCEs from genomes

## Data

**INFO HERE ON WHERE EACH GENOME CAME FROM**

## UCE Sequence Retrieval

We used four sets of baits to attempt to extract more UCEs from recently published genomes:

-   The original baits: output is in `/original_baits`
-   Consensus squid baits: output is in `/squid_baits`
-   Consensus octopus baits: output is in `/octopus_baits`
-   Consensus baits from all species: output is in `/allspp_baits`

Each is covered below. Using the original baits is pretty obvious. We also attempted to create new baits using the new data we generated. The thinking here is that the original baits were somewhat biased towards octopus, and made from just four genomes. So we hypothesised that it might be worth using the new data on UCEs we successfully amplified to create new baits, because these have much broader representation over the target group, and we can also make group-specific baits (limited to the well supported division of squids and octopus).

Each set of baits gives us some potential UCEs from each target genome. We can then combine these and extract the longest hit for each UCE from each genome, then add these to our alignments for further analysis.

### Making the new baits

First we make the new baits. Each is based on a list of species from the curated UCE alignments: 

* `squid_spp.txt` are the squid species
* `octopus_spp.txt` are the octopus species
* `all_spp.txt` are all the ingroup species (squids+octopusses)

Here's how you do that. First cd to the folder `4_additional_UCEs_from_genomes`

``` bash
conda env create -f environment.yml 
conda activate uce_add
```

Then we run the script to make each set of probes. This script takes the middle 180bp of an alignment (less if it's shorter) and makes two probes of 120bp that overlap by the central 60bp. The probes are 80% majority rule - i.e. if >=80% of bases at a site are the same, then we record that base. Otherwise we record an N.

``` bash
bash make_probes.sh ../3_initial_alignment/mafft-nexus-gblocks-clean-75p/ squid_spp.txt probes_squid.fasta 
bash make_probes.sh ../3_initial_alignment/mafft-nexus-gblocks-clean-75p/ octopus_spp.txt probes_octopus.fasta 
bash make_probes.sh ../3_initial_alignment/mafft-nexus-gblocks-clean-75p/ all_spp.txt probes_all.fasta 
```

Finally, we concatenate all the probe files into one, so now most UCEs in our dataset are covered by the original probes, and three new probes made above.

```bash
cat ../1_bait_design/data/clear_trimmed.fasta probes_squid.fasta probes_octopus.fasta probes_all.fasta > probes_combined.fasta
``` 

### Running the combined bait sets against genomes

We used the UCE baits we designed in order to extract further sequence data from existing genomes. For this we used **phyluce** version 1.7.3 (Faircloth, 2016), following procedures given in Tutorial III (Harvesting UCE Loci From Genomes) at <https://phyluce.readthedocs.io/>. Downloaded genomes were converted to 2bit format using **faToTwoBit** and information from each genome was collected using **twoBitInfo**, both from the **Kent Source Archive** (<https://hgdownload.soe.ucsc.edu/admin/exe/>).

We aligned the UCE probes in our **clear_trimmed.fasta** file (developed in step 1) to each genome, and then extracted fasta sequences matching UCE loci from each genome with up to 500 bp on each side of the probes.

``` bash
 phyluce_probe_run_multiple_lastzs_sqlite \
    --db reseqs_original.sqlite \
    --output reseq-original-lastz \
    --scaffoldlist doryteuthispealeii octopusminor octopusvulgaris \
    octopusbimaculoides acanthosepionesculentum acanthosepionlycidas \
    ascarosepionbandense doryteuthisopalescens eumandyaparva nautiluspompilius \
    octopussinensis sepiaofficianalis sepiettaobscura sepiolaaffinis \
    sepiolaatlantica spirulaspirula\
    --genome-base-path ./ \
    --probefile probes_combined.fasta \
    --cores 8
    
    
 phyluce_probe_slice_sequence_from_genomes \
    --lastz reseq-original-lastz \
    --conf genomes.conf \
    --flank 500 \
    --name-pattern "probes_original.fasta_v_{}.lastz.clean" \
    --output UCE_candidates_from_genomes
```

These UCEs are output into the `/original_baits` subfolder.

**DAN NOTE TO SELF: TABLE OF HOW MANY UCEs SHOW UP IN WHICH SPECIES, CSV OF 1/0 RESULTS**


### Adding the newly extracted UCEs to the original alignments

Finally we add the newly extracted UCEs to the original alignments. The argument is the directory name, e.g. "reseq-squid-fasta-i80-c60". Breifly, this script takes the longest hit for each UCE from each species, reverse complements it if necessary, and then profile-aligns it to the corresponding alignment using MAFFT. Newly added sequences are given the suffix `--genome` so it's clear which taxa in the alignment come from sequencing, and which from genome extraction.

``` bash
bash add_new_taxa_to_alignments.sh UCE_candidates_from_genomes
```

### Gene trees

Finally we make gene trees which helps to QC the alignments. I use parallel here so I get one file per gene for QC.

```bash
ALIGN_DIR="alignments/UCE_candidates_from_genomes" 
OUT_DIR="gene_trees"
JOBS=128

mkdir -p "$OUT_DIR"

find "$ALIGN_DIR" -maxdepth 1 -type f -name '*.fa' -print0 |
  parallel -0 -j "$JOBS" --eta \
    '../3_initial_alignment/gene_trees/iqtree-3.0.1-Linux/bin/iqtree3 -s {} -m MFP -nt 1 -pre '"$OUT_DIR"'/{/.}'

# remove all but the .iqtree and .treefile files
find "$OUT_DIR" -type f ! \( -name '*.iqtree' -o -name '*.treefile' \) -delete
```


### Concat tree

```bash
../3_initial_alignment/gene_trees/iqtree-3.0.1-Linux/bin/iqtree3 -p $ALIGN_DIR --prefix concat_merge -m MFP+MERGE -B 1000 -T 128
```

### Alignment stats

Let's get some stats across all alignments. This gives a summary file that's useful.

```bash
ALIGN_DIR="alignments/UCE_candidates_from_genomes/"

# get all the fasta files
mapfile -t FILES < <(find "$ALIGN_DIR" -type f -name '*.fa' | sort)

AMAS.py summary \
    -d dna \
    -f fasta \
    -c 128 \
    -s \
    -o "alignments/UCE_candidates_from_genomes.tsv" \
    -i "${FILES[@]}"
```

Now lets get taxon occupancy.

```bash
tmp="alignments/.taxon_raw.txt"
> "$tmp"
for aln in "${FILES[@]}"; do
    seqkit fx2tab -n "$aln" | awk '{print $1}' | sort -u >> "$tmp"
done

sort "$tmp" | uniq -c | awk '{print $2"\t"$1}' | sort -k2,2nr > "alignments/taxon_counts.tsv"
rm "$tmp"
```


## Citations

Faircloth, Brant C. 2016. "PHYLUCE Is a Software Package for the Analysis of Conserved Genomic Loci." Bioinformatics 32 (5): 786--88.
