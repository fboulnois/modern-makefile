### Settings: Modify the parameters below to configure your project
###============================================================================

# program name and source directories
BIN_NAME :=
SRC_DIRS :=

# general program flags
MY_CFLAGS = -O3 -fstack-protector-strong -fpie
MY_LIBS   =
WARNINGS  = -pedantic -Wall -Wextra

# language specific options
CFLAGS    = -std=c11
CXXFLAGS  = -std=c++11

# compiler defaults
CC  = gcc
CXX = g++

### Advanced: You should generally not need to modify anything below this line
###============================================================================

## If no source dirs are specified use files in current working directory
##-----------------------------------------------------------------------------
ifeq ($(SRC_DIRS),)
	SRC_DIRS := .
endif

## Check if the software being built is a shared library
##-----------------------------------------------------------------------------
BIN_SHARED := $(filter -shared,$(MY_CFLAGS))

## If no program name is specified use current directory name or a.out
##-----------------------------------------------------------------------------
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
ifeq ($(BIN_NAME),)
	BIN_NAME := $(lastword $(subst /,$(SPACE),$(subst $(SPACE),_,$(CURDIR))))
	ifneq ($(BIN_SHARED),)
		BIN_NAME := $(addsuffix .so,$(addprefix lib,$(BIN_NAME)))
	endif
endif
ifeq ($(BIN_NAME),)
	BIN_NAME := a.out
endif

## Find source files in specified directories and name objects and dependencies
##-----------------------------------------------------------------------------
SRC_EXTS  := .c .C .cc .cp .cpp .CPP .cxx .c++
SRC_FILES := $(foreach dir,$(SRC_DIRS),$(wildcard $(addprefix $(dir)/*,$(SRC_EXTS))))
SRC_CXX   := $(filter-out %.c,$(SRC_FILES))
OBJECTS   := $(addsuffix .o,$(basename $(SRC_FILES)))
DEPENDS   := $(OBJECTS:.o=.d)

## Compiler and linker related actions
##-----------------------------------------------------------------------------
CMP_C := $(CC) $(MY_CFLAGS) $(CFLAGS) $(CPPFLAGS) $(WARNINGS) -MD
LNK_C := $(CC) $(MY_CFLAGS) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)

CMP_CXX := $(CXX) $(MY_CFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(WARNINGS) -MD
LNK_CXX := $(CXX) $(MY_CFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

## Clear built-in .SUFFIXES and set .PHONY targets
##-----------------------------------------------------------------------------
.SUFFIXES:

.PHONY: all clean objects

## Debug values of makefile variables, to check use 'make print-VARNAME'
##-----------------------------------------------------------------------------
print-%: ; @echo $*=$($*)

## Build everything
##-----------------------------------------------------------------------------
all: $(BIN_NAME)

## Clean up build
##-----------------------------------------------------------------------------
clean:
	$(RM) $(DEPENDS) $(OBJECTS) $(BIN_NAME) $(BIN_NAME).exe

## Build object files
##-----------------------------------------------------------------------------
objects: $(OBJECTS)

%.o: %.c
	$(CMP_C) -c $< -o $@

%.o: %.C
	$(CMP_CXX) -c $< -o $@

%.o: %.cc
	$(CMP_CXX) -c $< -o $@

%.o: %.cp
	$(CMP_CXX) -c $< -o $@

%.o: %.cpp
	$(CMP_CXX) -c $< -o $@

%.o: %.CPP
	$(CMP_CXX) -c $< -o $@

%.o: %.cxx
	$(CMP_CXX) -c $< -o $@

%.o: %.c++
	$(CMP_CXX) -c $< -o $@

## Build dependencies
##-----------------------------------------------------------------------------
-include $(DEPENDS)

## Build executable
##-----------------------------------------------------------------------------
$(BIN_NAME): $(OBJECTS)
ifeq ($(SRC_CXX),)
	$(LNK_C) $(OBJECTS) $(MY_LIBS) -o $@
else
	$(LNK_CXX) $(OBJECTS) $(MY_LIBS) -o $@
endif
ifeq ($(BIN_SHARED),)
	@echo To execute program, type ./$@
else
	@echo To link shared library, use $@
endif
