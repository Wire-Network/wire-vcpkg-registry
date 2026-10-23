vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Wire-Network/berkeley-softfloat-3
    REF e9bb379fe5692c6cbb68fe077cfa7965dc497175
    SHA512 0642a9e428fcfd137ec91d9dfde5b1b54102939c2841fb541777ea9ff0ccd0596e6c76cc1a6d0a9ece8f78d5160035fc7742e2aa7abf8fb33d0128485bc35b9b
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    GENERATOR "Unix Makefiles"
    OPTIONS
        -DBUILD_TESTING=OFF
)

vcpkg_cmake_install()

if(IS_DIRECTORY "${CURRENT_PACKAGES_DIR}/debug/include")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
endif()

vcpkg_cmake_config_fixup(CONFIG_PATH "share/${PORT}" PACKAGE_NAME ${PORT})

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/COPYING.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
