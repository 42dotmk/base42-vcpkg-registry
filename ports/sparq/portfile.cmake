set(SPARQ_HASH "8fa1dfa11667f7336c99c756d6afe5cb132f79b8779f48c9d6ca85596cf16902e7ef05d8c8f0624a287ecd30e8eb338cab36ce9b124cbdff170be197f4e7ddf3")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO 42dotmk/sparq
    REF d1fb6e6ecd00b97f38f129b0fab1ddf2f957ff91
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

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

# Policy bypass for temporary empty include subdirectories
set(VCPKG_POLICY_ALLOW_EMPTY_FOLDERS enabled)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
