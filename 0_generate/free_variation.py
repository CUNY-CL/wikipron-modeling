#!/usr/bin/env python3
"""Removes words with multiple golds.

If there is more than one right answer, how can we expect the model to
identify the right one?

Instead, we should eliminate these examples before train/test splitting.
"""

import argparse
import collections
import functools
import unicodedata


def main(args: argparse.Namespace) -> None:
    nfc_normalize = functools.partial(unicodedata.normalize, "NFC")
    seen_words = collections.Counter()
    with open(args.tsv, mode="r") as source:
        for line in source:
            line = nfc_normalize(line.rstrip())
            (word, phoneme_str) = line.rstrip().split("\t", 1)
            assert word, "Null word"
            seen_words[word] += 1

    with open(args.tsv, mode="r") as source:
        for line in source:
            line = nfc_normalize(line.rstrip())
            (word, phoneme_str) = line.rstrip().split("\t", 1)
            if seen_words[word] > 1:
                continue
            print(f"{word}\t{phoneme_str}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("tsv")
    main(parser.parse_args())
