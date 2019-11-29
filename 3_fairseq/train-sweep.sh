#!/bin/bash

set -euo pipefail

readonly DIMS=(64 128 256 512 1024)

for DIM in "${DIMS[@]}"; do
    for LANGUAGE in $(ls data-bin); do
        ./train-one.sh "${LANGUAGE}" "${DIM}"
    done
done

mkdir -p dev-scores

for LANGUAGE in $(ls data-bin); do
    for DIM in "${DIMS[@]}"; do
        ./evaluate-one-dev.sh "${LANGUAGE}" "${DIM}" \
        > "dev-scores/dev-scores-${LANGUAGE}-${DIM}.txt"
     done
done

mkdir -p test-scores

for LANGUAGE in $(ls data-bin); do
    for DIM in "${DIMS[@]}"; do
        ./evaluate-one-test.sh "${LANGUAGE}" "$DIM" \
        > "test-scores/test-scores-${LANGUAGE}-${DIM}.txt"
    done
done
