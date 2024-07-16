// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatHistoryAdapter extends TypeAdapter<ChatHistory> {
  @override
  final int typeId = 1;

  @override
  ChatHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatHistory().._chats = (fields[0] as List?)?.cast<Chat>();
  }

  @override
  void write(BinaryWriter writer, ChatHistory obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj._chats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 2;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat()
      .._chatsName = fields[0] as String?
      .._messages = (fields[1] as List?)?.cast<Messages>();
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._chatsName)
      ..writeByte(1)
      ..write(obj._messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessagesAdapter extends TypeAdapter<Messages> {
  @override
  final int typeId = 3;

  @override
  Messages read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Messages()
      .._role = fields[0] as String?
      .._message = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, Messages obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._role)
      ..writeByte(1)
      ..write(obj._message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
