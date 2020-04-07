#!/usr/bin/env python
"""Performs a 80-10-10 split of the data.

This script is totally agnostic to the data format, except that it assumes one
example per line."""

__author__ = "Kyle Gorman, Jackson Lee"


import argparse
import contextlib
import logging

import numpy


def main(args: argparse.Namespace) -> None:
    # Creates indices for splits.
    with open(args.input_path, "r") as source:
        n_samples = sum(1 for _ in source)
    logging.info(f"Total set:\t{n_samples:,} lines")
    numpy.random.seed(args.seed)
    indices = numpy.random.permutation(n_samples)
    train_right = int(n_samples * 0.8)
    dev_right = int(n_samples * 0.9)
    logging.info(f"Train set:\t{train_right:,} lines")
    dev_indices = frozenset(indices[train_right:dev_right])
    logging.info(f"Development set:\t{len(dev_indices):,} lines")
    test_indices = frozenset(indices[dev_right:])
    logging.info(f"Test set:\t\t{len(test_indices):,} lines")
    # Writes out the splits.
    with contextlib.ExitStack() as stack:
        source = stack.enter_context(open(args.input_path, "r"))
        train_sink = stack.enter_context(open(args.train_path, "w"))
        dev_sink = stack.enter_context(open(args.dev_path, "w"))
        test_sink = stack.enter_context(open(args.test_path, "w"))
        for i, line in enumerate(source):
            line = line.rstrip()
            if i in dev_indices:
                sink = dev_sink
            elif i in test_indices:
                sink = test_sink
            else:
                sink = train_sink
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
