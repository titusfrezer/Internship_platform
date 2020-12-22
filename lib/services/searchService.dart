import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchService with ChangeNotifier{

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(String value) {
    print("hello $value");
    notifyListeners();
    if (value.isEmpty) {

        queryResultSet = [];
        tempSearchStore = [];
        notifyListeners();
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    print(capitalizedValue);
    if (queryResultSet.isEmpty && value.toString().length == 1) {
      print("true");
      Query query = FirebaseDatabase.instance
          .reference()
          .child('posts')
          .orderByChild('firstLetter')
          .equalTo(value.substring(0, 1).toUpperCase());
      query.once().then((DataSnapshot snapshot) {
        var KEYS = snapshot.value.keys;
        var DATA = snapshot.value;
        for (var individualKey in KEYS) {
          if (DATA[individualKey]['status'] == 'open') {
            // only store in the searched list if job not closed
            print("${DATA[individualKey]['jobTitle']} is the value");

            queryResultSet.add(DATA[individualKey]);
          } else {
            print('Job closed');
          }
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['jobTitle'].toString().startsWith(capitalizedValue)) {
          print("hooray");

            tempSearchStore.add(element);
       notifyListeners();
        }
      });
    }
  }
}