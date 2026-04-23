
# ----------------------------------------------------------------------------
# Wire-network additions appended to upstream BoringSSL CMakeLists.txt.
# See portfile.cmake for rationale.
# ----------------------------------------------------------------------------

# Upstream's -Werror is tuned for its own CI matrix and trips newer compilers.
# Applied to every upstream-defined library target we may transitively pull in.
target_compile_options(fipsmodule PRIVATE -Wno-error)
target_compile_options(crypto     PRIVATE -Wno-error)
target_compile_options(decrepit   PRIVATE -Wno-error)
target_compile_options(ssl        PRIVATE -Wno-error)
target_compile_options(pki        PRIVATE -Wno-error)

# Hidden visibility: when a transitive dep (notably libcurl built with openssl
# support) gets linked into the same binary, this prevents our symbols from
# being preempted by a system libcrypto that happens to be loaded first.
set_target_properties(fipsmodule PROPERTIES C_VISIBILITY_PRESET hidden)
set_target_properties(crypto     PROPERTIES C_VISIBILITY_PRESET hidden)
set_target_properties(decrepit   PROPERTIES C_VISIBILITY_PRESET hidden)
set_target_properties(ssl        PROPERTIES C_VISIBILITY_PRESET hidden)

# Rename the crypto archive to libbscrypto.a. Ssl is left as libssl.a; no
# widespread system-libssl.a collision in practice, and the consumer-side
# Config.cmake accepts either spelling.
set_target_properties(crypto PROPERTIES PREFIX libbs)

# Decrepit is defined by upstream (add_library(decrepit ...)) but not listed
# in upstream's install(TARGETS crypto ssl ...). Install it so find_library()
# in boringssl-customConfig.cmake can locate libdecrepit.a.
install(TARGETS decrepit
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
