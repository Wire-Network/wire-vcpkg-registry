vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH
  URL https://github.com/Wire-Network/bn256.git
  REF 34c90583fba83f3dc385eab3415e61754aa309fc
  SHA512 34c90583fba83f3dc385eab3415e61754aa309fc
)

file(COPY_FILE "${CMAKE_CURRENT_LIST_DIR}/bn256-CMakeLists.txt.cmake" "${SOURCE_PATH}/CMakeLists.txt")
file(COPY_FILE "${CMAKE_CURRENT_LIST_DIR}/bn256-src-CMakeLists.txt.cmake" "${SOURCE_PATH}/src/CMakeLists.txt")

# vcpkg_execute_required_process(
#   COMMAND sed -i "/third-party/d" CMakeLists.txt
#   WORKING_DIRECTORY ${SOURCE_PATH}
#   LOGNAME bn256-remove-thirdparty
# )

set(EXTRA_OPTIONS)
if (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64" OR CMAKE_SYSTEM_PROCESSOR STREQUAL "AMD64")
    list(APPEND EXTRA_OPTIONS -DBN256_ENABLE_BMI2=ON)
endif()

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
   -DBN256_ENABLE_TEST=OFF
   ${EXTRA_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

if (EXISTS ${CURRENT_PACKAGES_DIR}/debug/include)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
endif()
# if (EXISTS ${CURRENT_PACKAGES_DIR}/share/${PORT})
#   file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/${PORT}")
# endif()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/cmake/${PORT}")
# file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/lib/cmake/${PORT}")
# configure_file(
#   "${CMAKE_CURRENT_LIST_DIR}/bn256Config.cmake.in"
#   "${CURRENT_PACKAGES_DIR}/lib/cmake/${PORT}/bn256Config.cmake"
#   @ONLY
# )


# vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
# PACKAGE_NAME ${PORT}




#file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)