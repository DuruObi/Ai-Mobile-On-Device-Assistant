import subprocess
import os

MODEL_DIR = "../models/raw"
OUT_DIR = "../models/gguf"

os.makedirs(OUT_DIR, exist_ok=True)

cmd = [
    "python",
    "../llama.cpp/convert-hf-to-gguf.py",
    MODEL_DIR,
    "--outfile",
    f"{OUT_DIR}/model.gguf"
]

print("Converting to GGUF...")
subprocess.run(cmd)
print("Done.")
