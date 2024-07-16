import 'package:flutter/material.dart';
import 'package:virtual_agent/models/chat_history.dart';
import 'package:virtual_agent/screens/chat_screen.dart';
import 'package:virtual_agent/utill/local_storage.dart';



class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  Future<bool?> _showChatDeleteDialog(int index) async {

    return showDialog<bool?>(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Delete Alert'),
        content: const Text('Are you sure you want to delete the virtual agent?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Delete this agent'),
            onPressed: () {
                LocalStorage.instance.deleteChatByIndex(index);
                Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    });
  }


  Future<String?> _showCreateVirtualAgentDialog() async {
    TextEditingController inputController = TextEditingController();
    String errorMessage = '';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, newState) {
          return AlertDialog(
            title: const Text('Create your virtual agent'),
            content: TextField(
              controller: inputController,
              decoration: InputDecoration(
                errorText: errorMessage,
                  hintText: 'Gave name to your virtual agent'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Start chat with agent'),
                onPressed: () {
                  var message = inputController.text;
                  if (message.isNotEmpty) {
                    LocalStorage.instance.addChat(Chat(chatsName: message, messages: []));
                    Navigator.of(context).pop(message);
                  } else {
                    newState(() {
                      errorMessage = 'Give a name to agent first';
                    });
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ChatHistory chatHistory = LocalStorage.instance.chatHistory;
    return Scaffold(
      appBar: AppBar(
        title: Text("Virtual Agent"),
      ),
      body: Center(
          child: chatHistory.chats!.isEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat),
                  Text('Start chat with virtual agent'),
                ],
              )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      itemCount: chatHistory.chats!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(chat: LocalStorage.instance.getChatByName(chatHistory.chats![index].chatsName!), index: index,)));
                            setState(() {});
                          },
                          title: Text(chatHistory.chats![index].chatsName!),
                          trailing: IconButton(
                            onPressed: () async {
                              final result = await _showChatDeleteDialog(index);
                              if(result != null && result){
                                setState(() {});
                              }

                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      }),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async  {
          final result = await _showCreateVirtualAgentDialog();
          if(result != null && result.isNotEmpty){
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(chat: LocalStorage.instance.getChatByName(result), index: LocalStorage.instance.getIndexByName(result),)));
            setState(() {});
          }
          ;},
        child: Icon(Icons.add),
      ),
    );
  }
}
