set(VCPKG_LIBRARY_LINKAGE static)

set(BOOST_VERSION "1.89.0")
set(BOOST_ARCHIVE_NAME "boost-${BOOST_VERSION}-cmake")

cmake_policy(SET CMP0116 OLD) #suppress warning about Boost::xxxx targets not being imported

vcpkg_download_distfile(BOOST_SOURCE_ARCHIVE
  URLS "https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/${BOOST_ARCHIVE_NAME}.tar.xz"
  FILENAME "${BOOST_ARCHIVE_NAME}.tar.xz"
  SHA512 4fb7f6fde92762305aad8754d7643cd918dd1f3f67e104e9ab385b18c73178d72a17321354eb203b790b6702f2cf6d725a5d6e2dfbc63b1e35f9eb59fb42ece9
)

vcpkg_extract_source_archive_ex(
  OUT_SOURCE_PATH SOURCE_PATH
  ARCHIVE "${BOOST_SOURCE_ARCHIVE}"
  REF "${BOOST_ARCHIVE_NAME}"
  PATCHES asio-future-libcxx.patch
)

configure_file(${CMAKE_CURRENT_LIST_DIR}/boost_dll-CMakeLists.txt ${SOURCE_PATH}/libs/dll/CMakeLists.txt COPYONLY)
# vcpkg_execute_required_process(
#   COMMAND ${CMAKE_CURRENT_LIST_DIR}/pre-config.sh ${SOURCE_PATH} ${BOOST_VERSION}
#   WORKING_DIRECTORY ${CURRENT_PACKAGES_DIR}
#   LOGNAME pre-config-boost-files
# )

# NOW CONFIGURE AND INSTALL USING CMAKE
vcpkg_cmake_configure(
  SOURCE_PATH ${SOURCE_PATH}
  OPTIONS
  -DBoost_DEBUG=ON
  -DBoost_VERBOSE=ON
  -DBOOST_DLL_USE_STD_FS=ON
  -DBoost_USE_MULTITHREADED=ON
  -DBoost_USE_STATIC_LIBS=ON
  -DBOOST_EXCLUDE_LIBRARIES="mysql;cobalt"
  -DBUILD_TESTING=OFF
)

# INSTALL
vcpkg_cmake_install()

# PERFORM CONFIG FIXUP TO RELOCATE AND ADJUST BOOST CMAKE PACKAGE CONFIGURATION FILES.
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/boost")
  vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/boost)
elseif(EXISTS "${CURRENT_PACKAGES_DIR}/share/boost")
  vcpkg_cmake_config_fixup(CONFIG_PATH share/boost)
else()
  message(NOTICE "[boost] Could not find expected CMake config path for fixup; package config files may be missing.")
endif()

# COPY LICENSE
file(INSTALL ${SOURCE_PATH}/LICENSE_1_0.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

# COPY PDB FILES
vcpkg_copy_pdbs()

# POST INSTALL CMAKE CONFIG FILES
# This cleanup script removes the references to
# `numeric_ublas` from the `accumulators` component
vcpkg_execute_required_process(
  COMMAND ${CMAKE_CURRENT_LIST_DIR}/post-install-cmake-config.sh ${CURRENT_PACKAGES_DIR} ${BOOST_VERSION}
  WORKING_DIRECTORY ${CURRENT_PACKAGES_DIR}
  LOGNAME post-install-cmake-boost-files
)

if(EXISTS ${CURRENT_PACKAGES_DIR}/debug/share)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
endif()
if(EXISTS ${CURRENT_PACKAGES_DIR}/debug/include)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
endif()
if(EXISTS ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)
endif()
