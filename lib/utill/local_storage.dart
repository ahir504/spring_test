import 'package:hive_flutter/hive_flutter.dart';
import 'package:virtual_agent/models/chat_history.dart';

class LocalStorage{
  static const String _virtualBoxName = 'virtual_agent_box_name';
  static const String _chatHistoryKey = 'virtual_agent_chat_history_key';
  static LocalStorage? _instance;

  LocalStorage._();

  static LocalStorage get instance => _instance ??= LocalStorage._();


  late Box<ChatHistory> virtualAgents;

  late ChatHistory _chatHistory;
  List<Chat>? _chat = [];

  Future<void> initLocalStorage() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ChatHistoryAdapter());
  Hive.registerAdapter(ChatAdapter());
  Hive.registerAdapter(MessagesAdapter());
  virtualAgents = await Hive.openBox(_virtualBoxName);
  _initChatHistoryData();
  }

  void _initChatHistoryData(){
    _chatHistory =  virtualAgents.get(_chatHistoryKey, defaultValue: ChatHistory())!;
    _chat = _chatHistory.chats;
  }


  ChatHistory get chatHistory => _chatHistory;

  void addChat(Chat chat){
    _chat ??= [];
    _chat!.add(chat);
    _chatHistory.chats = _chat;
    _saveChat();
  }


  void saveChatMessages(int index, List<Messages> message){
    _chatHistory.chats![index].messages = message;
    _saveChat();
  }


  void _saveChat(){
    virtualAgents.put(_chatHistoryKey, _chatHistory);
  }


  Chat getChatByName(String chatName) {
    final chat = _chatHistory.chats?.firstWhere((chat) => chat.chatsName == chatName) ?? Chat();
    return chat;
  }

  int getIndexByName(String name){
    return _chatHistory.chats?.indexWhere((chat) => chat.chatsName == name) ?? -1;
  }

  void deleteChatByIndex(int index){
  _chatHistory.chats!.removeAt(index);
  _saveChat();
  }
}