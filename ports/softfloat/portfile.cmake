vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Wire-Network/berkeley-softfloat-3
    REF 57c9d941d796d283691e1d0e12faee28bebe226e
    SHA512 acddc3f448c8c60e7f2c2cac54735c1da439528490b38090c80d0acad989e68b7ed44ca29fe353847acdf5b168683516670bef6b8b5051e5237f80ea4ce2979d
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
