#!/usr/bin/env bash
# add_genome_uces.sh
# Put this file in 4_additional_UCEs_from_genomes/
# Run it from that same directory (`./add_genome_uces.sh`).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALIGN_DIR="${SCRIPT_DIR}/../3_initial_alignment/mafft-nexus-gblocks-clean-75p"
GENOME_DIR="${SCRIPT_DIR}/genome_UCEs/reseq-squid-fasta-i90-c60"
OUT_DIR="${SCRIPT_DIR}/alignments/reseq-squid-fasta-i90-c60/"
SUFFIX="_squid"
THREADS=4

mkdir -p "$OUT_DIR"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "Converting Nexus → FASTA …"
for nx in "${ALIGN_DIR}"/*.nexus; do
    base=$(basename "${nx}" .nexus)
    seqmagick convert --input-format nexus --output-format fasta "${nx}" "${TMP}/${base}.fa"
done

echo "Adding genome UCEs …"
for fa in "${TMP}"/CIAlign_uce-*.fa; do

    # make a file of stuff to add to this UCE
    uce=$(basename "${fa}" .fa | sed 's/.*uce-//')
    addfile="${TMP}/add_${uce}.fa"
    : > "${addfile}"

    # go through the extracted UCEs, pick the longest match for each UCE, and add that to the addfile
    for gf in "${GENOME_DIR}"/*.fasta; do
        base=$(basename "${gf}" .fasta)   # e.g. loligo_pealeii
        species="${base}""$SUFFIX"
        seqkit grep -n -r -p "uce-${uce}\b" "$gf" \
          | seqkit sort -l -r \
          | seqkit head -n 1 \
          | seqkit replace -p '.*' -r "$species" >> "$addfile"
    done

    grep -qv '^>' "${addfile}" || continue

    mafft --add "${addfile}" --localpair --keeplength --thread "${THREADS}" "${fa}"  > "${TMP}/out_${uce}.fa"

    mv "${TMP}/out_${uce}.fa" "${fa}"
done


echo "Saving updated FASTA alignments …"
for fa in "${TMP}"/CIAlign_uce-*.fa; do
    base=$(basename "${fa}")            # keep .fa extension
    mv "${fa}" "${OUT_DIR}/${base}"
done

echo "Done → ${OUT_DIR}"
