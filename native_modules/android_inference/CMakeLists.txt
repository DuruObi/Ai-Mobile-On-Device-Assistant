cmake_minimum_required(VERSION 3.10)
project(ai_inference_native)

add_library(native-lib SHARED src/main/cpp/native-lib.cpp)

# On Android, link against the log library
# On other platforms, make it optional (not found = skip)
find_library(log-lib log)

target_include_directories(native-lib PRIVATE ${CMAKE_SOURCE_DIR}/src/main/cpp)

if(log-lib)
    target_link_libraries(native-lib ${log-lib})
else()
    message(STATUS "log library not found (expected on non-Android platforms)")
endif()
