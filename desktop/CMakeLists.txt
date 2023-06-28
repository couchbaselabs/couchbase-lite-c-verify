cmake_minimum_required(VERSION 3.11)
cmake_policy(VERSION 3.11)
cmake_policy(SET CMP0077 NEW)

project(CBLC-Verify)

set(CMAKE_CXX_STANDARD 17)

add_subdirectory(vendor)

message(STATUS ${CMAKE_LIBRARY_ARCHITECTURE})

find_package(CouchbaseLite $ENV{VERSION} REQUIRED)

set(SOURCE_FILES src/main.cpp)

add_executable(verify ${SOURCE_FILES})

target_link_libraries(
        verify PRIVATE
        cblite
)
