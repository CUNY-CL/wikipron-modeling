#!/usr/bin/env python
"""Performs a 80-10-10 split of the data.

This script is totally agnostic to the data format, except that it assumes one
example per line."""

__author__ = "Kyle Gorman, Jackson Lee"


import argparse
import contextlib
import logging

import numpy as np


def main(args: argparse.Namespace) -> None:
    # Creates indices for splits.
    with open(args.input_path, "r") as source:
        n_samples = sum(1 for _ in source)
    np.random.seed(args.seed)
    indices = np.random.permutation(n_samples)
    train_right = int(n_samples * 0.8)
    dev_right = int(n_samples * 0.9)
    train_indices = indices[:train_right]
    logging.info("Train set:\t%d lines", len(train_indices))
    dev_indices = indices[train_right: dev_right]
    logging.info("Development set:\t%d lines", len(dev_indices))
    test_indices = indices[dev_right:]
    logging.info("Test set:\t\t%d lines", len(test_indices))
    # Writes out the splits.
    with contextlib.ExitStack() as stack:
        source = stack.enter_context(open(args.input_path, "r"))
        train_sink = stack.enter_context(open(args.train_path, "w"))
        dev_sink = stack.enter_context(open(args.dev_path, "w"))
        test_sink = stack.enter_context(open(args.test_path, "w"))
        for i, line in enumerate(source):
            line = line.rstrip()
            if i in train_indices:
                sink = train_sink
            elif i in dev_indices:
                sink = dev_sink
            else:
                sink = test_sink
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
        "--input-path", required=True, help="path to input data"
    )
    parser.add_argument(
        "--train-path", required=True, help="path to output training data"
    )
    parser.add_argument(
        "--dev-path", required=True, help="path to output development data"
    )
    parser.add_argument(
        "--test-path", required=True, help="path to output test data"
    )
    main(parser.parse_args())
