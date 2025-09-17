cmake_minimum_required(VERSION 3.11)
cmake_policy(VERSION 3.11)
cmake_policy(SET CMP0077 NEW)

project(CBLC-Verify)

set(CMAKE_CXX_STANDARD 17)

add_subdirectory(vendor)

message(STATUS ${CMAKE_LIBRARY_ARCHITECTURE})

find_package(CouchbaseLite REQUIRED)

# find_package(CouchbaseLite REQUIRED VERSION 4.0.0 PATHS lib/libcblite-4.0.0 NO_DEFAULT_PATH)

set(SOURCE_FILES src/main.cpp)

add_executable(verify ${SOURCE_FILES})

target_link_libraries(
        verify PRIVATE
        cblite
)

if (WIN32)
    target_compile_definitions(verify PRIVATE _DISABLE_CONSTEXPR_MUTEX_CONSTRUCTOR)
endif()
