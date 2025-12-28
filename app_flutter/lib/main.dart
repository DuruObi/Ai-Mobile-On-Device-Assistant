import 'package:flutter/material.dart';
import 'ai_inference.dart';

void main() {
  runApp(AiAssistantApp());
}

class AiAssistantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AI On-Device Assistant",
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  void sendPrompt() async {
    String prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': prompt});
      _controller.clear();
    });

    String response = await AIInference.runModel(prompt);
    setState(() {
      messages.add({'role': 'ai', 'text': response});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Assistant")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(msg['text']!),
                  subtitle: Text(msg['role']!),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Enter prompt..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendPrompt,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
