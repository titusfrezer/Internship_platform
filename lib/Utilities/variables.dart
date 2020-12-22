import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_platform/Utilities/dbclient.dart';

class myColor {
  static final Color myBlack = Color(0xff090808);
  static final Color myWhite = Colors.white;
  static final Color myLightGrey = Color(0xffA4A4A6);
  static final Color myDarkGrey = Color(0xff6B6C70);
  //static final Color myBackground = Color(0xffe1e2e2);
  static final Color myBackground = Color(0xff1A1A2E);
  static final Color myGreen = Color(0xff418883C);
  static final Color myYellow = Color(0xffF6A435);
  static final Color myBlue = Color(0xff3024AE);

}

bool autoValidate = false;
bool isOpened = true;
bool isObscure = true;
bool isLoading = false;
bool isValid = true;
int radioValue = 0;
bool connected = false;
var connectivityResult;
var imageurl;
var url;
File image;
var z;
var privelege;
var name;
var username;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseUser user;
var db = new DatabaseHelper();
var fullName;
var furtherInfo;
var identity;
var email;
var companyName;
var client;
var isfileChosen = false;
var file = null;