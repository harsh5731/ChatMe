import 'package:flutter/material.dart';
import 'package:flutter_app/Helper/Athenticate.dart';
import 'package:flutter_app/Helper/constant.dart';
import 'package:flutter_app/Helper/helperfunctions.dart';
import 'package:flutter_app/services/Auth.dart';
import 'package:flutter_app/services/Database.dart';
import 'package:flutter_app/views/chats.dart';
import 'package:flutter_app/views/search.dart';
import 'package:flutter_app/widget/dart/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context,index){
            return ChatRoomTile(
                 snapshot.data.docs[index].data()["chatRoomId"]
                    .toString().replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
               snapshot.data.docs[index].data()["chatRoomId"]
            );
          }) : Container();
      },
    );
  }
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRoom(Constants.myName).then((value){
      chatRoomsStream = value;
    });
      setState(() {
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatMe'),
        actions: [
          GestureDetector(
            onTap: (){
              authService.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => Search()
          ));
        },
      ),
    );
  }

}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile(this.userName,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black87,
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment:Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(40)
              ) ,
              child: Text("${userName.substring(0,1).toUpperCase()}",
                style: biggerTextStyle(),),
            ),
            SizedBox(width: 8,),
            Text(userName,style: biggerTextStyle(),)
          ],
        ),
      ),
    );
  }
}