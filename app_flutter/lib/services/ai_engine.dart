import 'dart:async';

class AiEngine {
  /// Simulates local AI inference
  /// Later this will connect to llama.cpp / on-device model
  static Stream<String> generateResponse(String prompt) async* {
    final response = "This is a simulated on-device AI response to: \"$prompt\"";

    for (int i = 0; i < response.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      yield response[i];
    }
  }
}
