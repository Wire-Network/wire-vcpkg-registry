vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Wire-Network/eos-vm
    REF f760622f17925dd8f895ca1fb13483db66e8702a
    PATCHES clang-libcxx.patch
    SHA512 fc2ba478926853f292b5667646d05d0a54e106364a462b35001e6a51e91ab32ec0e5ea79c87608979a31a69f9d5596646b59973c93f9e9b435425f10f77964b0
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
