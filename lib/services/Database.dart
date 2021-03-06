import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((
        e) {
      print(e.toString());
    });
  }

  getUserByUserName(String username) async {
    return await FirebaseFirestore.instance.collection("users").where(
        "name", isEqualTo: username).get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection("users").where(
        "email", isEqualTo: userEmail).get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e);
    });
  }

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }
  getConversationMessages(String chatRoomId)async{
    return  FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time",descending:false)
        .snapshots();
  }
  getChatRoom(String userName)async{
    return FirebaseFirestore.instance.
    collection("ChatRoom")
    .where("users", arrayContains: userName)
    .snapshots();
  }

}