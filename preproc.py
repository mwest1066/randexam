#!/usr/bin/env python

if __name__ == "__main__":
    import sys
    if (len(sys.argv)<2):
        print "Usage: ", sys.argv[0], " <texfile>"
        print """  <texfile>  texfile to preprocess

Takes texfile and expands all \input commands.
Requires that each \input line be of the format:
\input filename.tex
(That is: no braces, no missing .tex extension)
"""
        quit(1)

    # we implement this with a stack; the top of which is the current file being read.
    # each \input command pushes a new open file, and EOF pops.
    # need to be careful about commented lines
    F = [open(sys.argv[1])]
    while len(F)>0:
        line = F[-1].readline()
        if line == "":
            # EOF... so pop, and close
            F.pop().close()
        else:
            # note: we do modulo arithmetic so that if -1 comes back (no match)
            # then it returns length-1. So the only way this will work is:
            # a) if there's \input
            # b) and it's found before a % (or no % at all).
            # Note that if we don't find \input, then it will automatically be >=
            # to whereever we "find" a %.
            n = line.find("\\input") % len(line)
            m = line.find("%") % len(line)
            if (n < m):
                # new file! throw it on the stack; strip out \input and whitespace
                F.append(open(line[n+7:m].strip()))
            else:
                # else, just print
                print line,
