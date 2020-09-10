

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Employer/PostJob.dart';
import 'package:internship_platform/Intern/CategoryPage.dart';

import 'Intern/ApplyforJob.dart';
import 'authService.dart';

var z;
var check;
var privelege;
var name;
var username;
class LoginScreen extends StatelessWidget {
  final dbref= FirebaseDatabase.instance.reference().child('Users').orderByChild('email').equalTo('tio@gmail.com').once();

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) async{
 name = data.name;
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: data.name, password: data.password);
      }
      catch (Exception) {

        if (Exception.toString() ==
            "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)") {
          return 'Connection Error Please try again';
        }


        return "Email doesn't exist";
      }

      return null;
    });
  }

  Future<String> _signupUser(LoginData data) {
    name = data.name;
//  print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
//    if (users.containsKey(data.name)) {
//      return 'Username exists';
//    }
//    if (users[data.name] != data.password) {
//      return 'Password does not match';
//    }
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.name,
          password: data.password,
        );

        //return 'Valid phone Number Required';

      } catch (e) {
        print(e);
        if (e.toString() ==
            "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)") {
          return 'Connection Error Please try again';
        }

        return 'Email already exists';
      }
      return null;
    });
  }

//  Future<String> _recoverPassword(String name) {
//    print('Name: $name');
//    return Future.delayed(loginTime).then((_) {
//      if (!users.containsKey(name)) {
//        return 'Username not exists';
//      }
//      return null;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ECORP',
      logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () async{
        print('hi');
        final userRef = FirebaseDatabase.instance.reference().child('Users');
         userRef.once().then((DataSnapshot snap) {
          var KEYS = snap.value.keys;
          var DATA = snap.value;
          print(DATA);


          for (var individualKey in KEYS) {
            if ((DATA[individualKey]['email']== name) && DATA[individualKey]['identity'] == 'Intern') {
              privelege = "Intern";


            }
            else if((DATA[individualKey]['email'] == name) &&
               DATA[individualKey]['identity'] == 'Employer'){
              privelege = "Employer";
              print("hello");

            }
          }
        });
         if(privelege == 'Intern'){
          await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>InternCategoryPage(name)));
         }else if(privelege =="Employer"){
           await Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context)=>PostJob()));
         }
//      await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>MyApp()));

      },
//      onRecoverPassword: _recoverPassword,
    );
  }
}

void main() =>  runApp( MaterialApp(

    home:  MyApp()));


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
   FirebaseAuth _firebaseAuth;
  FirebaseUser  user;
   void initState() {
     // TODO: implement initState
     super.initState();
     _firebaseAuth = FirebaseAuth.instance;

     getUser();
   }
  getUser() async{

    user = await _firebaseAuth.currentUser();

    Query userRef = FirebaseDatabase.instance.reference().child("Users").orderByChild('email').equalTo(user.email);
    await userRef.once().then((DataSnapshot snap){
//      username = snap.value[snap.value.keys]['userName'];
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      print(DATA);


      for (var individualKey in KEYS) {
        username = DATA[individualKey]['userName'];
        print(username);
      }

    });
    print('logged user email is $user');
  }
  @override

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;

    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context,  snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          print(signedIn);
          print(name);
          user!=null?print("is user null = ${user.email}"):print('no user');
          return signedIn? StreamBuilder(
            stream:FirebaseDatabase.instance.reference().child("Users").orderByChild('email').equalTo(user!=null?user.email:name).onValue,
            builder: (context,snapshot){
              if(snapshot.hasData){

                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                print("map is ${map.values.toList()}");
                if( map.values.toList()[0]['identity'] == 'Intern'){
//                  auth.signOut();
                print("your are intern");
                  return InternCategoryPage(username);
                }else if(map.values.toList()[0]['identity']== 'Employer'){
                  print("your are employer");
                  return PostJob();
                }

              }
              return SpinKitWave(color: Colors.pink,);
            },
          ):LoginScreen();

        }else if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitWave(color: Colors.pink,);
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
