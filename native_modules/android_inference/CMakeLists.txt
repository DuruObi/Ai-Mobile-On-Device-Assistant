cmake_minimum_required(VERSION 3.10)
project(ai_inference_native)

add_library(native-lib SHARED src/main/cpp/native-lib.cpp)

find_library(log-lib log)

target_include_directories(native-lib PRIVATE ${CMAKE_SOURCE_DIR}/src/main/cpp)

target_link_libraries(native-lib ${log-lib})
