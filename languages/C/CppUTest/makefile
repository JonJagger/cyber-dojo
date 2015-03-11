#Set this to @ to keep the makefile quiet
SILENCE = @

#---- Outputs ----#
COMPONENT_NAME = untitled

#--- Inputs ----#
PROJECT_HOME_DIR = .

SRC_FILES = untitled.c

TEST_SRC_FILES = untitledTest.cpp AllTests.cpp

INCLUDE_DIRS =\
	.\
	$(CPPUTEST_HOME)/include/ \
	$(CPPUTEST_HOME)/include/Platforms/Gcc\

CPPUTEST_WARNINGFLAGS += -Wall
CPPUTEST_WARNINGFLAGS += -Werror
CPPUTEST_WARNINGFLAGS += -Wswitch-default
CPPUTEST_WARNINGFLAGS += -Wfatal-errors
CPPUTEST_CXXFLAGS +=  -std=c++0x
CPPUTEST_CFLAGS += -std=c99

include $(CPPUTEST_HOME)/build/MakefileWorker.mk
