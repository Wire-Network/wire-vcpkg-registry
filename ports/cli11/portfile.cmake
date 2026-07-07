vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO AntelopeIO/CLI11
  REF f325cc66b40cf05e35b457561e0fa1adfedfc973
  SHA512 8a72ee28f011205304fda04e72d52f98718fade3456ba61ccadf23ee62d9d74984684293d5f54cca3aceaabd3513bb85c8816f9a161ad6aed3a2c3008bf4a5ec
  HEAD_REF leap-util-blocklog-refactor
)

vcpkg_cmake_configure(
  SOURCE_PATH ${SOURCE_PATH}
  OPTIONS
  -DCLI11_SINGLE_FILE=ON
  -DCLI11_BUILD_TESTS=OFF
  -DCLI11_BUILD_EXAMPLES=OFF
  -DCLI11_BUILD_DOCS=OFF
)

vcpkg_cmake_install()
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/CLI11")
  vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/CLI11)
elseif(EXISTS "${CURRENT_PACKAGES_DIR}/share/CLI11")
  vcpkg_cmake_config_fixup(CONFIG_PATH share/CLI11)
else()
  message(NOTICE "[CLI11] Could not find expected CMake config path for fixup; package config files may be missing.")
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
