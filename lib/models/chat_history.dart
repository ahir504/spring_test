import 'package:hive/hive.dart';

part 'chat_history.g.dart';

@HiveType(typeId: 1)
class ChatHistory{
  @HiveField(0)
  List<Chat>? _chats;

  ChatHistory({List<Chat>? chats}) {
   _chats = chats;
  }

  List<Chat>? get chats => _chats ?? [];

  set chats(List<Chat>? value){
    _chats = value;
  }



}


@HiveType(typeId: 2)
class Chat{

  @HiveField(0)
  String? _chatsName;
  @HiveField(1)
  List<Messages>? _messages;

  Chat({String? chatsName, List<Messages>? messages}) {
  _chatsName = chatsName;
  _messages = _messages;
  }

  List<Messages>? get messages => _messages ?? [];

  set messages(List<Messages>? value) {
    _messages = value;
  }

  String? get chatsName => _chatsName ?? "";

  set chatsName(String? value) {
    _chatsName = value;
  }

  Map<String, dynamic> toJson(){
    final map = <String, dynamic>{};
    map['chat_name'] =_chatsName;
    if(_messages != null){
      map['messages'] = _messages?.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

@HiveType(typeId: 3)
class Messages{

  @HiveField(0)
  String? _role;
  @HiveField(1)
  String? _message;


  Messages({String? role, String? message}){
    _role = role;
    _message = message;
  }

  String? get role => _role ?? "";

  set role(String? value) {
    _role = value;
  }

  String? get message => _message ?? "";

  set message(String? value) {
    _message = value;
  }

  Map<String, dynamic> toJson(){
    final map = <String, dynamic>{};
    map['role'] = _role;
    map['content'] = _message;
    return map;
  }


}