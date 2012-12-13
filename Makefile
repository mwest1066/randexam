
.PHONY: all
all: randexam.pdf

randexam.pdf: pipeline.pdf

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
	rm -f pipeline.{pdf,png,eps} randexam.{pdf,aux,log}
