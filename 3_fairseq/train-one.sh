#!/usr/bin/env bash
set -euo pipefail

lang="$1"
shift

DIMENSION="$1"
shift

# TODO: change checkpoint dir if we do hpm sweeps

fairseq-train data-bin/"$lang" \
    --source-lang "$lang".graphemes \
    --target-lang "$lang".phonemes \
    --save-dir checkpoints/"$lang"-"$DIMENSION" \
    --lr 0.25 \
    --clip-norm 0.1 \
    --dropout 0.2 \
    --arch lstm \
    --encoder-embed-dim $DIMENSION \
    --encoder-hidden-size $DIMENSION \
    --encoder-bidirectional \
    --decoder-embed-dim $DIMENSION \
    --decoder-out-embed-dim $DIMENSION \
    --share-decoder-input-output-embed \
    --decoder-hidden-size $DIMENSION \
    --max-sentences $DIMENSION \
    --max-epoch 50 \
    "$@"  # In case we want to configure more from caller script.

