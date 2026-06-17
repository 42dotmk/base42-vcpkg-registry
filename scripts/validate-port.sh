
#!/usr/bin/env bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage:"
    echo "    $(basename "$0") <port-name>"
    exit 1
fi

PORT_DIR="ports/$1"

[ -f "$PORT_DIR/vcpkg.json" ] || {
    echo "Missing vcpkg.json"
    exit 1
}

[ -f "$PORT_DIR/portfile.cmake" ] || {
    echo "Missing portfile.cmake"
    exit 1
}

"$VCPKG_ROOT/vcpkg" format-manifest "$PORT_DIR/vcpkg.json" >/dev/null

echo "Validation successful"
