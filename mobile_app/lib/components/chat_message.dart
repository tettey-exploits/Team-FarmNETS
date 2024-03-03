import 'package:chat_package/models/chat_message.dart';
//import 'package:chat_package/models/media/chat_media.dart';
//import 'package:chat_package/models/media/media_type.dart';
import 'package:flutter/material.dart';

class TryChat {
  final BoxDecoration myChatInputFieldDecoration = BoxDecoration(
      color: Colors.grey, borderRadius: BorderRadius.circular(20.0));

  List<ChatMessage> messages = [
  ChatMessage(isSender: false, text: 'Akwaaba. Me din de Abena. meyɛ dɛn na aboa wo'),
  ];
}
