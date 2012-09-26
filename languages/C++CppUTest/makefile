#Set this to @ to keep the makefile quiet
SILENCE = @

#---- Outputs ----#
COMPONENT_NAME = Untitled

#--- Inputs ----#
PROJECT_HOME_DIR = .

SRC_FILES = Untitled.cpp

TEST_SRC_FILES = AllTests.cpp UntitledTest.cpp 

INCLUDE_DIRS =\
  .\
  $(CPPUTEST_HOME)/include/ \
  $(CPPUTEST_HOME)/include/Platforms/Gcc\

CPPUTEST_WARNINGFLAGS = -Wall -Werror -Wswitch-default  -Wfatal-errors

include $(CPPUTEST_HOME)/build/MakefileWorker.mk
