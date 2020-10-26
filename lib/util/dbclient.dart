import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:internship_platform/model/eventItem.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  final String tablename= "internPlatform";
  final String identity ="identity";
  final String email="email";
  final String fullName= "fullName";
  final String furtherInfo = "furtherInfo";

  Future<Database> get db async{
    if(_db != null){

      return _db;
    }
    _db = await initDb();
//    print("Database created");
    return _db;
  }
  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,"internPlatform.db");

    var ourDb = await openDatabase(path,version: 1,onCreate: _onCreate);
    return ourDb;
  }
  // not to a create a lot of objects when we want
  // to invoke database helper class
//  final String tableUser ="userTable";
//  final String eventName="EventName";
//  final String eventDate = "Date";
//  final String eventDiscription = "EventDiscription";
//  final String eventTime = "EventTime";
//  final String Guest = "Guest";
  void _onCreate(Database db, int version) async { // creating our table
    await db.execute(
        "CREATE TABLE $tablename (id INTEGER PRIMARY KEY,$identity TEXT,$email TEXT,$fullName TEXT,$furtherInfo TEXT)"

    );

    print('All table created');


  }

  // Insertion
  Future <int> saveUser(User user) async{

    var dbClient = await db;
    // print(user);
    int res = await dbClient.insert("$tablename",user.toMap());
    print(res);
    return res;

  }

Future getUser(String email)async{

    print("email is $email");
    var dbClient = await db;

//    var allResult = await dbClient.rawQuery("SELECT * FROM $tablename");
//    print(allResult);
    var result = await dbClient.rawQuery("SELECT * FROM $tablename WHERE email = '$email' ");
    print("${result[0]['identity']} is result" );


return result;
  }
// Get users
  }