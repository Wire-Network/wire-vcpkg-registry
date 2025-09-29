set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

# Set the C and C++ compilers to clang-18
# Ensure these are valid paths on the build machine
set(CMAKE_C_COMPILER "/usr/bin/clang-18")
set(CMAKE_CXX_COMPILER "/usr/bin/clang++-18")
set(VCPKG_C_COMPILER "/usr/bin/clang-18")
set(VCPKG_CXX_COMPILER "/usr/bin/clang++-18")

set(VCPKG_CMAKE_SYSTEM_NAME Linux)
