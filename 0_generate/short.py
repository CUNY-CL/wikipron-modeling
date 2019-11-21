#!/usr/bin/env python
"""Removes "short" words.

A word is defined as short if:

* the graphemic side consists of less than two Unicode chars, or
* the phonemic side has less than two "segments".

We also apply NFC normalization, just to be sure.
"""

import argparse
import functools
import unicodedata


def main(args: argparse.Namespace) -> None:
    nfc_normalize = functools.partial(unicodedata.normalize, "NFC")
    with open(args.tsv, "r") as source:
        for line in source:
            line = nfc_normalize(line.rstrip())
            (word, phoneme_str) = line.rstrip().split("\t", 1)
            assert word, "Null word"
            phonemes = phoneme_str.split(" ")
            assert phonemes, "Null phoneme string"
            if len(word) < 2 or len(phonemes) < 2:
                    continue
            print(f"{word}\t{phoneme_str}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("tsv")
    main(parser.parse_args())
