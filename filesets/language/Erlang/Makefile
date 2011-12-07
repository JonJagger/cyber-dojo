SOURCES=$(wildcard *.erl)
HEADERS=$(wildcard *.hrl)
OBJECTS=$(SOURCES:%.erl=%.beam)
TESTS=tests

all : $(OBJECTS) test

%.beam : %.erl $(HEADERS)
	@erlc $<

test :
	@mkdir -p $(TESTS)
	@cp -f *_tests.beam $(TESTS)
	@erl -noshell -eval 'eunit:test({dir, "$(TESTS)"})' -s init stop

