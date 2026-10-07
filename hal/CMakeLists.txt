cmake_minimum_required(VERSION 3.20)
project(abinstein-hal LANGUAGES C)

add_library(abinstein-hal STATIC src/hal.c)

target_include_directories(abinstein-hal
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_features(abinstein-hal PUBLIC c_std_11)

target_compile_options(abinstein-hal PRIVATE -Wall -Wextra)

message(STATUS "HAL library enabled")
