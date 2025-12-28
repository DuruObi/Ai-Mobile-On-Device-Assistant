#!/bin/bash

cd native_modules/llama_engine

mkdir -p build
cd build

cmake ..
make -j$(nproc)
