import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/Intern/chooseJob.dart';
import '../LoginPage.dart';
import 'MyProifle.dart';
import 'jobDetail.dart';
import 'myApplication.dart';

class InternCategoryPage extends StatefulWidget {
  String name;

  InternCategoryPage(this.name);

  @override
  _InternCategoryPageState createState() => _InternCategoryPageState();
}

class _InternCategoryPageState extends State<InternCategoryPage> {
  List RecentPost = List();

  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    getUser();
    print('hi');
    RecentPost.clear();
    imageurl = null;
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

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
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
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

                        initiateSearch(value);
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
                                        if (!connected) {
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
                                                      var connectivityResult =
                                                          await (Connectivity()
                                                              .checkConnectivity());
                                                      print(connectivityResult);
                                                      if ((connectivityResult ==
                                                              ConnectivityResult
                                                                  .wifi) ||
                                                          connectivityResult ==
                                                              ConnectivityResult
                                                                  .mobile) {
                                                        connected = true;
                                                        print('connected');
                                                        setState(() {});
                                                      } else {
                                                        setState(() {
                                                          connected = false;
                                                        });
                                                        print('not connected');
                                                      }
                                                    },
                                                    child: Text('Retry',
                                                        style: TextStyle(
                                                            color: myColor
                                                                .myBlack)))
                                              ],
                                            ),
                                          );
                                        }

                                        return SpinKitWave(
                                          color: myColor.myBlack,
                                          size: 20,
                                        );
                                      },
                                    )),
                              ],
                            ),
                            Container(
                              color: myColor.myBackground,
                              child: ListView(
                                shrinkWrap: true,
                                primary: false,
                                children: tempSearchStore.map((element) {
                                  print(
                                      'the element to be build is ${element['jobTitle']}');
                                  return buildResultCard(element, context);
                                }).toList(),
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
                                        .onValue,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Map<dynamic, dynamic> map =
                                            snapshot.data.snapshot.value;

                                        RecentPost.clear();

                                        var counter = 0;
                                        for (var i = 0;
                                            i < map.values.toList().length;
                                            i++) {
                                          if (map.values.toList()[i]
                                                  ['status'] ==
                                              'open') {
                                            if (int.parse(map.values
                                                    .toList()[i]['postedAt']
                                                    .toString()
                                                    .split("-")[0]) ==
                                                DateTime.now().year) {
                                              if (int.parse(map.values
                                                      .toList()[i]['postedAt']
                                                      .toString()
                                                      .split("-")[1]) ==
                                                  DateTime.now().month) {
                                                if (DateTime.now().day -
                                                        (int.parse(map.values
                                                            .toList()[i]
                                                                ['postedAt']
                                                            .toString()
                                                            .split("-")[2])) <=
                                                    5) {
                                                  print("month is equal");
                                                  RecentPost.add(
                                                      map.values.toList()[i]);
                                                  counter++;
                                                }
                                              } else if ((DateTime.now().month -
                                                      int.parse(map.values
                                                          .toList()[i]
                                                              ['postedAt']
                                                          .toString()
                                                          .split("-")[1])) ==
                                                  1) {
                                                // if the month difference is 1 like Nov and Oct
                                                if ((30 -
                                                            int.parse(map.values
                                                                .toList()[i]
                                                                    ['postedAt']
                                                                .toString()
                                                                .split(
                                                                    "-")[2])) +
                                                        DateTime.now().day <=
                                                    5) {
                                                  print("less month");
                                                  RecentPost.add(
                                                      map.values.toList()[i]);
                                                  counter++;
                                                }
                                              }
                                            }
                                          }
                                        } // if there is at least less than 5 days post
                                        print('$counter is counter');
                                        if (counter == 0) {
                                          return Center(
                                            child: Text('No recent post yet'),
                                          );
                                        } else {
                                          return ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount: RecentPost.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
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
                                                        "${RecentPost[index]['jobTitle']}",
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
                                                              "${RecentPost[index]['companyName']}",
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
                                                                  RecentPost[index][
                                                                      'jobTitle'],
                                                                  RecentPost[index]
                                                                      [
                                                                      'jobDescription'],
                                                                  RecentPost[index]
                                                                      [
                                                                      'postedBy'],
                                                                  RecentPost[index]
                                                                      [
                                                                      'category'],
                                                                  RecentPost[index]
                                                                      [
                                                                      'postedAt'],
                                                                  RecentPost[index]
                                                                      [
                                                                      'allowance'],
                                                                  RecentPost[index]
                                                                      [
                                                                      'howLong'],
                                                                  RecentPost[index]
                                                                      ['companyName'])));
                                                        },
                                                        child: Text("Detail")),
                                                  ),
                                                );
                                              });
                                        }
                                      }
                                      if (!connected) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.signal_wifi_off,
                                                size: 40,
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
                                                    var connectivityResult =
                                                        await (Connectivity()
                                                            .checkConnectivity());
                                                    print(connectivityResult);
                                                    if ((connectivityResult ==
                                                            ConnectivityResult
                                                                .wifi) ||
                                                        connectivityResult ==
                                                            ConnectivityResult
                                                                .mobile) {
                                                      connected = true;
                                                      print('connected');
                                                      setState(() {});
                                                    } else {
                                                      print('not connected');
                                                    }
                                                  },
                                                  child: Text('Retry'))
                                            ],
                                          ),
                                        );
                                      } else {
                                        return SpinKitWave(
                                            color: myColor.myBlack, size: 20);
                                      }
                                    })),
                          ),
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
              data['companyName'])));
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
