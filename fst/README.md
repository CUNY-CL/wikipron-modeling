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

-   [Python 3.6 or better](https://www.python.org/)
-   [OpenFst
    1.7.5](http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.7.5.tar.gz)
    compiled with `./configure --enable-grm`
-   [Pynini
    2.0.9.post2](http://www.opengrm.org/twiki/pub/GRM/PyniniDownload/pynini-2.0.9.post2.tar.gz)
-   [BaumWelch
    0.3.0](http://www.opengrm.org/twiki/pub/GRM/BaumWelchDownload/baumwelch-0.3.0.tar.gz)
-   [OpenGrm-NGram
    1.3.8](http://www.opengrm.org/twiki/pub/GRM/NGramDownload/ngram-1.3.8.tar.gz)

Suggested workflow
------------------

    # Extracts symbol table.
    cut -f2 lexicon.tsv | ngramsymbols > phones.sym
    # Splits data into train, dev, and test.
    readonly SEED="${RANDOM}"
    echo "Using seed: ${SEED}"
    ./split.py \
        --seed="${SEED}" \
        --input_path=lexicon.tsv \
        --train_path=train.tsv \
        --dev_path=dev.tsv \
        --test_path=test.tsv
    # Computes corpus of encoded alignments.
    ./align.py \
        --encoder_path=encoder.enc \
        --far_path=alignments.far \
        --output_token_type=phones.sym \
        --seed="${SEED}" \
        --tsv_path=train.tsv
    # Counts n-grams, smooths, shrinks, and decodes.
    ./model \
        --encoder_path=encoder.enc \
        --far_path=alignments.far \
        --fst_path=model.fst
    rm -f alignments.far encoder.enc
    ./predict \
        --input_path=test.tsv \
        --fst_path=model.fst \
        --output_path=hypo.txt \
        --output_token_type=phones.sym
    ./evaluate --gold_path=test.tsv --hypo_path=hypo.txt
    rm -f train.tsv dev.tsv test.tsv hypo.txt
