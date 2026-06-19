vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/Wire-Network/eos-vm
    REF 54e3d02eb9d7a4bb4bf41a9e3d5adc925a09c6b0
)

vcpkg_check_features(OUT_FEATURE_OPTIONS OPTIONS
    INVERTED_FEATURES
        softfloat-skip-install ENABLE_SOFTFLOAT_INSTALL
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
    -DENABLE_INSTALL=ON
    -DENABLE_TESTS=OFF
    -DENABLE_SPEC_TESTS=OFF
    ${OPTIONS}
)

vcpkg_cmake_install()

# vcpkg_cmake_config_fixup(CONFIG_PATH "share/${PORT}" PACKAGE_NAME ${PORT})

vcpkg_copy_pdbs()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

file(GLOB_RECURSE debug_contents "${CURRENT_PACKAGES_DIR}/debug/*")
if(NOT debug_contents)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
endif()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
