cmake_minimum_required(VERSION 3.20)
project(abinstein-network LANGUAGES C)

add_library(abinstein-network STATIC src/network_service.c)

target_include_directories(abinstein-network
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_features(abinstein-network PUBLIC c_std_11)

target_compile_options(abinstein-network PRIVATE -Wall -Wextra)

message(STATUS "Network service enabled")
