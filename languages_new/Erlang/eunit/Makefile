
SOURCES=$(wildcard *.erl)
HEADERS=$(wildcard *.hrl)
OBJECTS=$(SOURCES:%.erl=%.beam)
TESTS=tests

all : clean $(OBJECTS) test

clean :
	@rm -f *.beam

%.beam : %.erl $(HEADERS)
	@erlc $<

test :
	@rm -rf $(TESTS)
	@mkdir -p $(TESTS)
	@cp -f *_tests.beam $(TESTS)
	@erl -noshell -eval 'eunit:test({dir, "$(TESTS)"})' -s init stop