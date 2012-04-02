lib/%.js: src/%.coffee
	coffee -c -o lib/ $<

tests/%.js: src/tests/%.coffee lib/pun.js
	coffee -c -o tests/ $<

SRC = $(wildcard src/*.coffee)
JS  = $(subst src/,lib/,$(SRC:.coffee=.js))

TESTSRC = $(wildcard src/tests/*.coffee)
TESTJS  = $(subst src/,,$(TESTSRC:.coffee=.js))

all: $(JS) $(TESTJS)
	cat lib/start.js $(JS) lib/end.js >lib/pun.js
	rm $(JS)

test: $(TESTJS)	
	#RES  = cat $@ sed -n '/<</,/>>/p' | sed 's/^[ \t]*//'
