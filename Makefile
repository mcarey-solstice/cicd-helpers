#!/usr/bin/env make

eq = $(and $(findstring x$(1),x$(2)), $(findstring x$(2),x$(1)))

BIN = bin
SRC = src
OUT = out

ARGBASH_BIN = $(BIN)
RST2MAN_BIN = $(BIN)
BATS_BIN = bats

ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif

USE_DOCKER ?= $(if $(or $(call eq,$(detected_OS),Darwin),$(call eq,$(USE_DOCKER),true)),true,false)

ifeq ($(USE_DOCKER),true)
	ARGBASH_BIN = $(BIN)/argbash-run-docker $(BIN)
	RST2MAN_BIN = $(BIN)/rst2man-run-docker $(BIN)
	BATS_BIN = $(BIN)/bats-docker
endif

.PHONY: docs scripts test

docs:
	@$(RST2MAN_BIN)/generate-docs $(SRC)/*.sh

scripts:
	@$(ARGBASH_BIN)/generate-scripts $(SRC)/*.sh

test: scripts
	@$(BATS_BIN) test/*.bats
