KATA=Hiker

CFLAGS=-I/usr/local/include

all: $(KATA)Tests.so
	cgreen-runner $^

$(KATA)Tests.so: $(KATA)Tests.o $(KATA).o
	$(CXX) -shared -o $@ $^ -lcgreen++

%.o: %.cpp
	$(CXX) $(CFLAGS) -fPIC -c -o $@ $^
