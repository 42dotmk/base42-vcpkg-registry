set(SPARQ_HASH "fbb2dd6f9402f4e098abdaebd1035923003b1d9c9f10fc4b29bb80c6cdaab4704d6ec03d1f55a1be8737578a6f146ec144483543dcbc3345c1f4f608f4118a89")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO 42dotmk/sparq
    REF 4e17461ad5264563abd68d9a7a06f9700437877d
    SHA512 ${SPARQ_HASH}
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(
    PACKAGE_NAME sparq
    CONFIG_PATH lib/cmake/sparq
)

vcpkg_copy_pdbs()

# Policy bypass for missing LICENSE file
set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)

# Policy bypass for temporary empty include subdirectories
set(VCPKG_POLICY_ALLOW_EMPTY_FOLDERS enabled)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
