#!/usr/bin/env make

BIN = bin
SRC = src
OUT = out

ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif

_BIN = $(BIN)
ifeq ($(detected_OS),Darwin)
	_BIN = $(BIN)/argbash-run-docker $(BIN)
endif

.PHONY: $(OUT) test

$(OUT):
	@$(_BIN)/generate $(ARGBASH) $(SRC)/*.sh
