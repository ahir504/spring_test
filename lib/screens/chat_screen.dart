import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_agent/utill/local_storage.dart';
import 'dart:convert';

import '../models/chat_history.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  final int index;

  const ChatScreen({required this.index ,required this.chat, super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

   Chat? chat;
  List<Messages> _messages = [];
  bool _isLoading = false;


  void _jumpToLast(){
  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      _isLoading = true;
      _messages.add(Messages(role: 'user', message: message));
      chat!.messages = _messages;
      LocalStorage.instance.saveChatMessages(widget.index, _messages);
      _jumpToLast();
    });

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer <YOUR_API_KEY>'
    };

    var request = http.Request('POST', Uri.parse('https://api.openai.com/v1/chat/completions'));

    request.body = json.encode({
      "model": "gpt-3.5-turbo",
      "messages": chat!.toJson()['messages']
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      var assistantMessage = jsonResponse['choices'][0]['message']['content'];

      setState(() {
        _messages.add(Messages(role: 'assistant', message:  assistantMessage));
        chat!.messages = _messages;
        LocalStorage.instance.saveChatMessages(widget.index, _messages);
        _jumpToLast();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      print(jsonResponse);
    }
  }

  @override
  void initState() {
    chat = widget.chat;
    _messages = chat!.messages ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
       canPop: true,
      onPopInvoked: (_){
         LocalStorage.instance.saveChatMessages(widget.index, _messages);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(widget.chat.chatsName!)),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: chat!.messages!.length,
                itemBuilder: (context, index) {
                  var message = chat!.messages![index];
                  return ListTile(
                    title: Align(
                      alignment: message.role == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: message.role == 'user'
                              ? Colors.blue[100]
                              : Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(message.message ?? ''),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      var message = _controller.text;
                      if (message.isNotEmpty) {
                        _controller.clear();
                        _sendMessage(message);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
