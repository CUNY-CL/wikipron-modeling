#!/bin/bash

set -euo pipefail

readonly LANGUAGE="$1"
shift

readonly DIM="$1"
shift

# TODO: change checkpoint dir if we do hpm sweeps.

fairseq-train "data-bin/${LANGUAGE}" \
    --source-lang "${LANGUAGE}.graphemes" \
    --target-lang "${LANGUAGE}.phonemes" \
    --save-dir "checkpoints/${LANGUAGE}-${DIM}" \
    --lr 0.25 \
    --clip-norm 0.1 \
    --dropout 0.2 \
    --arch lstm \
    --encoder-embed-dim "${DIM}" \
    --encoder-hidden-size "${DIM}" \
    --encoder-bidirectional \
    --decoder-embed-dim "${DIM}" \
    --decoder-out-embed-dim "${DIM}" \
    --share-decoder-input-output-embed \
    --decoder-hidden-size "${DIM}" \
    --max-sentences "${DIM}" \
    --max-epoch 50 \
    --no-epoch-checkpoints \
    "$@"  # In case we want to configure more from caller script.
