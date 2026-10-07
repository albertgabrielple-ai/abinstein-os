cmake_minimum_required(VERSION 3.20)
project(ABINSTEIN_OS VERSION 0.1.0 LANGUAGES C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

message(STATUS "ABINSTEIN OS Build Configuration")

add_subdirectory(hal)
add_subdirectory(network)
add_subdirectory(audio)
add_subdirectory(camera)
add_subdirectory(services)
add_subdirectory(shell)
add_subdirectory(apps)
