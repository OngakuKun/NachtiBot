# Define required raylib variables
PROJECT_NAME       ?= nachtibot
PROJECT_VERSION    ?= 0.0.1
BUILD_MODE         ?= DEBUG
SRC_DIR             = src
OBJ_DIR             = bin/obj

MAKEFILE_PARAMS = $(PROJECT_NAME)

CC = gcc
MAKE = make

# Define compiler flags:
#  -O0                  defines optimization level (no optimization, better for debugging)
#  -O1                  defines optimization level
#  -g                   include debug information on compilation
#  -s                   strip unnecessary data from build -> do not use in debug builds
#  -Wall                turns on most, but not all, compiler warnings
#  -std=c99             defines C language mode (standard C from 1999 revision)
#  -std=gnu99           defines C language mode (GNU C from 1999 revision)
#  -Wno-missing-braces  ignore invalid warning (GCC bug 53119)
#  -D_DEFAULT_SOURCE    use with -std=c99 on Linux and PLATFORM_WEB, required for timespec
CFLAGS += -Wall -std=c99 -D_DEFAULT_SOURCE -Wno-missing-braces $(EXTRA)

ifeq ($(BUILD_MODE),DEBUG)
	CFLAGS += -g -O0
else
	CFLAGS += -s -O1
endif

INCLUDE_PATHS = -I./src
LDFLAGS = -ldiscord -lcurl -pthread

SRC = $(wildcard *.c $(foreach fd, $(SRC_DIR), $(fd)/*.c))
OBJS = $(subst src/, $(OBJ_DIR)/,$(SRC:c=o))

all:
	$(MAKE) $(MAKEFILE_PARAMS)

$(PROJECT_NAME): $(OBJS)
	mkdir -p $(@D)
	$(CC) -o bin/$(PROJECT_NAME)$(EXT) $(OBJS) $(CFLAGS) $(INCLUDE_PATHS) $(LDFLAGS) $(LDLIBS) -D$(BUILD_MODE)

$(OBJ_DIR)/nachtibot.o: src/nachtibot.c src/defines.h 
	mkdir -p $(@D)
	$(CC) -o $@ $(CFLAGS) -c $< $(INCLUDE_PATHS) -D$(BUILD_MODE)

clean:
	rm -rf bin
