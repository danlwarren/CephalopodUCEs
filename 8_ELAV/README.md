# ELAV gene

# OrthoDB

I downloaded all ELAV seuqences from ORTHODB, and aligned them as follows:


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