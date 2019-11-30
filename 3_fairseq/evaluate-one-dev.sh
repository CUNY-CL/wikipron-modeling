#!/bin/bash

set -euo pipefail

readonly LANGUAGE="$1"
shift

readonly DIM="$1"
shift

readonly CHECKPOINT_DIR="checkpoints/${LANGUAGE}-${DIM}"

fairseq-generate \
    "data-bin/${LANGUAGE}" \
    --gen-subset valid \
    --source-lang "${LANGUAGE}.graphemes" \
    --target-lang "${LANGUAGE}.phonemes" \
    --path "${CHECKPOINT_DIR}/checkpoint_best.pt" \
    --beam 5 \
    > "${CHECKPOINT_DIR}/dev.txt"

paste \
    <(cat "${CHECKPOINT_DIR}/dev.txt" | grep '^T-' | cut -f2) \
    <(cat "${CHECKPOINT_DIR}/dev.txt" | grep '^H-' | cut -f3) \
    > "${CHECKPOINT_DIR}/dev.tsv"

../1_evaluate/evaluate.py "${CHECKPOINT_DIR}/dev.tsv" 2>/dev/null
