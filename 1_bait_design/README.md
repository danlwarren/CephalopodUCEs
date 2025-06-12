# CephalopodUCEs

## Data

The genomes used for bait design were *Loligo pealei* (now *Doryteuthis pealei*, Titus Brown, unpublished data <http://ivory.idyll.org/blog/2014-loligo-transcriptome-data.html>), *Octopus vulgaris* (Zarrella et al. 2019, NCBI ref GCA_003957725.1), *Octopus bimaculoides* (Albertin et al. 2015, NCBI ref GCF_001194135.1), and *Octopus minor* (Kim et al. 2018, supplemental material). We also tested baits in silico against the genome of the golden apple snail, *Pomacea canaliculata* (Liu et al. 2018, supplemental material) to assess their ability to amplify UCEs in non-cephalopod molluscs.

## UCE development

We conducted UCE bait design using Phyluce version 1.6.6 (Faircloth 2016; Faircloth et al. 2012), mostly following procedures given in Tutorial IV (Identifying UCE Loci and Desiging Baits To Target Them) at <https://phyluce.readthedocs.io/> including probe design and in silico testing. Data were converted to .fasta and .2bit files where necessary.

We used the *O. vulgaris* genome as the base genome for bait development. We generated simulated reads from each genome using the **art_illumina** function from ART (Huang et al. 2012) with length 100 bp, insert size of 200bp, and standard deviation of 150. Reads for each species were merged using a bash script. Due to technical issues we used **NextGenMap** (Sedlazeck et al. 2013) instead of **stampy** (Gerton and Goodson 2011) to align the reads for each species to the base genome and convert the output to BAM format. Finally we removed unmapped reads using **samtools** (Li et al. 2009). This produced a set of conserved regions where simulated sequence data for individual species mapped to the base genome with a divergence of \< 5%.

BAM files were converted to BED files using **bedtools** (Quinlan et al. 2010), and BED file contents were sorted by scaffold and position, and proximate positions were then merged. At this point the number of regions that putatively aligned with the base genome were:

| Putatively aligned regions | Species                       |
|----------------------------|-------------------------------|
| 2,625,555                  | *Loligo (Doryteuthis) pealei* |
| 4,503,649                  | *Octopus bimaculoides*        |
| 4,475,396                  | *Octopus minor*               |

We then used **phyluce** to strip masked loci from the set and find alignment intervals that were shared among taxa.

## Citations

Albertin, Caroline B., Oleg Simakov, Therese Mitros, Z. Yan Wang, Judit R. Pungor, Eric Edsinger-Gonzales, Sydney Brenner, Clifton W. Ragsdale, and Daniel S. Rokhsar. 2015. "The Octopus Genome and the Evolution of Cephalopod Neural and Morphological Novelties." Nature 524 (7564): 220--24.

Faircloth, Brant C., John E. McCormack, Nicholas G. Crawford, Michael G. Harvey, Robb T. Brumfield, and Travis C. Glenn. 2012. "Ultraconserved Elements Anchor Thousands of Genetic Markers Spanning Multiple Evolutionary Timescales." Systematic Biology 61 (5): 717--26.

Faircloth, Brant C. 2016. "PHYLUCE Is a Software Package for the Analysis of Conserved Genomic Loci." Bioinformatics 32 (5): 786--88.

Huang, Weichung, Leping Li, Jason R Myers, and Gabor T Marth. ART: a next-generation sequencing read simulator, Bioinformatics (2012) 28 (4): 593-594

Kim, Bo-Mi, Seunghyun Kang, Do-Hwan Ahn, Seung-Hyun Jung, Hwanseok Rhee, Jong Su Yoo, Jong-Eun Lee, et al. 2018. "The Genome of Common Long-Arm Octopus Octopus Minor." GigaScience 7 (11). <https://doi.org/10.1093/gigascience/giy119>.

Li, Heng, Bob Handsaker, Alec Wysoker, Tim Fennell, Jue Ruan, Nils Homer, Gabor Marth, Goncalo Abecasis, Richard Durbin, 1000 Genome Project Data Processing Subgroup, The Sequence Alignment/Map format and SAMtools, Bioinformatics, Volume 25, Issue 16, August 2009, Pages 2078--2079, <https://doi.org/10.1093/bioinformatics/btp352>

Liu, Conghui, Yan Zhang, Yuwei Ren, Hengchao Wang, Shuqu Li, Fan Jiang, Lijuan Yin, et al. 2018. "The Genome of the Golden Apple Snail Pomacea Canaliculata Provides Insight into Stress Tolerance and Invasive Adaptation." GigaScience 7 (9). <https://doi.org/10.1093/gigascience/giy101>.

Lunter Gerton, and Martin Goodson. Stampy: a statistical algorithm for sensitive and fast mapping of Illumina sequence reads. Genome Res. 2011 Jun;21(6):936-9. doi: 10.1101/gr.111120.110. Epub 2010 Oct 27. PMID: 20980556; PMCID: PMC3106326.

Quinlan, Aaron R., Ira M. Hall, BEDTools: a flexible suite of utilities for comparing genomic features, Bioinformatics, Volume 26, Issue 6, March 2010, Pages 841--842, <https://doi.org/10.1093/bioinformatics/btq033>

Sedlazeck, Fritz J., Philipp Rescheneder, and Arndt von Haeseler. 2013. NextGenMap: fast and accurate read mapping in highly polymorphic genomes. Bioinformatics, Vol. 29, No. 21., pp. 2790-2791, doi:10.1093/bioinformatics/btt468

Zarrella, Ilaria, Koen Herten, Gregory E. Maes, Shuaishuai Tai, Ming Yang, Eve Seuntjens, Elena A. Ritschard, et al. 2019. "The Survey and Reference Assisted Assembly of the Octopus Vulgaris Genome." Scientific Data 6 (1): 13.
