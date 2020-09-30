cmake_minimum_required(VERSION 3.12)
project(example LANGUAGES CXX)

set(nih_cache_path .cache)

include(ExternalProject)
ExternalProject_Add(postgres_src
    PREFIX ${nih_cache_path}
    GIT_REPOSITORY /home/jfreeman/code/postgres
    GIT_TAG master
    CONFIGURE_COMMAND ./configure
    UPDATE_COMMAND ""
    BUILD_COMMAND $(CMAKE_COMMAND) -E env --unset=MAKELEVEL make
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
)

ExternalProject_Get_Property(postgres_src SOURCE_DIR)
ExternalProject_Get_Property(postgres_src BINARY_DIR)
file(MAKE_DIRECTORY ${SOURCE_DIR}/src/include)

set(ep_lib_prefix lib)

add_library(postgres SHARED IMPORTED GLOBAL)
set_target_properties(postgres PROPERTIES
    IMPORTED_LOCATION
      ${BINARY_DIR}/src/interfaces/libpq/${ep_lib_prefix}pq.so
    INTERFACE_INCLUDE_DIRECTORIES
      ${SOURCE_DIR}/src/include)
add_dependencies(postgres postgres_src)

add_executable(main src/main.cpp)
target_link_libraries(main PRIVATE postgres)
