import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Helper/constant.dart';
import 'package:flutter_app/services/Database.dart';
import 'package:flutter_app/views/chats.dart';
import 'package:flutter_app/widget/dart/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}
//String _myName;

class _SearchState extends State<Search> {

  QuerySnapshot searchResultSnapshot;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  bool isLoading = false;
  bool haveUserSearched = false;


  Widget searchList(){
    return searchResultSnapshot != null ? ListView.builder(
        itemCount: searchResultSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index) {
          return searchTile(
              userName:  searchResultSnapshot.docs[index].data()["name"],
              userEmail: searchResultSnapshot.docs[index].data()["email"]
          );
        }) : Container();
  }
  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .getUserByUserName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  sendMessages(String userName){
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [Constants.myName, userName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatRoomId" : chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId,chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(
              chatRoomId)
      ));
    }else{
      print("you can not send message to yourself");
    }
  }
  Widget searchTile({String userName,String userEmail}){
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,style: biggerTextStyle(),),
              Text(userEmail,style: biggerTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              sendMessages(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Text(
                "Message",style: biggerTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color:  Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
        controller: searchEditingController,
          style: TextStyle(
            color: Colors.white
          ),
          decoration: InputDecoration(
                hintText: "search username ...",
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
             initiateSearch();
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
                child: Image.asset("assets/images/search_white.png",
                  height: 25, width: 25,)),
         ),
      ]),
            ),
            searchList()
      ],
    ),
    ),
    );
  }
}

