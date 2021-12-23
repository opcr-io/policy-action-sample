SHELL 	   := $(shell which bash)

NO_COLOR   :=\033[0m
OK_COLOR   :=\033[32;01m
ERR_COLOR  :=\033[31;01m
WARN_COLOR :=\033[36;01m
ATTN_COLOR :=\033[33;01m

# Github action env variables used by build container
GITHUB_SHA      ?= $(shell git rev-parse HEAD 2>/dev/null)
GITHUB_WORKSPACE:= /github/workspace
CONTAINER		:= ghcr.io/opcr-io/policy:0.1
ORG				:= datadude

# build action input parameters
INPUT_SRC		:= src
INPUT_TAG		:= ${ORG}/test-policy:latest
INPUT_REVISION  := ${GITHUB_SHA}
INPUT_USERNAME	:= ${USER}
INPUT_PASSWORD	= ${GIT_TOKEN}
INPUT_SERVER	:= opcr.io
INPUT_VERBOSITY	:= error

.PHONY: all
all: clean login build push logout

.PHONY: login
login:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@docker run -ti \
	-e INPUT_USERNAME=${INPUT_USERNAME} \
	-e INPUT_PASSWORD=${INPUT_PASSWORD} \
	-e INPUT_SERVER=${INPUT_SERVER} \
	-e INPUT_VERBOSITY=${INPUT_VERBOSITY} \
	-e GITHUB_WORKSPACE=${GITHUB_WORKSPACE} \
	-v ${PWD}:${GITHUB_WORKSPACE} \
	--entrypoint=/app/login.sh \
	--platform=linux/amd64 \
	${CONTAINER}

.PHONY: build
build:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@docker run -ti \
	-e INPUT_SRC=${INPUT_SRC} \
	-e INPUT_TAG=${INPUT_TAG} \
	-e INPUT_REVISION=${INPUT_REVISION} \
	-e INPUT_VERBOSITY=${INPUT_VERBOSITY} \
	-e GITHUB_WORKSPACE=${GITHUB_WORKSPACE} \
	-v ${PWD}:${GITHUB_WORKSPACE} \
	--entrypoint=/app/build.sh \
	--platform=linux/amd64 \
	${CONTAINER}

.PHONY: push
push:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@docker run -ti \
	-e INPUT_TAGS=${INPUT_TAG} \
	-e INPUT_VERBOSITY=${INPUT_VERBOSITY} \
	-e GITHUB_WORKSPACE=${GITHUB_WORKSPACE} \
	-v ${PWD}:${GITHUB_WORKSPACE} \
	--entrypoint=/app/push.sh \
	--platform=linux/amd64 \
	${CONTAINER}

.PHONY: logout
logout:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	@docker run -ti \
	-e INPUT_SERVER=${INPUT_SERVER} \
	-e INPUT_VERBOSITY=${INPUT_VERBOSITY} \
	-e GITHUB_WORKSPACE=${GITHUB_WORKSPACE} \
	-v ${PWD}:${GITHUB_WORKSPACE} \
	--entrypoint=/app/logout.sh \
	--platform=linux/amd64 \
	${CONTAINER}

.PHONY: clean
clean:
	@echo -e "$(ATTN_COLOR)==> $@ $(NO_COLOR)"
	rm -rf ${PWD}/_policy
