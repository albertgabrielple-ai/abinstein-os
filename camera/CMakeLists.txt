cmake_minimum_required(VERSION 3.20)
project(abinstein-camera LANGUAGES C)

add_library(abinstein-camera STATIC src/camera_service.c)

target_include_directories(abinstein-camera
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_features(abinstein-camera PUBLIC c_std_11)

target_compile_options(abinstein-camera PRIVATE -Wall -Wextra)

message(STATUS "Camera service enabled")
