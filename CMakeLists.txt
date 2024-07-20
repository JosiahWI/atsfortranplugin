cmake_minimum_required(VERSION 3.26)

project(fortran_plugin
  VERSION 0.0.1
  LANGUAGES Fortran
)

add_library(yay SHARED yay.f90)
target_compile_options(yay PRIVATE -Wall -Wextra -pedantic)
