vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH
  URL https://github.com/Wire-Network/bn256.git
  REF a278132c53a1475b09d62351ba1028df36903291
)

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
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}" PACKAGE_NAME ${PORT})

if (EXISTS ${CURRENT_PACKAGES_DIR}/debug/include)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
endif()
# if (EXISTS ${CURRENT_PACKAGES_DIR}/share/${PORT})
#   file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/${PORT}")
# endif()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
