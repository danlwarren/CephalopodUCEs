# Retrieving UCEs from genomes

## Data

**INFO HERE ON WHERE EACH GENOME CAME FROM**

## UCE Sequence Retrieval

We used the UCE baits we designed in order to extract further sequence data from existing genomes. For this we used **phyluce** version 1.7.3 (Faircloth, 2016), following procedures given in Tutorial III (Harvesting UCE Loci From Genomes) at <https://phyluce.readthedocs.io/>. Downloaded genomes were converted to 2bit format using **faToTwoBit** and information from each genome was collected using **twoBitInfo**, both from the **Kent Source Archive** (<https://hgdownload.soe.ucsc.edu/admin/exe/>).

We aligned the UCE probes in our **clear_trimmed.fasta** file (developed in step 1) to each genome, and then extracted fasta sequences matching UCE loci from each genome with up to 500 bp on each side of the probes.

These UCEs are output into the `genome_UCEs` folder.

**DAN NOTE TO SELF: TABLE OF HOW MANY UCEs SHOW UP IN WHICH SPECIES, CSV OF 1/0 RESULTS**

## Citations

Faircloth, Brant C. 2016. "PHYLUCE Is a Software Package for the Analysis of Conserved Genomic Loci." Bioinformatics 32 (5): 786--88.
