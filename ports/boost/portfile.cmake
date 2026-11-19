set(BOOST_VERSION "1.92.0")

vcpkg_download_distfile(ARCHIVE
  URLS "https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}-cmake.tar.xz"
  FILENAME "boost-${BOOST_VERSION}-cmake.tar.xz"
  SHA512 0e292ac237b5ae52cff6755c67faaae38c76084d771aeda8f1e858c3f8a0f956b0296201a515277c9efa923271646d6ca9037395d1887085f375f8829e3df076
)

vcpkg_extract_source_archive(SOURCE_PATH
  ARCHIVE "${ARCHIVE}"
  PATCHES
    # Boost.Locale upstream f51b58cd34, not yet in a release: CMake 4.5 rejects locale.hpp in the include/boost/locale
    # source_group tree.
    locale-source-group.patch
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
  set(BOOST_ZSTD_TARGET zstd::libzstd_static)
else()
  set(BOOST_ZSTD_TARGET zstd::libzstd_shared)
endif()

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DBUILD_TESTING=OFF
    "-DBOOST_IOSTREAMS_ZSTD_TARGET=${BOOST_ZSTD_TARGET}"
)

vcpkg_cmake_install()

file(INSTALL "${SOURCE_PATH}/LICENSE_1_0.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_copy_pdbs()

# Strips the bare "atomic" link dependency from the installed CMake package configs; see the script.
vcpkg_execute_required_process(
  COMMAND "${CMAKE_CURRENT_LIST_DIR}/post-install-cmake-config.sh" "${CURRENT_PACKAGES_DIR}"
  WORKING_DIRECTORY "${CURRENT_PACKAGES_DIR}"
  LOGNAME post-install-cmake-boost-files
)

file(REMOVE_RECURSE
  "${CURRENT_PACKAGES_DIR}/debug/share"
  "${CURRENT_PACKAGES_DIR}/debug/include"
  "${CURRENT_PACKAGES_DIR}/debug/lib/cmake"
)
