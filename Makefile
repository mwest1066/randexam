
VERSION = 1.14.1
RELEASE_DATE = 2016-09-29
RELEASE_NAME = randexam-$(VERSION)

RELEASE_FILES = ChangeLog Makefile README.md LICENSE randexam preproc randexam-user-manual.tex randexam-user-manual.pdf randexam-dev-manual.tex randexam-dev-manual.pdf config.ini course_sem_exam1_library.tex course_sem_exam1_scantron.dat course_sem_exam1_netids.txt pipeline.gv statemachine.gv

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

randexam-user-manual.pdf: pipeline.pdf

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
	rm -rf pipeline.{pdf,png,eps} statemachine.{pdf,png,eps} randexam-user-manual.{pdf,aux,log,out,synctex.gz} randexam-dev-manual.{pdf,aux,log,out,synctex.gz} course_sem_exam1_stats_*.{csv,halfviz} course_sem_exam1_{points,specs,scores,solutions,answers,grades,gradebook}.csv course_sem_exam1_{full_solutions,exams,stats}.{tex,pdf,aux,log,synctex.gz} course_sem_exam1_library.{pdf,aux,log,synctex.gz} proc-{lib,scan,ans,email,feedback,curve}.log feedback
