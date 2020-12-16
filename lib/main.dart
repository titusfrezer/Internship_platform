import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Employer/ELandingPage.dart';
import 'package:internship_platform/Intern/CategoryPage.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/LoginPage.dart';
import 'package:internship_platform/Providers/Apply.dart';
import 'package:internship_platform/util/dbclient.dart';
import 'package:provider/provider.dart';
import 'Providers/Job.dart';
import 'authService.dart';


void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<AuthService>(
          create: (_)=>AuthService(),
        ),
        ChangeNotifierProvider<Job>(
          create: (_)=>Job(),
        ),
        ChangeNotifierProvider<Apply>(
          create: (_)=>Apply(),
        ),
      ],
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
  getUser() async {

    user = await firebaseAuth.currentUser();

  }



  @override
  Widget build(BuildContext context) {

    final  auth = Provider.of<AuthService>(context,listen: false);
    return StreamBuilder(
      stream: auth.onAuthStateChanged,

      builder: (context, snapshot) {

              if(snapshot.connectionState == ConnectionState.active) {
                final bool signedIn = snapshot.hasData;

                print("$signedIn has signed In with name $name");

                return signedIn ? FutureBuilder(
                    future: db.getUser(name != null ? name : user.email),
                  // stream: User.equalTo(name!=null?name:user.email).onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // Map map = snapshot.data.snapshot.value;
                        // print("map is ${map.values.toList()}");
                        print("identity from future is ${snapshot
                            .data}");
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

// class Provider extends InheritedWidget {
//   final AuthService auth;
//
//   Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);
//
//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) {
//     return true;
//   }
//
//   static Provider of(BuildContext context) =>
//       (context.inheritFromWidgetOfExactType(Provider) as Provider);
// }
