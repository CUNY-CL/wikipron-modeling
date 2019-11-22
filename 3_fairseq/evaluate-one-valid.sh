#!/usr/bin/env bash
set -euo pipefail

lang="$1"
shift

DIMENSION="$1"
shift

CHECKPOINT_DIR=checkpoints/"$lang"-"$DIMENSION"

fairseq-generate \
	data-bin/"$lang" \
	--gen-subset valid \
    --source-lang "$lang".graphemes \
    --target-lang "$lang".phonemes \
	--path "$CHECKPOINT_DIR"/checkpoint_best.pt \
	--beam 5 \
	> "$CHECKPOINT_DIR"/output.txt

paste \
	<(cat "$CHECKPOINT_DIR"/output.txt | grep '^T-' | cut -f2) \
	<(cat "$CHECKPOINT_DIR"/output.txt | grep '^H-' | cut -f3) \
	> "$CHECKPOINT_DIR"/output.tsv

../1_evaluate/evaluate.py "$CHECKPOINT_DIR"/output.tsv 2>/dev/null
