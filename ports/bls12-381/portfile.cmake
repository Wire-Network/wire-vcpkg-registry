vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO Wire-Network/bls12-381
  REF 76a1cd25f7841e03603fe24d7a6142b506b4dd6b
  SHA512 71dc1cd301e409a3ca3c204a653abaee08479732e20b0b10623c4034e1565874bb127e2c022a313f6a39d50615fd338be9c89cddbddfe5203e23f0bc0b3bc0d0
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH "share/${PORT}" PACKAGE_NAME ${PORT})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
