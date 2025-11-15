#!/usr/bin/env bash
set -euo pipefail

OUTPUT="models/model.gguf"
CHECKSUM="REPLACE_WITH_SHA256"

while [[ $# -gt 0 ]]; do
  case $1 in
    --output) OUTPUT="$2"; shift 2;;
    *) shift;;
  esac
done

mkdir -p "$(dirname "$OUTPUT")"

echo "Downloading demo quantized model..."
# Placeholder URL: replace with a real hosted small model (ensure license allows redistribution)
URL="https://example.com/demo-model/model.gguf"
curl -L "$URL" -o "$OUTPUT.part"
mv "$OUTPUT.part" "$OUTPUT"

echo "Verifying checksum..."
# Uncomment when CHECKSUM is set
# echo "${CHECKSUM}  ${OUTPUT}" | sha256sum --check

echo "Model downloaded to $OUTPUT"
