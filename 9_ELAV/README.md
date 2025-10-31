# ELAV gene

# OrthoDB

I downloaded all ELAV seuqences from ORTHODB (`metazoa.fasta`, and aligned them as follows:


```bash

_JAVA_OPTIONS="-Xmx500g"

${_JAVA_OPTIONS:+env _JAVA_OPTIONS="$_JAVA_OPTIONS"} \
macse \
   -prog      alignSequences \
   -seq       metazoa.fasta \
   -out_NT    ELAV_aln_NT.fasta \
   -out_AA    ELAV_aln_AA.fasta \
   -nb_threads 128
```








# Profile alignment

1. I downloaded the 12 seuqences from Samson, M. L. (2008). Rapid functional diversification in the structurally conserved ELAV family of neuronal RNA binding proteins. BMC genomics, 9(1), 392 which are available on genbank protein to make their alignment. I aligned them with MAFFT in Geneious, then trimmed the alignmnet to be the same as the one in their paper.

2. Renamed every sequence in `metazoa.fasta` to include the organism name and the description

3. I profile aligned every sequence in `metazoa.fasta` to the existing alignment keeping the length the same, then put them into a single alignment with `cat`.

4. As for step 3, but for each of our UCEs as well. 


This alignment now contains every sequence from OrthoDB, 12 reference sequences from the Samson paper, and also our sequences. This provides enough context to really get a handle on what's going on here.