#!/bin/bash

set -euo pipefail

readonly LANGUAGE="$1"; shift
# Encoder embedding dim.
readonly EED="$1"; shift
# Encoder hidden layer size.
readonly EHS="$1"; shift
# Decoder embedding dim.
readonly DED="$1"; shift
# Decoder hidden layer size.
readonly DHS="$1"; shift
# TODO: try changing the two decoder embedder dimensions separately.

# TODO: change checkpoint dir if we do hpm sweeps.

fairseq-train "data-bin/${LANGUAGE}" \
    --source-lang "${LANGUAGE}.graphemes" \
    --target-lang "${LANGUAGE}.phonemes" \
    --save-dir "checkpoints/${LANGUAGE}-${EED}-${EHS}-${DED}-${DHS}" \
    --lr 0.25 \
    --clip-norm 0.5 \
    --dropout 0.2 \
    --arch lstm \
    --encoder-embed-dim "${EED}" \
    --encoder-hidden-size "${EHS}" \
    --encoder-bidirectional \
    --decoder-embed-dim "${DED}" \
    --decoder-out-embed-dim "${DED}" \
    --share-decoder-input-output-embed \
    --decoder-hidden-size "${DHS}" \
    --max-sentences 2048 \
    --max-epoch 50 \
    --no-epoch-checkpoints \
    "$@"  # In case we want to configure more from caller script.
