import 'package:flutter/material.dart';
import 'package:flutter_app/Helper/helperfunctions.dart';
import 'package:flutter_app/services/Auth.dart';
import 'package:flutter_app/services/Database.dart';
import 'package:flutter_app/views/chatRoom.dart';
import 'package:flutter_app/widget/dart/widget.dart';

class SignUp extends StatefulWidget {

  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading = false;
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  singUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
    });
      authService.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)..then((val){
        print("${val.uid}");
        Map<String, String> userDataMap = {
          "name": userNameTextEditingController.text,
          "email": emailTextEditingController.text
        };
        databaseMethods.addUserInfo(userDataMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(
            userNameTextEditingController.text);
        HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        Navigator.pushReplacement( context, MaterialPageRoute(
          builder: (context) => ChatRoom()
        ));

      });
        
    }  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ):SingleChildScrollView(
        child: Container(
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
                        TextFormField(
                            validator: (val) {
                              return val.isEmpty || val.length < 3
                                  ? "Enter Username 3+ characters"
                                  : null;
                            },
                            controller:userNameTextEditingController ,
                            style: simpleTextStyle(),
                            decoration: textFieldDecoration("username")
                        ),
                        TextFormField(
                            validator: (val) {
                              return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                                  ? null
                                  : "Enter correct email";
                            },
                            controller: emailTextEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldDecoration("email")
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
                    singUp();
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
                    child: Text("Sign Up",style: biggerTextStyle(),),
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
                  child: Text("Sign Up with Google",style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                  )),
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account ? ",style:biggerTextStyle(),),
                       GestureDetector(
                         onTap: (){
                           widget.toggleView();
                         },
                         child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Log In Now",style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline
                          ),),
                      ),
                       ),
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
