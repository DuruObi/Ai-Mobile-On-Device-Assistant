import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const _methodChannel = MethodChannel('oedx.ai/inference');
  static const _eventChannel = EventChannel('oedx.ai/stream');

  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  StreamSubscription? _streamSub;
  String _streamingText = '';

  @override
  void initState() {
    super.initState();
    _streamSub = _eventChannel.receiveBroadcastStream().listen(_onStreamEvent, onError: _onStreamError);
  }

  void _onStreamEvent(dynamic event) {
    setState(() {
      _streamingText = event.toString();
    });
  }

  void _onStreamError(Object error) {
    print('Stream error: $error');
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }

  Future<void> _sendPrompt(String prompt) async {
    if (prompt.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': prompt});
      _streamingText = '';
    });
    _controller.clear();

    try {
      final result = await _methodChannel.invokeMethod('startInference', {'prompt': prompt});
      // result may be immediate ack; streamed tokens come via event channel
      print('Inference ack: $result');
    } on PlatformException catch (e) {
      print('Failed to start inference: $e');
    }
  }

  Widget _buildMessages() {
    final items = List.from(_messages);
    if (_streamingText.isNotEmpty) {
      items.add({'role': 'assistant', 'text': _streamingText});
    }
    return ListView.builder(
      reverse: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final msg = items[items.length - 1 - index];
        final isUser = msg['role'] == 'user';
        return Align(
          alignment: isUser! ? Alignment.centerRight : Alignment.centerLeft,
          child: Card(
            color: isUser ? Colors.indigo[50] : Colors.grey[100],
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(msg['text'] ?? ''),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('AI On-Device Assistant'),
        ),
        body: Column(children: [
          Expanded(child: _buildMessages()),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Type a prompt or press mic'),
                  onSubmitted: _sendPrompt,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _sendPrompt(_controller.text),
              )
            ]),
          )
        ]));
  }
}
