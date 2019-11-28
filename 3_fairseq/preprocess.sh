#!/usr/bin/env bash

set -euo pipefail

# Fairseq expects six files:
# Two train, two dev, two test, each distinguished by prefixes.
# One file is the source and one is the target, distinguished by suffixes.
TSV_DIR=../2_tsv

for type in train dev test; do
    for TSV in "$TSV_DIR"/*"$type".tsv; do
        echo "Source/target splitting: ${TSV}"
        
        # Separate graphemes with spaces
        cut -d$'\t' -f1 "$TSV" | 
            sed 's/./& /g' > "$type".$(basename ${TSV%_${type}.tsv}).graphemes
        # Phonemes are already separated intelligently in WikiPron.
        cut -d$'\t' -f2 "$TSV" > "$type".$(basename ${TSV%_${type}.tsv}).phonemes
    done
done


for file in dev.*.graphemes; do  # e.g. dev.kor_phonetic.graphemes
    lang=$(echo "$file" | cut -d'.' -f2)
    echo "fairseq-preprocess $lang"
    fairseq-preprocess \
        --source-lang "$lang".graphemes \
        --target-lang "$lang".phonemes \
        --trainpref 'train' \
        --validpref 'dev' \
        --testpref 'test' \
        --tokenizer space \
        --destdir "data-bin/$lang"
done

mkdir -p data-txt
cp *.{graph,phon}emes data-txt
rm *.{graph,phon}emes
