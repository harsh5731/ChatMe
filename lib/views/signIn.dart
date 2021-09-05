import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Helper/helperfunctions.dart';
import 'package:flutter_app/services/Auth.dart';
import 'package:flutter_app/services/Database.dart';
import 'package:flutter_app/views/chatRoom.dart';
import 'package:flutter_app/widget/dart/widget.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo ;
  signIn(){

    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0].data()["name"]);
      });
      authService.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
            if(val != null){
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              Navigator.pushReplacement( context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              ));
            }  else {
              setState(() {
                isLoading = false;
              });
            }
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child:
        Container(
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 Form(
                   key: formKey,
                   child: Column(
                     children: [
                          Container(
                           child: TextFormField(
                               validator: (val) {
                                 return RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                     .hasMatch(val)
                                     ? null
                                     : "Enter correct email";
                               },
                               controller: emailTextEditingController,
                               style: simpleTextStyle(),
                               decoration: textFieldDecoration("email")
                           ),
                         ),
                         TextFormField(
                           obscureText: true,
                           validator: (val) {
                             return val.length < 6
                                 ? "Enter Password 6+ characters"
                                 : null;
                           },
                           controller: passwordTextEditingController,
                           style: simpleTextStyle(),
                           decoration: textFieldDecoration("password"),
                         ),
                     ],
                   ),
                 ),
                  SizedBox(height: 8,),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Text("Forgot Password?",style: biggerTextStyle(),),
                  ),
                  SizedBox(height: 8,),
                  GestureDetector(
                    onTap: (){
                      signIn();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding:EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xff007EF4),
                                const Color(0xff2A75BC)
                              ]
                          )
                      ),
                      child: Text("Sign In",style: biggerTextStyle(),),
                    ),
                  ),
                  SizedBox(height: 12,),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding:EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign In with Google",style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                    )),
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account ? ",style:biggerTextStyle(),),
                      GestureDetector(
                        onTap: (){
                          widget.toggleView();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Register Now",style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            decoration: TextDecoration.underline
                          ),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 80,),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
