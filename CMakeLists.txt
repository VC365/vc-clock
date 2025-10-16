cmake_minimum_required(VERSION 3.31 )
project(vc-clock C)

set(CMAKE_C_STANDARD 11)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK2 REQUIRED gtk+-2.0)
pkg_check_modules(RSVG REQUIRED librsvg-2.0)

include_directories(
        ${GTK2_INCLUDE_DIRS}
        ${RSVG_INCLUDE_DIRS}
)

link_directories(
        ${GTK2_LIBRARY_DIRS}
        ${RSVG_LIBRARY_DIRS}
)

add_executable(vc-clock src/main.c)


target_link_libraries(vc-clock m
        ${GTK2_LIBRARIES}
        ${RSVG_LIBRARIES}
)

target_compile_features(vc-clock PRIVATE c_std_11)
