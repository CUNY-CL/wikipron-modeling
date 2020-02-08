Pair n-gram modeling toolkit
============================

This implements pair n-gram model training similar to that outlined in:

    Novak, J. R., Minematsu, N. and Hirose, K. 2012. WFST-based 
    grapheme-to-phoneme conversion: open source tools for alignment,
    model-building and decoding. _10th International Workshop on Finite State
    Methods and Natural Language Processing_, 45-49.

Python scripts are provided for data splitting, training models, decoding, and
evaluation.

Requirements
------------

See `../environment.yml` for version numbers used.

-   [Python](https://www.python.org/)
-   [OpenFst](http://www.openfst.org/) compiled with `./configure --enable-grm`
-   [Pynini](http://pynini.opengrm.org/)
-   [BaumWelch](http://baumwelch.opengrm.org/)
-   [NGram](http://ngram.opengrm.org/)

Suggested workflow
------------------

This assumes the data is formatted as a two-column tab-separated values (TSV)
file where the first column is a UTF-8-encoded grapheme sequence and the second
column consists of UTF-8-encoded IPA symbols separated by space. E.g., consider
the following line, a Romanian pronunciation

    pornește    p o r n e ʃ t 

The following shows the actual workflow:

    # Extracts symbol table.
    cut -f2 lexicon.tsv | ngramsymbols > phones.sym
    # Splits data into train, dev, and test.
    readonly SEED="${RANDOM}"
    echo "Using seed: ${SEED}"
    scripts/./split.py \
        --seed="${SEED}" \
        --input_path=lexicon.tsv \
        --train_path=train.tsv \
        --dev_path=dev.tsv \
        --test_path=test.tsv
    # Computes corpus of encoded alignments.
    fst/./align.py \
        --encoder_path=encoder.enc \
        --far_path=alignments.far \
        --output_token_type=phones.sym \
        --seed="${SEED}" \
        --tsv_path=train.tsv
    # Counts n-grams, smooths, shrinks, and decodes.
    fst/./model \
        --encoder_path=encoder.enc \
        --far_path=alignments.far \
        --fst_path=model.fst
    rm -f alignments.far encoder.enc
    fst/./predict \
        --input_path=test.tsv \
        --fst_path=model.fst \
        --output_path=hypo.txt \
        --output_token_type=phones.sym
    fst/./evaluate --gold_path=test.tsv --hypo_path=hypo.txt
    rm -f train.tsv dev.tsv test.tsv hypo.txt
