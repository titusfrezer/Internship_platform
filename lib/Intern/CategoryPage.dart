import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Utilities/variables.dart';
import 'package:internship_platform/Intern/chooseJob.dart';
import 'package:internship_platform/services/searchService.dart';
import 'package:provider/provider.dart';
import '../LoginPage.dart';
import 'package:internship_platform/services/authService.dart';
import 'MyProifle.dart';
import 'jobDetail.dart';
import 'myApplication.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class InternCategoryPage extends StatefulWidget {
  String name;

  InternCategoryPage(this.name);

  @override
  _InternCategoryPageState createState() => _InternCategoryPageState();
}

class _InternCategoryPageState extends State<InternCategoryPage> {
  FirebaseMessaging _messaging = FirebaseMessaging();

  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    getUser();
    print('hi');
    imageurl = null;
    _messaging.subscribeToTopic('NewJob');
    _messaging.configure(onMessage: (Map<String, dynamic> message) {
      print("onMessage : $message");
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

  }

  getUser() async {
    user = await firebaseAuth.currentUser();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('${user.email} is connected via cellular');
      connected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('${user.email} is connected via wifi');
      connected = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      print('not connected');
      connected = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    // final check = Provider.of<AuthService>(context);
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus.unfocus();
        },
        child: Scaffold(
          backgroundColor: myColor.myBackground,
          resizeToAvoidBottomInset: false,
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
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
                            decoration:
                                BoxDecoration(color: Colors.transparent),
                            accountName: CircleAvatar(
                                backgroundColor: myColor.myBlack,
                                foregroundColor: myColor.myWhite,
                                child: Text(
                                  widget.name.substring(0, 1).toUpperCase(),
                                  style: GoogleFonts.delius(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
                      leading: Icon(
                        Icons.person,
                        color: myColor.myBlack,
                      ),
                      title: Text("My Profile"),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MyProfile(user.email, imageurl)));
                    },
                  ),
                  InkWell(
                    child: ListTile(
                      leading: Icon(
                        Icons.description,
                        color: myColor.myBlack,
                      ),
                      title: Text("My Applications"),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyApplication(widget.name)));
                    },
                  ),
                  InkWell(
                    child: ListTile(
                      leading: Icon(
                        Icons.visibility_off,
                        color: myColor.myBlack,
                      ),
                      title: Text('log out'),
                    ),
                    onTap: () async {
                      print('out');
                      await firebaseAuth.signOut();
                      var user = await firebaseAuth.currentUser();
                      print(user);
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginSevenPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: StreamBuilder(
                          stream: FirebaseDatabase.instance
                              .reference()
                              .child('Users')
                              .orderByChild("email")
                              .equalTo(widget.name)
                              .onValue,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Map map = snapshot.data.snapshot.value;
                              imageurl = map.values.toList()[0]['url'];
                              return Text(
                                'Hi ${map.values.toList()[0]['userName']}',
                                style: TextStyle(
                                    color: myColor.myDarkGrey,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              );
                            }
                            return Text(
                              'Hi',
                              style: TextStyle(
                                  color: myColor.myDarkGrey,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            );
                          })),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('Find your Internship Program',
                        style: GoogleFonts.alice(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: myColor.myBlack)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: myColor.myWhite,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      onChanged: (value) {
//                    if (value.isEmpty) {
//                      FocusManager.instance.primaryFocus.unfocus();
//                    }
                       final search = Provider.of<SearchService>(context,listen: false);
                       print("value is $value");
                        search.initiateSearch(value);
                      },
                      decoration: InputDecoration(
                          hintText: "Search for Internship",
                          hintStyle: TextStyle(color: myColor.myLightGrey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          icon: Icon(
                            Icons.search,
                            color: myColor.myBlack,
                          )),
                      cursorColor: myColor.myBlack,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Text(
                                    "Categories",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: myColor.myBlack,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Container(
                                    height: 100,
                                    child: StreamBuilder(
                                      stream: FirebaseDatabase.instance
                                          .reference()
                                          .child("Categories")
                                          .onValue,
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map<dynamic, dynamic> map =
                                              snapshot.data.snapshot.value;
                                          print(map.values.toList());
                                          return ListView.builder(
                                            itemCount:
                                                map.values.toList().length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              chooseJob(map
                                                                  .values
                                                                  .toList()[
                                                                      index]
                                                                      ['type']
                                                                  .toString())));
                                                },
                                                child: Container(
                                                  width: 120,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: Card(
                                                    color: myColor.myBlack,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Center(
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              map.values
                                                                      .toList()[
                                                                  index]['type'],
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: GoogleFonts
                                                                  .alice(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16),
                                                            ))),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }

                                          return Consumer<AuthService>(
                                            builder: (_,check,__)=>
                                            check.isConnected? Center(
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
                                                                          .red,
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
                                            ):SpinKitWave(
                                              color: myColor.myBlack,
                                              size: 20,
                                            )
                                          );



                                      },
                                    ))
                              ],
                            ),
                            Consumer<SearchService>(
                              builder: (_,search,__)=>
                               Container(
                                color: myColor.myBackground,
                                child: ListView(
                                  shrinkWrap: true,
                                  primary: false,
                                  children: search.tempSearchStore.map((element) {
                                    print(
                                        'the element to be build is ${element['jobTitle']}');
                                    return buildResultCard(element, context);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 10),
                          child: Text(
                            "Recent Posts",
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                color: myColor.myBlack,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              height: 300,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: StreamBuilder(
                                    stream: FirebaseDatabase.instance
                                        .reference()
                                        .child("posts")
                                        .limitToLast(5)
                                        .onValue,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Map<dynamic, dynamic> map =
                                            snapshot.data.snapshot.value;
                                        return ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                map.values.toList().length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (map.values.toList()[index]
                                                      ['status'] ==
                                                  'open') {
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  decoration: BoxDecoration(
                                                      color: myColor.myWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: ListTile(
                                                    leading: Icon(
                                                      Icons.access_time,
                                                      color: Colors.purple,
                                                    ),
                                                    title: Text(
                                                        "${map.values.toList()[index]['jobTitle']}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    subtitle: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: <Widget>[
                                                        Container(
                                                            width: 100,
                                                            child: Text(
                                                              "${map.values.toList()[index]['companyName']}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
//
                                                      ],
                                                    ),
                                                    trailing: FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => jobDetail(
                                                                  map.values.toList()[index][
                                                                      'jobTitle'],
                                                                  map.values.toList()[index][
                                                                      'jobDescription'],
                                                                  map.values.toList()[index][
                                                                      'postedBy'],
                                                                  map.values.toList()[index]
                                                                      [
                                                                      'category'],
                                                                  map.values
                                                                          .toList()[index]
                                                                      ['postedAt'],
                                                                  map.values.toList()[index]['allowance'],
                                                                  map.values.toList()[index]['howLong'],
                                                                  map.values.toList()[index]['companyName'],
                                                                  map.values.toList()[index]['token']
                                                              )));
                                                        },
                                                        child: Text("Detail")),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            });
                                      }
                                      if (!connected) {
                                        return Consumer<AuthService>(
                                          builder: (_,check,__)=>
                                           Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.wifi_off_rounded,
                                                  size: 40,
                                                  color: myColor.myBlack,
                                                ),
                                                FlatButton(
                                                    shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: Colors.black,
                                                            width: 1,
                                                            style: BorderStyle
                                                                .solid),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50)),
                                                    onPressed: () async {
                                                      check.checkConnection();
                                                    },
                                                    child: Text('Retry',
                                                        style: TextStyle(
                                                            color:
                                                                myColor.myBlack)))
                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                      return SpinKitWave(
                                          color: myColor.myBlack, size: 20);
                                    }),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Widget buildResultCard(data, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => jobDetail(
              data['jobTitle'],
              data['jobDescription'],
              data['postedBy'],
              data['category'],
              data['postedAt'],
              data['allowance'],
              data['howLong'],
              data['companyName'],
              data['token']
          )));
    },
    child: Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.work,
            color: myColor.myBlack,
          ),
          title: Text(data['jobTitle'],
              style: GoogleFonts.delius(color: myColor.myBlack, fontSize: 20)),
        ),
        Divider(thickness: 0.2, color: myColor.myBlack)
      ],
    ),
  );
}
