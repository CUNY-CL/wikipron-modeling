#!/usr/bin/env python
"""Rewrites FST examples.

This script assumes the input is provided one example per line."""

__author__ = "Kyle Gorman"

import argparse
import logging
import multiprocessing

from typing import Iterator, Union

import pynini


TokenType = Union[str, pynini.SymbolTable]

TOKEN_TYPES = ["byte", "utf8"]


class Rewriter:
    """Helper object for rewriting."""

    def __init__(
        self,
        fst: pynini.Fst,
        input_token_type: TokenType,
        output_token_type: TokenType,
    ):
        self.fst = fst
        self.input_token_type = input_token_type
        self.output_token_type = output_token_type

    def rewrite(self, i: str) -> str:
        lattice = (
            pynini.acceptor(i, token_type=self.input_token_type) @ self.fst
        )
        if lattice.start() == pynini.NO_STATE_ID:
            logging.error("Composition failure: %s", i)
            return "<composition failure>"
        lattice.project(True).rmepsilon()
        return pynini.shortestpath(lattice).string(self.output_token_type)


def _reader(path: str) -> Iterator[str]:
    """Reads strings from a single-column filepath."""
    with open(path, "r") as source:
        for line in source:
            yield line.rstrip()


def main(args: argparse.Namespace) -> None:
    fst = pynini.Fst.read(args.fst_path)
    input_token_type = (
        args.input_token_type
        if args.input_token_type in TOKEN_TYPES
        else pynini.SymbolTable.read_text(args.input_token_type)
    )
    output_token_type = (
        args.output_token_type
        if args.output_token_type in TOKEN_TYPES
        else pynini.SymbolTable.read_text(args.output_token_type)
    )
    rewriter = Rewriter(fst, input_token_type, output_token_type)
    with multiprocessing.Pool(args.cores) as pool:
        for line in pool.map(rewriter.rewrite, _reader(args.word_path)):
            print(line)


if __name__ == "__main__":
    logging.basicConfig(level="INFO", format="%(levelname)s: %(message)s")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--word_path", required=True, help="path to file of words to rewrite"
    )
    parser.add_argument(
        "--fst_path", required=True, help="path to rewrite fst FST"
    )
    parser.add_argument(
        "--cores",
        type=int,
        default=multiprocessing.cpu_count(),
        help="number of cores (default: %(default)s)",
    )
    parser.add_argument(
        "--input_token_type", default="utf8", help="input_token type"
    )
    parser.add_argument(
        "--output_token_type", default="utf8", help="output_token type"
    )
    main(parser.parse_args())
