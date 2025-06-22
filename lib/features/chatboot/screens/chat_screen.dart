import 'package:dr_fit/core/utils/constants.dart';
import 'package:flutter/material.dart';
import '../service/gemini_service.dart';
import '../widgets/massage_tile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final List<Map<String, String>> _messages = [];

  void sendMessage(String message) async {
    setState(() {
      _messages.add({'role': 'user', 'message': message});
    });

    final reply = await _geminiService.sendMessage(message);

    setState(() {
      _messages.add({'role': 'bot', 'message': reply});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor(context),
      appBar: AppBar(
        title: Text(
          "DR-Fit Bot",
          style: TextStyle(color: textColor(context)),
        ),
        iconTheme: IconThemeData(color: buttonPrimaryColor(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                final msg = _messages[index];
                return MessageTile(
                  message: msg['message']!,
                  isUser: msg['role'] == 'user',
                  textColor: textColor(context),
                  bgColor: secondaryColor(context),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: textColor(context),
                    style: TextStyle(
                      color: textColor(context),
                    ),
                    onSubmitted: (value) {
                      final message = _controller.text.trim();
                      if (message.isNotEmpty) {
                        sendMessage(message);
                        _controller.clear();
                      }
                    },
                    textDirection: TextDirection.rtl,
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'اكتب رسالة...',
                      hintTextDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: buttonPrimaryColor(context),
                  ),
                  onPressed: () {
                    final message = _controller.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(message);
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
