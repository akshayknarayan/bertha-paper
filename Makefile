##

TARGETS = bertha-main

TEXFILES = $(wildcard s*.tex)
KNITRFILES = $(wildcard graphs/*.Rnw)
KNITRTARGETS = $(subst graphs/,,$(KNITRFILES:.Rnw=.tex))
PDFS = $(addsuffix .pdf,$(TARGETS))

all: $(PDFS)

%.pdf: %.tex packages.tex $(TEXFILES) $(KNITRTARGETS) bibs.bib
	pdflatex -shell-escape $*.tex
	bibtex $*
	pdflatex -shell-escape $*.tex
	pdflatex -shell-escape $*.tex

.SECONDARY: $(KNITRTARGETS)

%.tex: graphs/%.Rnw
	$(info $?)
	Rscript -e "library(knitr); knit('$?')"

clean:
	/bin/rm -f $(PDFS) $(KNITRTARGETS) *.dvi *.aux *.ps *~ *.log *.out *.lot *.lof *.toc *.blg *.bbl url.sty
	/bin/rm -rf cache

evince:
	pdflatex -shell-escape $(TARGETS).tex
	evince $(PDFS) &

acro:
	pdflatex -shell-escape $(TARGETS).tex
	acroread $(PDFS) &

osx:
	pdflatex -shell-escape $(TARGETS).tex
	open $(PDFS)

windows:
	pdflatex -shell-escape $(TARGETS).tex
	explorer.exe $(PDFS) &

home: osx

check:
	pdflatex -shell-escape $(TARGETS).tex | grep -i -e "undefined" -e "multiply"
