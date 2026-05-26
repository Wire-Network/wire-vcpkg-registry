vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/Wire-Network/berkeley-softfloat-3
    REF 57c9d941d796d283691e1d0e12faee28bebe226e
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    GENERATOR "Unix Makefiles"
)

vcpkg_cmake_install()

if(IS_DIRECTORY "${CURRENT_PACKAGES_DIR}/debug/include")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
endif()

vcpkg_cmake_config_fixup(CONFIG_PATH "share/${PORT}" PACKAGE_NAME ${PORT})

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/COPYING.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
