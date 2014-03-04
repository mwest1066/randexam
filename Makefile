
VERSION = 1.9.0
RELEASE_DATE = 2014-03-04
RELEASE_NAME = randexam-$(VERSION)

RELEASE_FILES = ChangeLog Makefile README.md LICENSE randexam preproc randexam.tex randexam.pdf library.tex scantron.dat netids.txt pipeline.gv statemachine.gv

.PHONY: all release
all: randexam.pdf
release: $(RELEASE_NAME).tar.gz

$(RELEASE_NAME).tar.gz: randexam.pdf
	grep -q $(VERSION) randexam
	grep -q $(VERSION) README.md
	grep -q $(VERSION) ChangeLog
	grep -q $(VERSION) randexam.tex
	grep -q $(RELEASE_DATE) randexam
	grep -q $(RELEASE_DATE) README.md
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
	rm -rf pipeline.{pdf,png,eps} statemachine.{pdf,png,eps} randexam.{pdf,aux,log,synctex.gz} stats_*.{csv,halfviz} {points,specs,scores,solutions,answers,grades,gradebook}.csv {full_solutions,exams,stats}.{tex,pdf,aux,log,synctex.gz} library.{pdf,aux,log,synctex.gz} proc_{lib,scan,ans}.log feedback
