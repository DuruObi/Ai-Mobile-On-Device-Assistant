#!/bin/bash

MODEL=../models/gguf/model.gguf
OUT=../models/gguf/model-q4.gguf

echo "Quantizing model..."
./llama.cpp/quantize $MODEL $OUT q4_0

echo "Done. Output:"
echo $OUT
