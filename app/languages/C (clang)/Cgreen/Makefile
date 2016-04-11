KATA=hiker

all: $(KATA)_tests.so
	cgreen-runner $^

$(KATA)_tests.so: $(KATA)_tests.o $(KATA).o
	$(CC) -shared -o $@ $^ -lcgreen

%.o: %.c
	$(CC) $(CFLAGS) -fPIC -c -o $@ $^
