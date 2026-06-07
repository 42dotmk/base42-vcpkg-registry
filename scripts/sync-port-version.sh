#!/usr/bin/env bash

set -e

if [ $# -lt 1 ]; then
    echo "Usage:"
    echo "    $(basename "$0") <port-name> [options]"
    echo
    echo "Updates registry version metadata using vcpkg x-add-version"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REGISTRY_ROOT"

"$VCPKG_ROOT/vcpkg" \
    --overlay-ports=ports \
    --x-builtin-ports-root=ports \
    --x-builtin-registry-versions-dir=versions \
    x-add-version "$@"
