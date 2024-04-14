import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final Timestamp timeCreate;
  final String id;

  Message(this.message, this.timeCreate, this.id);

  factory Message.fromJason(jasonData) {
    return Message(
        jasonData['message'], jasonData['timeCreate'], jasonData['senderId']);
  }
}
