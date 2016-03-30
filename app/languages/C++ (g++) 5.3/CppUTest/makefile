#Set this to @ to keep the makefile quiet
SILENCE = @

#---- Outputs ----#
COMPONENT_NAME = Hiker

#--- Inputs ----#
PROJECT_HOME_DIR = .

SRC_FILES = Hiker.cpp

TEST_SRC_FILES = AllTests.cpp HikerTest.cpp

INCLUDE_DIRS =\
	.\
	$(CPPUTEST_HOME)/include/ \
	$(CPPUTEST_HOME)/include/Platforms/Gcc\

CPPUTEST_WARNINGFLAGS = -Wall -Werror -Wswitch-default -Wfatal-errors
CPPUTEST_CXXFLAGS = -std=c++14
CPPUTEST_CFLAGS = -std=c99

include $(CPPUTEST_HOME)/build/MakefileWorker.mk
