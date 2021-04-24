#!/usr/bin/env bash

set -euxo pipefail

rm -rf out packaged
if [[ ! -d out ]]; then
    export CC=clang
    export PKG_CONFIG_PATH=out
    meson setup out
fi
meson install -C out --only-changed
