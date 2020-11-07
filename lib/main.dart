import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Employer/ELandingPage.dart';
import 'package:internship_platform/Intern/CategoryPage.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/LoginPage.dart';
import 'package:internship_platform/util/dbclient.dart';
import 'authService.dart';


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
         primarySwatch: Colors.purple,


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
                    : LoginSevenPage();
              }else{
              return SpinKitWave(color: Colors.purple,);}


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
