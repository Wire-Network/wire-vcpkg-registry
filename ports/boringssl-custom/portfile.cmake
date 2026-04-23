# Wire-network custom BoringSSL port.
#
# Pinned to an upstream release (google/boringssl, live-at-head model) and
# patched minimally via a cmake-append, not via generate_build_files.py:
#
#   * The `decrepit` target (RIPEMD160, CAST, BLOWFISH) is built by upstream
#     but not installed; we install it because RIPEMD160 is consensus-critical
#     in wire-sysio (fc::crypto::ripemd160).
#   * The crypto target is renamed to libbscrypto.a to avoid filename collision
#     with system libcrypto when other deps (libcurl) link OpenSSL.
#   * Hidden visibility on crypto/ssl/decrepit/fipsmodule keeps symbols out of
#     transitive deps that may dlopen system openssl.
#   * -Werror is silenced; upstream's warnings track bleeding-edge compilers.
#   * Upstream's latent `OpenSSL` cmake package export is removed so consumers
#     go through boringssl-customConfig.cmake, never find_package(OpenSSL).
#
# Historical note: earlier versions of this port cloned AntelopeIO/boringssl
# at commit 15500a39d8 and invoked util/generate_build_files.py (requiring Go
# + Python at build time). Upstream boringssl's own cmake dropped the Go
# requirement for non-FIPS / non-prefix builds, so we consume it directly.

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO google/boringssl
  REF 0.20260413.0
  SHA512 9ad7cc1e31d878fd466ed66e54311a1e1a0777c4766fa8ff9aa824f0522b091d4416c1caaa9f081f602004614191d4f77b4692ee0d04114457998d116d07a6ac
  HEAD_REF main
)

# Append wire-specific target tweaks after upstream's CMakeLists.txt content.
file(READ "${CMAKE_CURRENT_LIST_DIR}/boringssl-customCMakeLists.txt.cmake" BORINGSSL_CUSTOM_CMAKELISTS_TXT)
file(APPEND "${SOURCE_PATH}/CMakeLists.txt" "${BORINGSSL_CUSTOM_CMAKELISTS_TXT}")

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DBUILD_TESTING=OFF
)

vcpkg_cmake_install()

# Strip artifacts wire-sysio does not consume, keeping the package lean and
# satisfying vcpkg post-build policy (no latent OpenSSL package, no duplicate
# debug headers, no empty dirs):
#   * lib/cmake/OpenSSL       - upstream's OpenSSL cmake package; wire-sysio
#                                deliberately avoids find_package(OpenSSL)
#                                (leap commit e2be85a296). boringssl-custom
#                                is the supported entry point.
#   * debug/include           - upstream duplicates headers to debug; vcpkg
#                                wants headers once, under include/.
#   * bin/bssl, tools/        - CLI swiss-army tool not consumed by wire-sysio.
file(REMOVE_RECURSE
  "${CURRENT_PACKAGES_DIR}/lib/cmake"
  "${CURRENT_PACKAGES_DIR}/debug/lib/cmake"
  "${CURRENT_PACKAGES_DIR}/debug/include"
  "${CURRENT_PACKAGES_DIR}/bin"
  "${CURRENT_PACKAGES_DIR}/debug/bin"
  "${CURRENT_PACKAGES_DIR}/tools"
)

configure_file(
  "${CMAKE_CURRENT_LIST_DIR}/boringssl-customConfig.cmake.in"
  "${CURRENT_PACKAGES_DIR}/share/boringssl-custom/boringssl-customConfig.cmake"
  @ONLY
)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
vcpkg_copy_pdbs()
