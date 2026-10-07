cmake_minimum_required(VERSION 3.20)
project(abinstein-shell LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Gui Qml Quick)

qt_add_executable(abinstein_shell main.cpp)
qt_add_resources(abinstein_shell qml.qrc)

target_link_libraries(abinstein_shell PRIVATE Qt6::Gui Qt6::Qml Qt6::Quick)

target_compile_features(abinstein_shell PRIVATE cxx_std_17)

target_include_directories(abinstein_shell PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

message(STATUS "Shell UI enabled")
