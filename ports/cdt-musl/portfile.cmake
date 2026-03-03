vcpkg_download_distfile(ARCHIVE
    URLS "https://musl.libc.org/releases/musl-1.1.18.tar.gz"
    FILENAME "musl-1.1.18.tar.gz"
    SHA512 4d55c92efe41dfdd9fff6aca5dda76a632a3be60d10e5a7f66a4731d8f7040fb0a20b998965ba4d069b4f8a3527fcd7388e646cb66afc649c4d0cc6c3d358c9c
)

vcpkg_extract_source_archive(SOURCE_PATH ARCHIVE "${ARCHIVE}"
    PATCHES
        001-arch-sysio.patch
        002-wasm-time.patch
        003-wasm-printf.patch
)

# Install patched source tree (cross-compiled later by CDT build system)
file(INSTALL "${SOURCE_PATH}/" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}/src")

# vcpkg requires copyright
file(INSTALL "${SOURCE_PATH}/COPYRIGHT" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

# No pre-built libraries — source-only port
set(VCPKG_POLICY_EMPTY_PACKAGE enabled)