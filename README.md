# Languages

* `ady`: Adyghe
* `bul`: Bulgarian
* `bur`: Burmese
* `eng_uk`: English (RP)
* `fre`: French
* `geo`: Georgian
* `gre`: Modern Greek
* `hin`: Hindi
* `hun`: Hungarian
* `ice`: Icelandic
* `jpn`: Japanese
* `kor`: Korean
* `lit`: Lithuanian
* `rum`: Romanian
* `wel_sw`: Welsh (Southern)

We'll add Japanese (and remove...French?) if it's ready in time.

# Evaluation

Use `scripts/./evaluate.py`. It computes phone error rate (PER) and word
error rate (WER).

# Environment Set-up

[`conda`](https://docs.conda.io/projects/conda/en/latest/user-guide/install/download.html)
is recommended for a reproducible environment.
Once you have conda installed, create a new conda environment by running this:

```bash
conda env create -f environment.yml
```

The new environment is called "lrec-wikipron". Activate it by running this:

```bash
conda activate lrec-wikipron
```
