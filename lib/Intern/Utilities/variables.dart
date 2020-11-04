import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_platform/util/dbclient.dart';

class myColor{
  static final  Color myBlack = Color(0xff485063);
  static final  Color myWhite = Colors.white;
  static final  Color myGrey = Color(0xff9398B0);
  static final  Color myPurple = Color(0xff745481);

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

