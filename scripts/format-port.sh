#!/usr/bin/env bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage:"
    echo "    $(basename "$0") <port-name>"
    exit 1
fi

manifest="ports/$1/vcpkg.json"

if [ ! -f "$manifest" ]; then
    echo "Port manifest not found: $manifest"
    exit 1
fi

"$VCPKG_ROOT/vcpkg" format-manifest "$manifest"
