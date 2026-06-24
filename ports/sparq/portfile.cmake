set(SPARQ_HASH "af9cdcda1c923980de28f221344049937e6bd61124f68c4044cd50b0b7cabddc8e0e45cdd4d02448e4cfce90f48c72d90c1cb47975fc1fca0c6183c7ee9988f4")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO 42dotmk/sparq
    REF 981d02c8e42ce20bb3325703f7dbe5bf8a318057
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
