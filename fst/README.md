This implements pair n-gram model training similar to that outlined in:

    Novak, J. R., Minematsu, N. and Hirose, K. 2012. WFST-based 
    grapheme-to-phoneme conversion: open source tools for alignment,
    model-building and decoding. _10th International Workshop on Finite State
    Methods and Natural Language Processing_, 45-49.

Requirements
============

See `../environment.yml` for version numbers used.

-   [Python](https://www.python.org/)
-   [OpenFst](http://www.openfst.org/) compiled with `./configure --enable-grm`
-   [Pynini](http://pynini.opengrm.org/)
-   [BaumWelch](http://baumwelch.opengrm.org/)
-   [NGram](http://ngram.opengrm.org/)

Workflow
========

Run [`sweep`](sweep). This may take a while. When the sweep is complete, results
are stored in the [`dev-scores/`](dev-scores/) and
[`test-scores/`](test-scores/) directories.
