set(SPARQ_HASH "5822366b22d11a072eade207fc259778e6a80f36e10f858cf2b826e3c32a4a16f8c3143c44fa0237702ae19e0fbbc5b5e8ef369bab81f57215ddd932ef4ee2cd")

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
