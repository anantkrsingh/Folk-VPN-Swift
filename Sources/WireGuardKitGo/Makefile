# SPDX-License-Identifier: MIT
#
# Copyright (C) 2018-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.

# These are generally passed to us by xcode, but we set working defaults for standalone compilation too.
ARCHS ?= x86_64 arm64
PLATFORM_NAME ?= macosx
SDKROOT ?= $(shell xcrun --sdk $(PLATFORM_NAME) --show-sdk-path)
CONFIGURATION_BUILD_DIR ?= $(CURDIR)/out
CONFIGURATION_TEMP_DIR ?= $(CURDIR)/.tmp

export PATH := $(PATH):/usr/local/bin:/opt/homebrew/bin
export CC ?= clang
LIPO ?= lipo
DESTDIR ?= $(CONFIGURATION_BUILD_DIR)
BUILDDIR ?= $(CONFIGURATION_TEMP_DIR)/wireguard-go-bridge

CFLAGS_PREFIX := $(if $(DEPLOYMENT_TARGET_CLANG_FLAG_NAME),-$(DEPLOYMENT_TARGET_CLANG_FLAG_NAME)=$($(DEPLOYMENT_TARGET_CLANG_ENV_NAME)),) -isysroot $(SDKROOT) -arch
GOARCH_arm64 := arm64
GOARCH_x86_64 := amd64
GOOS_macosx := darwin
GOOS_iphoneos := ios

build: $(DESTDIR)/libwg-go.a
version-header: $(DESTDIR)/wireguard-go-version.h

# Xcode's CONFIGURATION_TEMP_DIR (and hence BUILDDIR/GOROOT) can contain
# spaces (e.g. when the product name has a space, as in "Folk VPN.build").
# GNU Make splits target/prerequisite names on unescaped whitespace, so
# such paths must be escaped when used as targets/prerequisites; the
# unescaped, quoted variables are still used inside recipes for the shell.
nullstring :=
space := $(nullstring) $(nullstring)
escape_spaces = $(subst $(space),\$(space),$1)

REAL_GOROOT := $(shell go env GOROOT 2>/dev/null)
export GOROOT := $(BUILDDIR)/goroot
GOROOT_MK := $(call escape_spaces,$(GOROOT))
BUILDDIR_MK := $(call escape_spaces,$(BUILDDIR))

$(GOROOT_MK)/.prepared:
	[ -n "$(REAL_GOROOT)" ]
	mkdir -p "$(GOROOT)"
	rsync -a --delete --exclude=pkg/obj/go-build "$(REAL_GOROOT)/" "$(GOROOT)/"
	cat goruntime-*.diff | patch -p1 -f -N -r- -d "$(GOROOT)"
	touch "$(GOROOT)/.prepared"

define libwg-go-a
$(BUILDDIR_MK)/libwg-go-$(1).a: export CGO_ENABLED := 1
$(BUILDDIR_MK)/libwg-go-$(1).a: export CGO_CFLAGS := $(CFLAGS_PREFIX) $(ARCH)
$(BUILDDIR_MK)/libwg-go-$(1).a: export CGO_LDFLAGS := $(CFLAGS_PREFIX) $(ARCH)
$(BUILDDIR_MK)/libwg-go-$(1).a: export GOOS := $(GOOS_$(PLATFORM_NAME))
$(BUILDDIR_MK)/libwg-go-$(1).a: export GOARCH := $(GOARCH_$(1))
$(BUILDDIR_MK)/libwg-go-$(1).a: $(GOROOT_MK)/.prepared go.mod
	go build -ldflags=-s\ -w -trimpath -v -o "$(BUILDDIR)/libwg-go-$(1).a" -buildmode c-archive
	rm -f "$(BUILDDIR)/libwg-go-$(1).h"
endef
$(foreach ARCH,$(ARCHS),$(eval $(call libwg-go-a,$(ARCH))))

$(DESTDIR)/wireguard-go-version.h: go.mod $(GOROOT_MK)/.prepared
	 sed -E -n 's/.*golang\.zx2c4\.com\/wireguard +v[0-9.]+-[0-9]+-([0-9a-f]{8})[0-9a-f]{4}.*/#define WIREGUARD_GO_VERSION "\1"/p' "$<" > "$@"

$(DESTDIR)/libwg-go.a: $(foreach ARCH,$(ARCHS),$(BUILDDIR_MK)/libwg-go-$(ARCH).a)
	@mkdir -vp "$(DESTDIR)"
	$(LIPO) -create -output "$@" $(foreach ARCH,$(ARCHS),"$(BUILDDIR)/libwg-go-$(ARCH).a")

clean:
	rm -rf "$(BUILDDIR)" "$(DESTDIR)/libwg-go.a" "$(DESTDIR)/wireguard-go-version.h"

install: build

.PHONY: clean build version-header install
