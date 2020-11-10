import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_platform/util/dbclient.dart';

class myColor{
  static final  Color myBlack = Color(0xff090808);
  static final  Color myWhite = Colors.white;
  static final  Color myLightGrey = Color(0xffA4A4A6);
  static final  Color myDarkGrey = Color(0xff6B6C70);
  static final Color myBackground = Color(0xffE1E1E2);



}
bool isOpened = true;
bool isLoading=false;
var z;
var check;
var privelege;
var name;
var username;
FirebaseAuth firebaseAuth;
FirebaseUser user;
var db = new DatabaseHelper();
var fullName;
var furtherInfo;
var connectivityResult;
var identity;
