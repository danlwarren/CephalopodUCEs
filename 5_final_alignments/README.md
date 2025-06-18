# Final Alignments

This step involves checking all of our alignments.

First, we remove the spirula spirula that we sequenced, because it was mislabelled. I run this code from inside the `5_final_alignments` folder.

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

