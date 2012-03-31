lib/%.js: src/%.coffee
	coffee -b -c -o lib/ $<

SRC = $(wildcard src/*.coffee)
JS  = $(subst src/,lib/,$(SRC:.coffee=.js))

all: $(JS)
