#!/bin/bash

set -euo pipefail

# Fairseq expects six files:
# Two train, two dev, two test, each distinguished by prefixes.
# One file is the source and one is the target, distinguished by suffixes.
readonly TSV_DIR=../2_tsv

for TASK in train dev test; do
    for TSV in "${TSV_DIR}"/*"${TASK}.tsv"; do
        # Separate graphemes with spaces.
        cut -d$'\t' -f1 "$TSV" | 
            sed 's/./& /g' > "${TASK}".$(basename ${TSV%_${TASK}.tsv}).graphemes
        # Phonemes are already separated intelligently in WikiPron.
        cut -d$'\t' -f2 "$TSV" > "$TASK".$(basename ${TSV%_${TASK}.tsv}).phonemes
    done
done

for DEVPATH in dev.*.graphemes; do  # e.g., dev.kor_phonetic.graphemes
    LANGUAGE="$(echo $DEVPATH | cut -d'.' -f2)"
    fairseq-preprocess \
        --source-lang "${LANGUAGE}.graphemes" \
        --target-lang "${LANGUAGE}.phonemes" \
        --trainpref 'train' \
        --validpref 'dev' \
        --testpref 'test' \
        --tokenizer space \
        --destdir "data-bin/${LANGUAGE}"
done

mkdir -p data-txt
cp *.{graph,phon}emes data-txt
rm *.{graph,phon}emes
