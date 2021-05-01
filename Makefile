#
# Stub makefile for API project
#

WORKSPACE_ROOT := $(CURDIR)/../..
PROJECT_ROOT := $(CURDIR)

# Proto package for code generation
PROTO_PACKAGE := grpc_helper/api

# Main makefile suite - defs
include $(WORKSPACE_ROOT)/.workspace/main.mk

# Default target is stub
default: stub

# Main makefile suite - rules
include $(WORKSPACE_ROOT)/.workspace/rules.mk
