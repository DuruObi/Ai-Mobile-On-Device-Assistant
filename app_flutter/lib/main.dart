import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const AiAssistantApp());
}

class AiAssistantApp extends StatelessWidget {
  const AiAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI On-Device Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}
