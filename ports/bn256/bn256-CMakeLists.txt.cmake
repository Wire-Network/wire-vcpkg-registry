cmake_minimum_required(VERSION 3.12)

project(bn256 VERSION 2.0.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_compile_options(-Wall)

option(BN256_ENABLE_TEST "BN256_ENABLE_TEST" ON)
option(BN256_ENABLE_BMI2 "enable bmi2 intruction set, only for supported x86-64 targets" OFF)

add_subdirectory(src)

if(BN256_ENABLE_TEST)
   enable_testing()
   add_subdirectory(test)
endif()

include(GNUInstallDirs)
set_property(TARGET bn256 PROPERTY VERSION ${bn256_VERSION})
set_property(TARGET bn256 PROPERTY SOVERSION ${bn256_VERSION_MAJOR})
set_property(TARGET bn256 PROPERTY INTERFACE_bn256_MAJOR_VERSION ${bn256_VERSION_MAJOR})
set_property(TARGET bn256 APPEND PROPERTY COMPATIBLE_INTERFACE_STRING bn256_MAJOR_VERSION)
