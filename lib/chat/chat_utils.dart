import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpmc/authentication/Utils.dart';

class Chat {
  final _db = Firestore.instance;

  Future sendMessage(String recipient, String message) async {

    String chatID = getChatId(respository.user.uid, recipient);


    await _db.collection("Chats").add({
      "id": chatID,
      "sender": respository.user.uid,
      "senderName": respository.user.displayName,
      "recipient": recipient,
      "message": message,
      "sent_at": DateTime.now(),
      "read": false,
    });

    await _db.collection("chat_list").document(chatID).setData({
        "first_user" : recipient,
        "second_user" : respository.user.uid
      }, merge: true);
  }

  String getChatId(String sender, String recipient) {
    String chatID;
    if (sender.hashCode > recipient.hashCode) {
      chatID = sender + recipient;
    } else {
      chatID = recipient + sender;
    }

    return chatID;
  }

  bool checkIfChatIdExists(String me, String chatID) {
    bool isMine = false;

    if (chatID.contains(me)) {
      isMine = true;
    } else {
      isMine = false;
    }

    return isMine;
  }
}

Chat chat = Chat();

class ChatUser {
  final String id, name, photoUrl;
  final bool hasNotificatins, isOnline;
  ChatUser(
      {this.hasNotificatins = false,
      this.isOnline = false,
      @required this.id,
      @required this.name,
      this.photoUrl = ""});
}
