import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(AiAssistantApp());
}

class AiAssistantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Mobile On-Device Assistant',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: ChatScreen(),
    );
  }
}
