# Retrieving UCEs from genomes

## Data

**INFO HERE ON WHERE EACH GENOME CAME FROM**

## UCE Sequence Retrieval

We used four sets of baits to attempt to extract more UCEs from recently published genomes:

* The original baits: output is in `/original_baits`
* Consensus squid baits: output is in `/squid_baits`
* Consensus octopus baits: output is in `/octopus_baits`
* Consensus baits from all species: output is in `/allspp_baits`

Each is covered below. Using the original baits is pretty obvious. We also attempted to create new baits using the new data we generated. The thinking here is that the original baits were somewhat biased towards octopus, and made from just four genomes. So we hypothesised that it might be worth using the new data on UCEs we successfully amplified to create new baits, because these have much broader representation over the target group, and we can also make group-specific baits (limited to the well supported division of squids and octopus).

Each set of baits gives us some potential UCEs from each target genome. We can then combine these and extract the longest hit for each UCE from each genome, then add these to our alignments for further analysis. 

### Using original baits

We used the UCE baits we designed in order to extract further sequence data from existing genomes. For this we used **phyluce** version 1.7.3 (Faircloth, 2016), following procedures given in Tutorial III (Harvesting UCE Loci From Genomes) at <https://phyluce.readthedocs.io/>. Downloaded genomes were converted to 2bit format using **faToTwoBit** and information from each genome was collected using **twoBitInfo**, both from the **Kent Source Archive** (<https://hgdownload.soe.ucsc.edu/admin/exe/>).

We aligned the UCE probes in our **clear_trimmed.fasta** file (developed in step 1) to each genome, and then extracted fasta sequences matching UCE loci from each genome with up to 500 bp on each side of the probes.

These UCEs are output into the `/original_baits` subfolder.

**DAN NOTE TO SELF: TABLE OF HOW MANY UCEs SHOW UP IN WHICH SPECIES, CSV OF 1/0 RESULTS**

### Using squid baits



### Using octopus baits

## Citations

Faircloth, Brant C. 2016. "PHYLUCE Is a Software Package for the Analysis of Conserved Genomic Loci." Bioinformatics 32 (5): 786--88.
