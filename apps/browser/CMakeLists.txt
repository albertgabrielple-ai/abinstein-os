cmake_minimum_required(VERSION 3.20)
project(abinstein-browser LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Gui Qml Quick)

qt_add_executable(abinstein_browser main.cpp)
qt_add_resources(abinstein_browser qml.qrc)

target_link_libraries(abinstein_browser PRIVATE Qt6::Gui Qt6::Qml Qt6::Quick)

target_compile_features(abinstein_browser PRIVATE cxx_std_17)

message(STATUS "Browser app enabled")
