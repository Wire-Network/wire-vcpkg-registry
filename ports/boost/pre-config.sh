#! /usr/bin/env bash
set -e

echo "Running pre-config script for boost: '${1}' '${2}'"
sourceDir=${1}
ver=${2}

if [ -z "${sourceDir}" ] || [ -z "${ver}" ] || [ ! -d "${sourceDir}" ]; then
    echo "Error: sourceDir or version not provided or sourceDir does not exist."
    exit 1
fi

cmakeIncludeDir="${sourceDir}/tools/cmake/include"
boostRootCMakeFile="${cmakeIncludeDir}/BoostRoot.cmake"
if [ ! -f "${boostRootCMakeFile}" ]; then
    echo "Error: BoostRoot.cmake not found in ${cmakeIncludeDir}"
    exit 1
fi
# libDir="${sourceDir}/libs/dll"
# libCMakeFile="${libDir}/CMakeLists.txt"
# if [ ! -f "${libCMakeFile}" ]; then
#     echo "Error: CMakeLists.txt not found in ${libDir}"
#     exit 1
# fi

# echo "Modifying ${libCMakeFile} to add include directories"
# sed -i 's|add_library(boost_dll INTERFACE)|add_library(boost_dll INTERFACE)\ntarget_include_directories(boost_dll INTERFACE ${CMAKE_CURRENT_LIST_DIR}/include)|' "${libCMakeFile}"
# sed -i '/find_dependency(boost_numeric_ublas .* EXACT)/d' boost_accumulators-config.cmake
sed -i 's|if("${__boost_lib_incdir}" STREQUAL "${incdir}" OR "${__boost_lib_incdir}" STREQUAL "$<BUILD_INTERFACE:${incdir}>")|if("${__boost_lib_incdir}" STREQUAL "${incdir}" OR "${__boost_lib_incdir}" STREQUAL "$<BUILD_INTERFACE:${incdir}>" OR "${incdir}" IN LIST "${__boost_lib_incdir}")|' ${boostRootCMakeFile}



