if(VCPKG_HOST_IS_WINDOWS)
    set(SPARQ_HASH "0d362dbdceea5338be1ff40040123a784cdeb5688762b02a4bc94d636daccb4175c8d46ed6b3727038206969a90b0135860901702c2692f861c7a745240e9cfc")
else()
    set(SPARQ_HASH "af9cdcda1c923980de28f221344049937e6bd61124f68c4044cd50b0b7cabddc8e0e45cdd4d02448e4cfce90f48c72d90c1cb47975fc1fca0c6183c7ee9988f4")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO 42dotmk/sparq
    REF 0e182e969323d4b66b5322bc753b941d1bae9e5a
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
