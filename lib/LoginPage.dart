import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/ChoosePrivelege.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/authService.dart';
import 'package:internship_platform/main.dart';
import 'package:internship_platform/util/dbclient.dart';
import 'package:provider/provider.dart';

import 'model/eventItem.dart';

class LoginSevenPage extends StatefulWidget {
  String email;
  String password;

  @override
  _LoginSevenPageState createState() => _LoginSevenPageState();
}

class _LoginSevenPageState extends State<LoginSevenPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  initState() {
    super.initState();
    isLoading = false;
  }

  checkConnection() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('connected via cellular');
      connected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('connected via wifi');
      connected = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      print('not connected');
      connected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: myColor.myBackground,
      body: Form(
        key: _formKey,
        autovalidate: autoValidate,
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
                        gradient: SweepGradient(colors: [
                      myColor.myDarkGrey,
                      myColor.myWhite,
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
                        gradient: SweepGradient(colors: [
                      myColor.myWhite,
                      myColor.myLightGrey,
                      myColor.myWhite,
                      myColor.myLightGrey,
                    ])),
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
                          Icons.school,
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
                      myColor.myBlack,
                      myColor.myDarkGrey,
                      myColor.myBlack,
                      myColor.myDarkGrey,
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
                          color: myColor.myBlack,
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
                          color: myColor.myBlack,
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
                    color: myColor.myBlack,
                  ),
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
                      await checkConnection();
                      // setState(() {
                      //   isLoading = true;
                      // });

                      _validateInputs();

                      if (!connected) {
                        setState(() {
                          isLoading = false;
                        });
                        Flushbar(
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                          icon: Icon(Icons.error),
                          message: 'Connection Error',
                        )..show(context);
                      }
                      if (isValid && connected) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          // The below code uses to register the User incase he uses another device(i.e user must logged in first)

                          var client = await db.getUser(widget.email);
                          name = widget.email;
                          print("client is $client");
                          if (client.toString() == '[]') {
                            Query checkUser = FirebaseDatabase.instance
                                .reference()
                                .child("Users")
                                .orderByChild("email")
                                .equalTo(widget.email);

                            await checkUser
                                .once()
                                .then((DataSnapshot snapshot) {
                              if (snapshot.value != null) {
                                var KEYS = snapshot.value.keys;
                                var DATA = snapshot.value;
                                for (var individualKey in KEYS) {
                                  identity = DATA[individualKey]['identity'];
                                  fullName = DATA[individualKey]['userName'];
                                  furtherInfo =
                                      DATA[individualKey]['furtherInfo'];
                                }
                              } else {
                                Flushbar(
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.error),
                                  message: "Email Doesn't exist",
                                )..show(context);
                              }
                              setState(() {
                                isLoading=false;
                              });
                            });

                            print(
                                "Identity $identity, FullName $fullName , furtherInfo $furtherInfo");
                            await db.saveUser(User(identity, widget.email, fullName,
                                furtherInfo, "none"));

                          }
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                              email: widget.email,
                              password: widget.password);
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeController()),
                                (Route<dynamic> route) => false,
                          );
                        } catch (Exception) {
                          print(Exception.toString());
                          if (Exception.toString() ==
                              'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null, null)') {
                            Flushbar(
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.red,
                              icon: Icon(Icons.error),
                              message: 'Invalid Password',
                            )..show(context);
                          }
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
                            color: myColor.myDarkGrey,
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
        autoValidate = true;
      });
    }
  }
}
