#!/usr/bin/env bash

set -euxo pipefail

if [[ ! -d out ]]; then
    export CC=clang
    meson setup out
fi
meson install -C out --only-changed
