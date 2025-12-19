vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/Wire-Network/eos-vm
    REF b447ceb19bdbcbd92e018a5a9bd31a4eb66dcedb
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

file(INSTALL "${SOURCE_PATH}/LICENSE.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

