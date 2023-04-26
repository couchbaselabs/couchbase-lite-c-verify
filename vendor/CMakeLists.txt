cmake_minimum_required(VERSION 3.11)
cmake_policy(VERSION 3.11)
cmake_policy(SET CMP0077 NEW)

# Mac/apple setup -- must appear before the first "project()" line"
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.12")
if(NOT DEFINED CMAKE_OSX_SYSROOT)
    # Tells Mac builds to use the current SDK's headers & libs, not what's in the OS.
    set(CMAKE_OSX_SYSROOT macosx)
endif()

if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "Setting build type to 'Debug' as none was specified.")
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build." FORCE)
endif()

if(MSVC)
    add_definitions(-DWIN32_LEAN_AND_MEAN -D_WIN32_WINNT=0x0A00)
endif()

project(CBLCVerifyVendor)

include(FetchContent)

if(MSVC)
    FetchContent_Declare(
            zlib
            GIT_REPOSITORY https://github.com/couchbasedeps/zlib
            GIT_TAG master
            GIT_SHALLOW TRUE
    )

    message(STATUS "Fetching zlib...")
    FetchContent_MakeAvailable(zlib)
    if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
        set(ZLIB_LIBRARY ${zlib_BINARY_DIR}/Debug/zlibstaticd.lib)
    else()
        set(ZLIB_LIBRARY ${zlib_BINARY_DIR}/${CMAKE_BUILD_TYPE}/zlibstatic.lib)
    endif()
    set(ZLIB_INCLUDE_DIR ${zlib_SOURCE_DIR})
    target_include_directories(zlibstatic PRIVATE ${zlib_BINARY_DIR})
endif()
