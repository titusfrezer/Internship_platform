import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Employer/MyProfile.dart';
import 'package:internship_platform/Employer/PostedByCategory.dart';
import 'package:internship_platform/Employer/mypostedJobs.dart';
import 'package:internship_platform/Employer/sentApplications.dart';
import 'package:internship_platform/Utilities/variables.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../LoginPage.dart';
import 'package:internship_platform/services/authService.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
  String name;

  LandingPage(this.name);
}

class _LandingPageState extends State<LandingPage> {
  DatabaseReference catRef =
      FirebaseDatabase.instance.reference().child('Categories');
  var counter = 0;
  FirebaseMessaging _messaging = FirebaseMessaging();
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    getUser();

  }

  getUser() async {
    user = await firebaseAuth.currentUser();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('connected via cellular');
      connected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('connected via wifi');
      connected = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      print('not connected');
      connected = false;
    }

    // _messaging.subscribeToTopic('NewApplication');
    _messaging.configure(onMessage: (Map<String, dynamic> message) {
      print("message is ${message["data"]['SentTo']}");
      Flushbar(
        icon: Icon(
          Icons.new_releases_outlined,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
        title: "Update",
        message: "New Job Posted",
        duration: Duration(seconds: 3),
      )..show(context);
      return null;
    });
    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .orderByChild("email")
        .equalTo(user.email)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        imageurl = values['url'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final check = Provider.of<AuthService>(context,listen: false);
    return Scaffold(
        backgroundColor: myColor.myBackground,
        drawer: Drawer(
          child: Container(
            color: myColor.myBackground,
            child: ListView(
              children: <Widget>[
                ClipRect(
                  child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ExactAssetImage('image/internship.jpg'),
                              fit: BoxFit.cover)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 3.9, sigmaX: 3.9),
                        child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(color: Colors.transparent),
                          accountName: CircleAvatar(
                              backgroundColor: myColor.myBlack,
                              foregroundColor: myColor.myWhite,
                              child: Text(
                                widget.name.substring(0, 1).toUpperCase(),
                                style: GoogleFonts.delius(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                          accountEmail: Text(
                            widget.name,
                            style: TextStyle(
                                color: myColor.myBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      )),
                ),
                InkWell(
                  child: ListTile(
                    leading: Icon(Icons.person, color: myColor.myBlack),
                    title: Text('My Profile'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MyProfile(widget.name, imageurl)));
                  },
                ),
                InkWell(
                  child: ListTile(
                    leading: Icon(Icons.assignment_ind, color: myColor.myBlack),
                    title: Text('My Posted Jobs'),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyPostedJob(widget.name)));
                  },
                ),
                InkWell(
                  child: ListTile(
                    leading: Icon(Icons.send, color: myColor.myBlack),
                    title: Text('Sent Application'),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => sentApplications(widget.name)));
                  },
                ),
                InkWell(
                  child: ListTile(
                      leading:
                          Icon(Icons.visibility_off, color: myColor.myBlack),
                      title: Text('Log out')),
                  onTap: () async {
                    await firebaseAuth.signOut();
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginSevenPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: myColor.myWhite,
                          borderRadius: BorderRadius.circular(20)),
                      child: Builder(
                        builder: (context) => IconButton(
                            icon: Icon(
                              Icons.list,
                              color: myColor.myBlack,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            }),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Internship Platform",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  "Categories",
                  style: GoogleFonts.openSans(
                      fontSize: 18,
                      color: myColor.myBlack,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: StreamBuilder(
                  stream:  FirebaseDatabase.instance.reference().child('Categories').onValue,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                      print(map.values.toList());
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                        itemCount: map.values.toList().length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PostedByCategory(
                                        widget.name,
                                        map.values
                                            .toList()[index]['type']
                                            .toString())));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 50,
                                    child: Text(
                                      map.values
                                          .toList()[index]['type']
                                          .toString()
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: myColor.myBackground,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    decoration: BoxDecoration(
                                        color: myColor.myBlack,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        map.values.toList()[index]['type'],
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                        style: GoogleFonts.montserrat(
                                            color: myColor.myBlack,
                                            fontSize: 16),
                                      )),
                                ],
                              ));
                        },
                      );

                    }if (!connected) {
                      return Center(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.signal_wifi_off,
                              size: 40,
                              color: myColor.myBlack,
                            ),
                            FlatButton(
                                shape:
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        color:
                                        Colors
                                            .black,
                                        width: 1,
                                        style:
                                        BorderStyle
                                            .solid),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        50)),
                                onPressed: () async {
                                  check.checkConnection();
                                },
                                child: Text('Retry',
                                    style: TextStyle(
                                        color: myColor
                                            .myBlack)))
                          ],
                        ),
                      );
                    }
                    return SpinKitWave(color: Colors.black);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
