vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Wire-Network/wire-ethash
    REF 3d2d896eeae5c35880847eb886999ecc924868db
    SHA512 309439e34bb6787235fae0ef9b2ad81178f9eb8b3c17522fcb1abe21a7f9bac3d09fc9cc29102f69e8f2ad2764586b03c75d915ea0bc5c9e9d7335d0f0771e28
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DETHASH_BUILD_ETHASH=NO
        -DETHASH_TESTING=NO
        -DETHASH_INSTALL_CMAKE_CONFIG=ON
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ethash)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
