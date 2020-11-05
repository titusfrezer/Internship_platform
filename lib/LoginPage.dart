import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/ChoosePrivelege.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/main.dart';

bool _autoValidate = false;
bool isValid = true;

class LoginSevenPage extends StatefulWidget {
  String email;
  String password;

  @override
  _LoginSevenPageState createState() => _LoginSevenPageState();
}

class _LoginSevenPageState extends State<LoginSevenPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;

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
                        gradient: LinearGradient(colors: [
                      Colors.purple.shade100,
                      Colors.purple.shade100
                    ])),
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
                  validator: (value) {
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(value))
                      return 'Enter Valid Email';
                    else
                      return null;
                  },
                  onSaved: (value) {
                    widget.email = value;
                  },
                  onChanged: (String value) {},
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter valid password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.password = value;
                  },
                  onChanged: (String value) {},
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
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.purple),
                  child: FlatButton(
                    child: isLoading == true
                        ? SpinKitWave(color: myColor.myWhite)
                        : Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      print('Login pressed');
                      _validateInputs();
                      try {
                        name = widget.email;
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: widget.email, password: widget.password);
//                        setState(() {
//                          isLoading=false;
//                        });

//                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeController(widget.email)));
                      } catch (Exception) {
                        print(Exception.toString());
                        if (Exception.toString() ==
                            "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null, null)") {
                          print("true");
                          Flushbar(
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                            icon: Icon(Icons.error),
                            message: 'Connection error',
                          )..show(context);
                        } else if (Exception.toString() ==
                            'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null, null)') {
                          Flushbar(
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                            icon: Icon(Icons.error),
                            message: 'Email Doesnt exist',
                          )..show(context);
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                )),
            SizedBox(
              height: 20,
            ),
//          Center(
//            child: Text("FORGOT PASSWORD ?", style: TextStyle(color:Colors.red,fontSize: 12 ,fontWeight: FontWeight.w700),),
//          ),
//          SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don't have an Account ? ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChoosePrivelege()));
                    },
                    child: Text("Sign Up ",
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            decoration: TextDecoration.underline))),
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
      isValid = true;
    } else {
      isValid = false;
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
