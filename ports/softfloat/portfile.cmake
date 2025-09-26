message(NOTICE "VCPKG-SOFTFLOAT")
message(STATUS "VCPKG-SOFTFLOAT")
vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/Wire-Network/berkeley-softfloat-3
    REF 703e38d9c24902b20ff7740eb19ab54b0d2e101e
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    GENERATOR "Unix Makefiles"
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH "share/${PORT}" PACKAGE_NAME ${PORT})

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/COPYING.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

