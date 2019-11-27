#!/usr/bin/env bash
set -euo pipefail

for dim in 8 16 32 64 128; do
	for lang in $(ls data-bin); do
		./train-one.sh "$lang" "$dim"
	done
done

mkdir -p dev-scores

for lang in $(ls data-bin); do
	for dim in 8 16 32 64 128; do
		./evaluate-one-dev.sh "$lang" "$dim" > dev-scores/"dev-scores-$lang-$dim.txt"
	done
done

mkdir -p test-scores

for lang in $(ls data-bin); do
	for dim in 8 16 32 64 128; do
		./evaluate-one-test.sh "$lang" "$dim" > test-scores/"test-scores-$lang-$dim.txt"
	done
done
