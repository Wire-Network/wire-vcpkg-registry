#! /usr/bin/env bash
set -e

# Strips the bare "atomic" link dependency from the installed Boost CMake package configs.

echo "Running post-install script for boost: '${1}'"
installPrefix=${1}

if [ -z "${installPrefix}" ] || [ ! -d "${installPrefix}" ]; then
    echo "Error: installPrefix not provided or does not exist."
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

    # Fix all boost targets: strip bare "atomic" link dep (→ -latomic shared).
    # Boost's CMake build detects that libatomic is needed and adds the raw
    # library name to several targets (uuid, lockfree, etc.).  We link our
    # own static libatomic.a via LIBATOMIC_STATIC, so the bare name just
    # causes an unwanted NEEDED entry for libatomic.so at runtime.
    grep -rl ';atomic"' . 2>/dev/null | while read -r f; do
        perl -pi -e 's/;atomic"/"/g' "$f"
        echo "Removed bare atomic link dep from $f"
    done

    popd

done
