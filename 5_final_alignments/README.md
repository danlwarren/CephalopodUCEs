# Final Alignments

This step involves checking all of our alignments.

First, we remove the spirula spirula that we sequenced, because it was mislabelled. I run this code from inside the `5_final_alignments` folder. This outputs a set of alignments into the `initial_alignments` folder.

```bash

IN_DIR="../4_additional_UCEs_from_genomes/alignments/UCE_candidates_from_genomes/"
OUT_DIR="initial_alignments"
TAXON="spirula_spirula"

tmp=$(mktemp)
echo "$TAXON" > "$tmp"

mkdir $OUT_DIR

for f in "$IN_DIR"/*.fa; do
    faSomeRecords -exclude "$f" "$tmp" "$OUT_DIR/$(basename "$f")"
done



```

Visual assessment of the initial alignments showed that there was a lot of unreliable variation at the ends. So after some trial and error we decided to remove low identity ends of each alignment as follows:

```bash

IN_DIR="initial_alignments"
OUT_DIR="trimmed_alignments"
mkdir -p "$OUT_DIR"

for aln in "$IN_DIR"/*.fa; do
    base=$(basename "$aln")
    trimal -in "$aln" \
           -out "$OUT_DIR/$base" \
           -w 10 -st 0.90 -terminalonly
done

```

Finally, we visually assessed every alignment, deleting unreliable columns and/or sequences when necessary using Geneious. These then form our final alignments in the `final_alignments` folder. The full history of changes we made to the alignments is in the file `manual_alignment_edits.csv`.

The final alignments are stored in the subfolder `3_final_alignments`. These were exported from geneious.

NB, for whatever reason, my attempt to remove the `spirula_spirula` sequences above didn't work. So I finally did this in Sublime text with a regex:

`>spirula_spirula(?:\r?\n[ACGTN]+)+`

using the find and replace in folders to get rid of the spirula_spirula sequences from all of the final alignments in the `/3_final_alignments` subfolder.