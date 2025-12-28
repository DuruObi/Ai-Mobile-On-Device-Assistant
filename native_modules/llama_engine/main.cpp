#include <iostream>
#include "llama.h"

int main() {
    llama_backend_init();

    llama_model_params model_params = llama_model_default_params();
    llama_model* model = llama_load_model_from_file(
        "../../models/tinyllama.gguf",
        model_params
    );

    if (!model) {
        std::cerr << "Failed to load model\n";
        return 1;
    }

    llama_context_params ctx_params = llama_context_default_params();
    llama_context* ctx = llama_new_context_with_model(model, ctx_params);

    const char* prompt = "Explain what AI is in one sentence.";

    llama_token tokens[128];
    int n_tokens = llama_tokenize(
        model,
        prompt,
        tokens,
        128,
        true
    );

    llama_eval(ctx, tokens, n_tokens, 0);

    std::cout << "AI Response:\n";

    for (int i = 0; i < 50; i++) {
        llama_token token = llama_sample_token_greedy(ctx, nullptr);
        std::cout << llama_token_to_piece(ctx, token);
    }

    llama_free(ctx);
    llama_free_model(model);
    llama_backend_free();

    return 0;
}
