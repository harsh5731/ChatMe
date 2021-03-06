//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Helper/constant.dart';
//import 'package:flutter_app/Helper/constant.dart';
import 'package:flutter_app/services/Database.dart';
//import 'package:flutter_app/Helper/constant.dart';
import 'package:flutter_app/widget/dart/widget.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  Chat(this.chatRoomId);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

DatabaseMethods databaseMethods = new DatabaseMethods();
TextEditingController messageController = new TextEditingController();
Stream chatMessagesStream;


Widget chatMessageList(){
  return StreamBuilder(
    stream: chatMessagesStream,
    builder: (context,snapshot){
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context,index){
          return MessageTile(snapshot.data.docs[index].data()["message"],
              snapshot.data.docs[index].data()["sendBy"]==Constants.myName);
        }): Container();
    },
  );
}
sendMessage(){
  if(messageController.text.isNotEmpty){
    Map<String,dynamic> messageMap = {
      "message":messageController.text,
      "sendBy": Constants.myName,
      "time" : DateTime.now().millisecondsSinceEpoch
    };
    databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
    messageController.text = "";
  }
}

@override
  void initState() {
  databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: appBarMain(context),
      body: Container(
              child: Stack(
                children: [
                  chatMessageList(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        color:  Color(0x54FFFFFF),
                        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                        child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                  decoration: InputDecoration(
                                      hintText: "Write a Message ...",
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 16,
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  sendMessage();
                                },
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              const Color(0x36FFFFFF),
                                              const Color(0x0FFFFFFF)
                                            ],
                                            begin: FractionalOffset.topLeft,
                                            end: FractionalOffset.bottomRight
                                        ),
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    padding: EdgeInsets.all(12),
                                    child: Image.asset("assets/images/send.png",
                                      height: 25, width: 25,)),
                              ),
                            ]),
                      ),
                  ),
                ],
              ),
            ),
      );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message , this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        margin: isSendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
          ),
          borderRadius:  isSendByMe
              ? BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23))
              : BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)),
        ),
          child: Text(message,style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontFamily:'OverpassRegular',
              fontWeight: FontWeight.w300)),
      ),
    );
  }
}
