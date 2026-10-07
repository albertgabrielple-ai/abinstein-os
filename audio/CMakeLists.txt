cmake_minimum_required(VERSION 3.20)
project(abinstein-audio LANGUAGES C)

add_library(abinstein-audio STATIC src/audio_service.c)

target_include_directories(abinstein-audio
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_features(abinstein-audio PUBLIC c_std_11)

target_compile_options(abinstein-audio PRIVATE -Wall -Wextra)

message(STATUS "Audio service enabled")
