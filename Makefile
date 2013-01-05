
VERSION = 1.1.1
RELEASE_DATE = 2013-01-05
RELEASE_NAME = randexam-$(VERSION)

RELEASE_FILES = ChangeLog Makefile README COPYING randexam randexam.tex randexam.pdf library.tex scantron.dat pipeline.gv statemachine.gv

.PHONY: all release
all: randexam.pdf
release: $(RELEASE_NAME).tar.gz

$(RELEASE_NAME).tar.gz: randexam.pdf
	grep -q $(VERSION) README
	grep -q $(VERSION) ChangeLog
	grep -q $(VERSION) randexam.tex
	grep -q $(RELEASE_DATE) README
	grep -q $(RELEASE_DATE) ChangeLog
	grep -q $(RELEASE_DATE) randexam.tex
	mkdir $(RELEASE_NAME)
	cp $(RELEASE_FILES) $(RELEASE_NAME)
	tar czf $@ $(RELEASE_NAME)

randexam.pdf: pipeline.pdf statemachine.pdf

%.pdf: %.tex
	pdflatex $<
	pdflatex $<

%.png: %.pdf
	convert -density 130 $< $@

%.eps: %.gv
	dot -Tps $< > $@

%.pdf: %.eps
	epstopdf $<

clean:
	rm -f pipeline.{pdf,png,eps} statemachine.{pdf,png,eps} randexam.{pdf,aux,log,synctex.gz} stats_*.{csv,halfviz} {points,specs,solutions,answers,grades}.csv exams.{tex,pdf,aux,log,synctex.gz} library.{pdf,aux,log,synctex.gz} proc_{lib,scan,ans}.log
