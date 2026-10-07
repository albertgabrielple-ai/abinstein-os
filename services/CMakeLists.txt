cmake_minimum_required(VERSION 3.20)
project(abinstein-services LANGUAGES C)

add_executable(abinstein_dbus_service dbus/abinstein_dbus_service.c)

target_include_directories(abinstein_dbus_service PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../hal/include
)
target_link_libraries(abinstein_dbus_service PRIVATE abinstein-hal)

target_compile_features(abinstein_dbus_service PRIVATE c_std_11)

add_executable(abinstein_dbus_server dbus/abinstein_dbus_server.c)
add_executable(abinstein_dbus_client dbus/abinstein_dbus_client.c)

target_compile_features(abinstein_dbus_server PRIVATE c_std_11)
target_compile_features(abinstein_dbus_client PRIVATE c_std_11)

message(STATUS "DBus services enabled")
