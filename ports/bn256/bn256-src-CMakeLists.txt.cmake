include(CheckCXXSourceCompiles)

check_cxx_source_compiles("
int main() {
  using T=_ExtInt(512);
  return 0;
}
"   HAVE_EXTINT)


add_library(
   bn256
   bn256.cpp
   random_255.cpp)

target_include_directories(bn256 PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../include>"
   "$<INSTALL_INTERFACE:include>")


message(NOTICE "BN256_HAVE_EXTINT=${HAVE_EXTINT}")
if(HAVE_EXTINT)
   message(NOTICE "Configuring BN256_HAVE_EXTINT")
   target_compile_definitions(bn256 PUBLIC BN256_HAS_EXTINT)
endif()

if(BN256_ENABLE_BMI2)
   target_compile_options(bn256 PUBLIC -mbmi2)
   target_compile_definitions(bn256 PRIVATE BN256_HAS_BMI2)
endif()

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../include/ DESTINATION include)

install(TARGETS bn256 EXPORT bn256-config
   RUNTIME DESTINATION bin
   ARCHIVE DESTINATION lib
   LIBRARY DESTINATION lib
   INCLUDES DESTINATION include
   PUBLIC_HEADER DESTINATION include
)

install(
   EXPORT bn256-config

   FILE bn256-config.cmake
   NAMESPACE bn256::
   DESTINATION share/bn256
)
