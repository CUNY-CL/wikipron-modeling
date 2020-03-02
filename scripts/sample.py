#!/usr/bin/env python
"""Samples from a 3-column file according to the distribution.

This script assumes the words, pronunciations, and frequencies are stored in a
three-column TSV file, one example per line."""

__author__ = "Arya D. McCarthy"

import argparse
import sys

import pandas


def _sample(
    data: pandas.DataFrame,
    n_items: int,
    seed: int,
    smoothing_amount: float = 0.0,
) -> pandas.DataFrame:
    """Sample n items without replacement according to frequencies."""
    if smoothing_amount:
        data["frequency"] += smoothing_amount
    return data.sample(
        n_items, replace=False, weights="frequency", random_state=seed
    )


def _read_csv(path: str) -> pandas.DataFrame:
    """Converts raw input for to a manipulable format.

    File might look like this (with tab delimiters):

    a   a   1000000000
    a   a   1
    a   a   1
    a capella   akapEla 1
    a cappella  akapEla 1
    a contrario ak§tRaRjo   1
    a fortiori  afORsjoRi   1
    ...
    """
    return pandas.read_csv(
        path,
        header=None,
        sep="\t",
        names=["graphemes", "phonemes", "frequency"],
    )


def main(args: argparse.Namespace) -> None:
    data = _read_csv(args.infile)
    results = _sample(data, args.n, args.seed, args.smoothing_amount)
    results.to_csv(args.outfile, sep="\t", index=False, header=False)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("infile")
    parser.add_argument("n", type=int, help="number of samples")
    parser.add_argument("seed", type=int, help="random seed")
    parser.add_argument("--outfile", default=sys.stdout)
    parser.add_argument(
        "--smoothing-amount",
        type=float,
        default=0.0,
        help="amount to add for add-lambda smoothing",
    )
    main(parser.parse_args())
