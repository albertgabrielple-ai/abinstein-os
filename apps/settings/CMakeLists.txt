cmake_minimum_required(VERSION 3.20)
project(abinstein-settings LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Gui Qml Quick)

qt_add_executable(abinstein_settings main.cpp)
qt_add_resources(abinstein_settings qml.qrc)

target_link_libraries(abinstein_settings PRIVATE Qt6::Gui Qt6::Qml Qt6::Quick)

target_compile_features(abinstein_settings PRIVATE cxx_std_17)

message(STATUS "Settings app enabled")
