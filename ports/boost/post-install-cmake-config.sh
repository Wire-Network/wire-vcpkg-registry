#! /usr/bin/env bash
set -e

# This cleanup script removes the references to
# `numeric_ublas` from the `accumulators` component

echo "Running post-install script for boost: '${1}' '${2}'"
installPrefix=${1}
ver=${2}

if [ -z "${installPrefix}" ] || [ -z "${ver}" ] || [ ! -d "${installPrefix}" ]; then
    echo "Error: installPrefix or version not provided or installPrefix does not exist."
    exit 1
fi

cmakeLibDir="${installPrefix}/lib/cmake"
cmakeDebugLibDir="${installPrefix}/debug/lib/cmake"

for libDir in "${cmakeLibDir}" "${cmakeDebugLibDir}"; do
    echo "CMake config dir: ${libDir}"
    if [ ! -d "${libDir}" ]; then
        echo "Warning: CMake config dir does not exist: ${libDir}"
        continue
    fi

    pushd "${libDir}"

    # Remove numeric_ublas references from accumulators config
    cd "boost_accumulators-${ver}"
    sed -i '/find_dependency(boost_numeric_ublas .* EXACT)/d' boost_accumulators-config.cmake
    cd "${libDir}"

    # Fix iostreams: replace zstd::libzstd_shared with zstd::libzstd_static
    # Boost 1.89.0 CMake build incorrectly hardcodes the shared zstd target,
    # but we build with VCPKG_LIBRARY_LINKAGE=static so only the static target exists
    iostreamsTargetsDir="boost_iostreams-${ver}-static"
    if [ -d "${iostreamsTargetsDir}" ]; then
        sed -i 's/zstd::libzstd_shared/zstd::libzstd_static/g' "${iostreamsTargetsDir}/boost_iostreams-targets.cmake"
        echo "Fixed zstd target reference in ${iostreamsTargetsDir}/boost_iostreams-targets.cmake"
    fi

    # Fix all boost targets: strip bare "atomic" link dep (→ -latomic shared).
    # Boost's CMake build detects that libatomic is needed and adds the raw
    # library name to several targets (uuid, lockfree, etc.).  We link our
    # own static libatomic.a via LIBATOMIC_STATIC, so the bare name just
    # causes an unwanted NEEDED entry for libatomic.so at runtime.
    grep -rl ';atomic"' . 2>/dev/null | while read -r f; do
        sed -i 's/;atomic"/"/g' "$f"
        echo "Removed bare atomic link dep from $f"
    done

    popd

done

