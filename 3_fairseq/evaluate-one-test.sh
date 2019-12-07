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

readonly STRING="${LANGUAGE}-${EED}-${EHS}-${DED}-${DHS}"
readonly CHECKPOINT_DIR="checkpoints/${STRING}"

fairseq-generate \
    "data-bin/${LANGUAGE}" \
    --gen-subset test \
    --source-lang "${LANGUAGE}.graphemes" \
    --target-lang "${LANGUAGE}.phonemes" \
    --path "${CHECKPOINT_DIR}/checkpoint_best.pt" \
    --beam 5 \
    > "${CHECKPOINT_DIR}/test.txt"

paste \
    <(cat "${CHECKPOINT_DIR}/test.txt" | grep '^T-' | cut -f2) \
    <(cat "${CHECKPOINT_DIR}/test.txt" | grep '^H-' | cut -f3) \
    > "${CHECKPOINT_DIR}/test.tsv"

../1_evaluate/evaluate.py "${CHECKPOINT_DIR}/test.tsv" 2>/dev/null
