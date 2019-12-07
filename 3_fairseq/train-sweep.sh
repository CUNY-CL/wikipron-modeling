#!/bin/bash

set -euo pipefail

readonly EMBEDDING_DIMS=(32 64 128 256)
readonly LAYER_DIMS=(64 128 256 512 1024)

mkdir -p dev-scores test-scores

for LANGUAGE in $(ls data-bin); do
    # Encoder embedding layer.
    for EED in "${EMBEDDING_DIMS[@]}"; do
        # Encoding hidden layer.
        for EHS in "${LAYER_DIMS[@]}"; do
            # Decoder embedding layers.
            for DED in "${EMBEDDING_DIMS[@]}"; do
                # Decoder hidden layer.
                for DHS in "${LAYER_DIMS[@]}"; do
                    ./train-one.sh \
                        "${LANGUAGE}" "${EED}" "${EHS}" "${DED}" "${DHS}"
                     STRING="${LANGUAGE}-${EED}-${EHS}-${DED}-${DHS}"
                    ./evaluate-one-dev.sh \
                        "${LANGUAGE}" "${EED}" "${EHS}" "${DED}" "${DHS}" \
                        > "dev-scores/scores-${STRING}"
                    ./evaluate-one-test.sh \
                        "${LANGUAGE}" "${EED}" "${EHS}" "${DED}" "${DHS}" \
                        > "test-scores/scores-${STRING}"
                done
            done
        done
    done
done
