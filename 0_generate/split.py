#!/usr/bin/env python
"""Performs a 80-10-10 split of the data.

This script is totally agnostic to the data format, except that it assumes one
example per line."""

__author__ = "Kyle Gorman"


import argparse
import logging
import random


def main(args: argparse.Namespace) -> None:
    # Reads in data and shuffles.
    with open(args.input_path, "r") as source:
        data = [line.rstrip() for line in source]
    random.seed(args.seed)
    random.shuffle(data)
    # Creates split boundaries.
    train_right = int(len(data) * 0.8)
    dev_right = int(len(data) * 0.9)
    # Writes them out.
    subset = data[:train_right]
    logging.info("Train set:\t%d lines", len(subset))
    with open(args.train_path, "w") as sink:
        for line in subset:
            print(line, file=sink)
    subset = data[train_right:dev_right]
    logging.info("Development set:\t%d lines", len(subset))
    with open(args.dev_path, "w") as sink:
        for line in subset:
            print(line, file=sink)
    subset = data[dev_right:]
    logging.info("Test set:\t\t%d lines", len(subset))
    with open(args.test_path, "w") as sink:
        for line in subset:
            print(line, file=sink)


if __name__ == "__main__":
    logging.basicConfig(level="INFO", format="%(levelname)s: %(message)s")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--seed",
        type=int,
        required=True,
        help="random seed for shuffling data",
    )
    parser.add_argument(
        "--input_path", required=True, help="path to input data"
    )
    parser.add_argument(
        "--train_path", required=True, help="path to output training data"
    )
    parser.add_argument(
        "--dev_path", required=True, help="path to output development data"
    )
    parser.add_argument(
        "--test_path", required=True, help="path to output test data"
    )
    main(parser.parse_args())
