vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO 42dotmk/sparq
    REF 0e182e969323d4b66b5322bc753b941d1bae9e5a
    SHA512 0d362dbdceea5338be1ff40040123a784cdeb5688762b02a4bc94d636daccb4175c8d46ed6b3727038206969a90b0135860901702c2692f861c7a745240e9cfc
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

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
