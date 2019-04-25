# Latex Source Code of the Paper

## Build

### Prequisites

Please install the LaTex environment.
For example, if you are using Mac OSX, please install [MacTex](https://www.tug.org/mactex/).

### Visual Studio Code (Recommended)

1. Install the [Visual Studio Code LaTeX Workshop Extension](https://github.com/James-Yu/LaTeX-Workshop) extension.
2. Build with either `latexmk` or `pdflatex`.

### Command Line

Assume you are in the `/paper` folder.

#### By `latexmk`

```bash
latexmk
```

#### By `pdflatex`

```bash
pdflatex main
bibtex main
pdflatex main
pdflatex main
```

## Development

It is strongly recommended to use Visual Studio Code with the Latex-Workshop extension installed.
If using other editors, please add relevant [.gitignore](https://github.com/github/gitignore) entries.