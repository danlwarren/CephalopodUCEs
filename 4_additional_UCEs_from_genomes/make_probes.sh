#!/usr/bin/env bash
# build_uce_probes.sh  ALIGN_DIR  SPECIES_LIST  OUTPUT_FASTA
# ----------------------------------------------------------
# • Dependencies:  seqmagick ≥0.4,  EMBOSS consambig ≥6.0
# • Probe rules
#       core <120 bp         → skip locus
#       core =120 bp         → 1 probe  (p1)
#   120<core<180 bp          → 2 probes (leftmost 120 bp =p1, rightmost 120 bp =p2)
#       core ≥180 bp         → 2 probes (1‑120 bp =p1, 61‑180 bp =p2; 60 bp overlap)

set -euo pipefail
shopt -s nullglob

ALIGN_DIR="$1"
SPECIES_LIST="$2"
OUT_FASTA="$3"

: > "$OUT_FASTA"          # truncate / create output file

for ALN in "$ALIGN_DIR"/CIAlign_uce-*.nexus; do
    FILE=$(basename "$ALN")           # CIAlign_uce-118.nexus
    LOCUS=${FILE#CIAlign_}            # uce-118.nexus
    LOCUS=${LOCUS%.nexus}             # uce-118

    # 1. Convert to FASTA (alignment kept), then subset taxa
    TMP_FASTA=$(mktemp --suffix=.fa)
    seqmagick convert --input-format nexus --output-format fasta "$ALN" "$TMP_FASTA"

    # 2. get just the species in our input list
    SUB_FASTA=$(mktemp --suffix=.fa)
    seqkit grep -n -f "$SPECIES_LIST" "$TMP_FASTA" > "$SUB_FASTA"
    rm -f "$TMP_FASTA"

    # check we still have any species!!
    SEQCOUNT=$(grep -c '^>' "$SUB_FASTA" || true)
    if (( SEQCOUNT == 0 )); then
        echo "[skip] $LOCUS (no listed taxa present)" >&2
        rm -f "$SUB_FASTA"
        continue
    fi

    # ---------------- 2. define core (middle ≤180 bp) ----------------
    LEN=$(seqmagick info --format tab "$SUB_FASTA" | awk 'NR==2{print $4}')
    CORE_LEN=$(( LEN < 180 ? LEN : 180 ))
    START=$(( (LEN - CORE_LEN) / 2 + 1 ))   # 1‑based
    END=$(( START + CORE_LEN - 1 ))

    CORE_ALN=$(mktemp --suffix=.fa)
    seqmagick convert --cut "${START}:${END}" "$SUB_FASTA" "$CORE_ALN"
    rm -f "$SUB_FASTA"

    # ---------------- 3. IUPAC consensus ----------------
    CONS_FA=$(mktemp --suffix=.fa)
    consambig -sequence "$CORE_ALN" -outseq "$CONS_FA" -name tmp 2>/dev/null
    CONS=$(awk 'NR>1{printf("%s",$0)}' "$CONS_FA")
    rm -f "$CORE_ALN" "$CONS_FA"

    # ---------------- 4. probe output ----------------
    if   (( CORE_LEN < 120 )); then
        echo "[skip] $LOCUS (core ${CORE_LEN} bp <120)" >&2
        continue
    elif (( CORE_LEN == 120 )); then
        printf ">%s_p1\n%s\n" "$LOCUS" "$CONS" >> "$OUT_FASTA"
    elif (( CORE_LEN < 180 )); then
        printf ">%s_p1\n%s\n" "$LOCUS" "${CONS:0:120}"      >> "$OUT_FASTA"
        printf ">%s_p2\n%s\n" "$LOCUS" "${CONS: -120}"      >> "$OUT_FASTA"
    else
        printf ">%s_p1\n%s\n" "$LOCUS" "${CONS:0:120}"      >> "$OUT_FASTA"
        printf ">%s_p2\n%s\n" "$LOCUS" "${CONS:60:120}"     >> "$OUT_FASTA"
    fi
done

echo "Done. Probes written to: $OUT_FASTA"