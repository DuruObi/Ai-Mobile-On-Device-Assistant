from huggingface_hub import snapshot_download

MODEL_ID = "TheBloke/TinyLlama-1.1B-Chat-v1.0"

def main():
    print("Downloading model...")
    snapshot_download(
        repo_id=MODEL_ID,
        local_dir="./models/raw",
        local_dir_use_symlinks=False
    )
    print("Download complete.")

if __name__ == "__main__":
    main()
