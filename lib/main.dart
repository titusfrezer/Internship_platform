import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Employer/ELandingPage.dart';
import 'package:internship_platform/Intern/CategoryPage.dart';
import 'package:internship_platform/LoginPage.dart';
import 'package:internship_platform/util/dbclient.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'authService.dart';


void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
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
    firebaseAuth = FirebaseAuth.instance;

    getUser();
  }
  var db = new DatabaseHelper();
  var client;
  var identity;
  bool connected=false;
  getUser() async {
    user = await firebaseAuth.currentUser();
if(user!=null || name!=null) {
  client = await db.getUser(name != null ? name : user.email);

  identity = client[0]['identity'];
  fullName = client[0]['fullName'];
  print("$name is trying to log in and identity is$identity");
  print("user iss $client");
}
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


              if(snapshot.connectionState == ConnectionState.active) {
                final bool signedIn = snapshot.hasData;

                print("$signedIn has signed In");

                return signedIn ? FutureBuilder(
                    future: db.getUser(name != null ? name : user.email),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print("identity from future is ${snapshot
                            .data[0]['identity']}");
                        if (snapshot.data[0]['identity'] == 'Intern') {
                          print("your are intern");
                          return InternCategoryPage(
                              name != null ? name : snapshot.data[0]['email']);
                        } else if (snapshot.data[0]['identity'] == 'Employer') {
                          print("your are employer");
                          return LandingPage(
                              name != null ? name : snapshot.data[0]['email']);
                        }
                      }
                      return SpinKitWave(color: Colors.purple,);
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
              }else{
              return SpinKitWave(color: Colors.purple,);}

//        }
//
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
