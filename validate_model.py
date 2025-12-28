import subprocess

prompt = "Explain what an AI assistant is in one sentence."

cmd = [
    "../llama.cpp/main",
    "-m", "../models/gguf/model-q4.gguf",
    "-p", prompt,
    "-n", "64"
]

print("Running test inference...")
subprocess.run(cmd)
