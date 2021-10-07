SHELL 	   := $(shell which bash)

NO_COLOR   :=\033[0m
OK_COLOR   :=\033[32;01m
ERR_COLOR  :=\033[31;01m
WARN_COLOR :=\033[36;01m
ATTN_COLOR :=\033[33;01m

# Github action env variables used by build container
GITHUB_SHA          ?= $(shell git rev-parse HEAD 2>/dev/null)
GITHUB_WORKSPACE    := /github/workspace

# build action input parameters
SOURCE_PATH   := src
TARGET_PATH   := build
TARGET_FILE   := bundle.tar.gz
REVISION      := $(GITHUB_SHA)
BUILD_OPTIONS := 
VERBOSE       := false

.PHONY: build
build:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@docker run \
	-ti \
	--rm \
	--entrypoint "/app/build.sh" \
	-v $(PWD):$(GITHUB_WORKSPACE) \
	-e GITHUB_WORKSPACE=$(GITHUB_WORKSPACE) \
	-e GITHUB_SHA=$(GITHUB_SHA) \
	-e INPUT_SOURCE_PATH=$(SOURCE_PATH) \
	-e INPUT_TARGET_PATH=$(TARGET_PATH) \
	-e INPUT_TARGET_FILE=$(TARGET_FILE) \
	-e INPUT_REVISION=$(REVISION) \
	-e INPUT_BUILD_OPTIONS=$(BUILD_OPTIONS) \
	-e INPUT_VERBOSE=$(VERBOSE) \
	ghcr.io/aserto-dev/aserto-one:action-v2 > /dev/null
