import 'package:flutter/services.dart';

class AIInference {
  static const platform = MethodChannel('ai_inference');

  static Future<String> runModel(String prompt) async {
    try {
      final String result = await platform.invokeMethod('runModel', {'prompt': prompt});
      return result;
    } on PlatformException catch (e) {
      return "Error: ${e.message}";
    }
  }
}
