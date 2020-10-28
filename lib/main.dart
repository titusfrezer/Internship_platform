import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Employer/ELandingPage.dart';
import 'package:internship_platform/Intern/CategoryPage.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/LoginPage.dart';
import 'package:internship_platform/util/dbclient.dart';

import 'authService.dart';

var z;
var check;
var privelege;
var name;
var username;
FirebaseAuth _firebaseAuth;
FirebaseUser user;
var connectivityResult;


void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'Ethio-Intern',
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: myColor.myPurple),

        ),
        home: HomeController(),
      ),
    );
  }
}

class HomeController extends StatefulWidget {
  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;

    getUser();
  }
  var db = new DatabaseHelper();
  var client;
  var identity;
  var fullName;
  bool connected=false;
  getUser() async {
    user = await _firebaseAuth.currentUser();

  client= await db.getUser(name != null ? name : user.email);

  identity = client[0]['identity'];
  fullName = client[0]['fullName'];
    print("$name is trying to log in and identity is$identity");
  print("user iss $client");


  }



  @override
  Widget build(BuildContext context) {


    final AuthService auth = Provider
        .of(context)
        .auth;

//    return FutureBuilder(
//        future:db.getEvent(name != null ? name : user.email),
//        builder: (context,snasphot){
//
//
//    });
    return StreamBuilder(
      stream: auth.onAuthStateChanged,

      builder: (context, snapshot) {

        if (snapshot.connectionState==ConnectionState.active) {

          final bool signedIn = snapshot.hasData;

          print(signedIn);

          return signedIn?FutureBuilder(
              future:db.getUser(name!=null?name:user.email),
              builder: (context,snapshot){
                if(snapshot.hasData) {
                  print("identity from future is ${snapshot.data[0]['email']}");
                  if (snapshot.data[0]['identity'] == 'Intern') {
                    print("your are intern");
                    return InternCategoryPage(
                        fullName);
                  } else if (snapshot.data[0]['identity'] == 'Employer') {
                    print("your are employer");
                    return LandingPage(name != null ? name : user.email);
                  }
                }
                return SpinKitWave(color: Colors.pink,);
          })
//              ? StreamBuilder(
//            stream: FirebaseDatabase.instance
//                .reference()
//                .child("Users")
//                .orderByChild('email')
//                .equalTo(name != null ? name : user.email)    // if name!=null means the user is not logged in previously(trying to login)
//                .onValue,
//            builder: (context, snapshot) {
//              if (snapshot.data!=null) {
//
//                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
//                print(snapshot.data.snapshot.value);
//
//
//                  if (map.values.toList()[0]['identity'] == 'Intern') {
//
//                    print("your are intern");
//                    return InternCategoryPage(
//                        name != null ? name : user.email);
//                  } else if (map.values.toList()[0]['identity'] ==
//                      'Employer') {
//                    print("your are employer");
//                    return LandingPage(name != null ? name : user.email);
//                  }
//                }
//
//              return SpinKitWave(color: Colors.pink);
//            },
//          )
              : LoginSevenPage();
        }
        return SpinKitWave(color: Colors.pink,);
      },
    );
  }
}

class Provider extends InheritedWidget {
  final AuthService auth;

  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Provider) as Provider);
}
