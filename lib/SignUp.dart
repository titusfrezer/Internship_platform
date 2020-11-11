import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/ChoosePrivelege.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/LoginPage.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/util/dbclient.dart';

import 'main.dart';
import 'model/eventItem.dart';

bool _autoValidate = false;
bool isValid;
DatabaseReference userRef =
FirebaseDatabase.instance.reference().child("Users");
class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
  String privelege;
  String fullName;
  String furtherInfo;
  String email;
  String password;
  SignUpPage(this.privelege,this.fullName,this.furtherInfo);
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  void initState(){
    super.initState();
    print(widget.fullName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipper2(),
                  child: Container(
                    child: Column(),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.purple.shade100,  Colors.purple.shade100])),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper3(),
                  child: Container(
                    child: Column(),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.purple, Colors.purple])),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper1(),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Icon(
                          Icons.work,
                          color: Colors.white,
                          size: 60,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Ethio-Intern",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 30),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: SweepGradient(colors: [
                          myColor.myDarkGrey,
                          myColor.myBackground,
                          myColor.myDarkGrey,
                          myColor.myBlack,
                          myColor.myBlack,
                          myColor.myDarkGrey
                        ])),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  validator: (value){
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(value))
                      return 'Enter Valid Email';
                    else
                      return null;
                  },
                    onSaved: (value){
                    widget.email = value;
                    print('emailis ${widget.email}');
                    },

                  onChanged: (String value){},
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.email,
                          color: Colors.purple,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  obscureText: isObscure,
                  validator: (value){
                    if(value.length<8){
                      return 'password must be at least 8 characters';
                    }
                    return null;
                  },
                  onSaved: (value){
                  },

                  onChanged: (String value){
                   widget.password=value;
                  },
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
                          color: Colors.purple,
                        ),
                      ),
                      suffixIcon: isObscure
                          ? IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isObscure = false;
                          });
                        },
                      )
                          : IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isObscure = true;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  obscureText: isObscure,
                  validator: (value){
                    if(value.toString()!=widget.password){
                      print("password is ${widget.password} and confirm is $value");
                      return 'Confirm Password';
                    }
                    return null;
                  },
                  onSaved: (value){
                    if(value!=widget.password){
                      print('wrong password');
                    }
                  },
                  onChanged: (String value){},
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: "Confirm Password",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
                          color: Colors.purple,
                        ),
                      ),
                      suffixIcon: isObscure
                          ? IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isObscure = false;
                          });
                        },
                      )
                          : IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isObscure = true;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.purple),
                  child: FlatButton(
                    child: isLoading?SpinKitWave(color: Colors.white):Text(
                      "SignUp",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () async{

                      print('email is ${widget.email} and full name is ${widget.fullName}');
                      _validateInputs();
                      if(isValid) {

                        setState(() {
                          isLoading=true;
                        });
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: widget.email,
                            password: widget.password,
                          );


                          var db = new DatabaseHelper();

                          // Add user
                         await db.saveUser(User(widget.privelege,widget.email,widget.fullName,widget.furtherInfo,"none"));
                          await userRef
                              .push()
                              .set(<dynamic, dynamic>{
                            'email': widget.email,
                            'identity': widget.privelege,
                            'userName': widget.fullName,
                            'furtherInfo':widget.furtherInfo,  // fieldofStudy for intern and location for comapany

                              });
                          name = widget.email;
                          fullName = widget.fullName;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                HomeController()),
                                (Route<dynamic> route) => false,
                          );
                        } catch (e) {
                          print(e);
                          if (e.toString() ==
                              "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null, null)") {
                            Flushbar(duration: Duration(seconds: 3),
                              backgroundColor: Colors.red,
                              icon: Icon(Icons.error),
                              message: 'Connection error',
                            )
                              ..show(context);
                          }

                          else if (e.toString() ==
                              "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)") {
                            Flushbar(duration: Duration(seconds: 3),
                              backgroundColor: Colors.red,
                              icon: Icon(Icons.error),
                              message: 'Email already exists',
                            )
                              ..show(context);
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
                )),
            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Already have an Account ? ", style: TextStyle(color:Colors.black,fontSize: 16 ,fontWeight: FontWeight.normal),),
                GestureDetector(

                    onTap: (){
Navigator.of(context).push(MaterialPageRoute(builder:(context)=>LoginSevenPage()));
                    },
                    child: Text("Login ", style: TextStyle(color:Colors.purple, fontWeight: FontWeight.w500,fontSize: 16, decoration: TextDecoration.underline ))),

              ],
            )
          ],
        ),
      ),
    );

  }
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      isValid= true;
    } else {
      isValid=false;
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}

