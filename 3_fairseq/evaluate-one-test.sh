#!/bin/bash

set -euo pipefail

readonly LANGUAGE="$1"
shift

readonly DIM="$1"
shift

readonly CHECKPOINT_DIR="checkpoints/${LANGUAGE}-${DIM}"

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
