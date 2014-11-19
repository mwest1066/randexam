
VERSION = 1.9.0
RELEASE_DATE = 2014-03-04
RELEASE_NAME = randexam-$(VERSION)

RELEASE_FILES = ChangeLog Makefile README.md LICENSE randexam preproc randexam-user-manual.tex randexam-user-manual.pdf randexam-dev-manual.tex randexam-dev-manual.pdf library.tex scantron.dat netids.txt pipeline.gv statemachine.gv

.PHONY: all release
all: randexam-user-manual.pdf randexam-dev-manual.pdf
release: $(RELEASE_NAME).tar.gz

$(RELEASE_NAME).tar.gz: randexam-user-manual.pdf randexam-dev-manual.pdf
	grep -q $(VERSION) randexam
	grep -q $(VERSION) README.md
	grep -q $(VERSION) ChangeLog
	grep -q $(VERSION) randexam-user-manual.tex
	grep -q $(VERSION) randexam-dev-manual.tex
	grep -q $(RELEASE_DATE) randexam
	grep -q $(RELEASE_DATE) README.md
	grep -q $(RELEASE_DATE) ChangeLog
	grep -q $(RELEASE_DATE) randexam-user-manual.tex
	grep -q $(RELEASE_DATE) randexam-dev-manual.tex
	mkdir $(RELEASE_NAME)
	cp $(RELEASE_FILES) $(RELEASE_NAME)
	tar czf $@ $(RELEASE_NAME)

randexam-dev-manual.pdf: pipeline.pdf statemachine.pdf

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
	rm -rf pipeline.{pdf,png,eps} statemachine.{pdf,png,eps} randexam-user-manual.{pdf,aux,log,synctex.gz} randexam-dev-manual.{pdf,aux,log,synctex.gz} stats_*.{csv,halfviz} {points,specs,scores,solutions,answers,grades,gradebook}.csv {full_solutions,exams,stats}.{tex,pdf,aux,log,synctex.gz} library.{pdf,aux,log,synctex.gz} proc_{lib,scan,ans}.log feedback
