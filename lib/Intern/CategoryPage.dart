import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/Intern/chooseJob.dart';
import 'package:internship_platform/authService.dart';

import 'ApplyforJob.dart';
import 'MyProifle.dart';
import 'jobDetail.dart';
import 'myApplication.dart';
import 'package:intl/intl.dart';

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
  }

  bool connected = false;
  var client;
  var imageurl;
  var decodedImage;

  getUser() async {
    user = await firebaseAuth.currentUser();
    client = await db.getUser(widget.name);
    fullName = client[0]['fullName'];
    imageurl = client[0]['image'];
    decodedImage = Base64Decoder().convert(imageurl);
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
//    String apiUrl = 'http://192.168.1.3/Laravel/Laravel/public/api/todos';
//    http.Response response = await http.get(apiUrl);
//    await http.post('http://192.168.1.3/Laravel/Laravel/public/api/todo-save',body:{
//
//        'todo' : 'working with api is lovely',
//        'completed': '${0}'
//    }).then((value) => print(value.body));
//    List fromApi = jsonDecode(response.body);
//    print("from api ${fromApi[0]}");
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
        print("titus element$capitalizedValue");
        //print("element is ${element['productName'][0]}");

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
    print("helloooo $fullName");
    print('post is $RecentPost');
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Intern Platform"),
          elevation: 0.0,
          backgroundColor: myColor.myBlack,
        ),
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
                        filter: ImageFilter.blur(sigmaY: 1.9, sigmaX: 2.5),
                        child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(color: Colors.transparent),
                          accountName: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.pink,
                              child: Text(
                                widget.name.substring(0, 1).toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          accountEmail: Text(
                            widget.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      )),
                ),
                InkWell(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text("My Profile"),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MyProfile(user.email, decodedImage)));
                  },
                ),
                InkWell(
                  child: ListTile(
                    leading: Icon(Icons.description),
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
                    leading: Icon(Icons.visibility_off),
                    title: Text('log out'),
                  ),
                  onTap: () async {
                    print('out');
                    await firebaseAuth.signOut();
                  },
                )
              ],
            ),
          ),
        ),
        body: Container(
          color: myColor.myBlack,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Hi $fullName',
                  style: TextStyle(
                      color: myColor.myWhite,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: myColor.myGrey,
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  onChanged: (value) {
//                    if (value.isEmpty) {
//                      FocusManager.instance.primaryFocus.unfocus();
//                    }

                    initiateSearch(value);
                  },
                  decoration: InputDecoration(
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
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: tempSearchStore.map((element) {
                      print(
                          'the element to be build is ${element['jobTitle']}');
                      return buildResultCard(element, context);
                    }).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      "Categories",
                      style: TextStyle(color: myColor.myWhite, fontSize: 18),
                    ),
                  ),
                  Container(
                      height: 100,
                      child: StreamBuilder(
                        stream: FirebaseDatabase.instance
                            .reference()
                            .child("Categories")
                            .onValue,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            Map<dynamic, dynamic> map =
                                snapshot.data.snapshot.value;
                            print(map.values.toList());
                            return ListView.builder(
                              itemCount: map.values.toList().length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => chooseJob(map
                                                .values
                                                .toList()[index]['type']
                                                .toString())));
                                  },
                                  child: Container(
                                    width: 120,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Card(
                                      color: myColor.myPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                map.values.toList()[index]
                                                    ['type'],
                                                style: TextStyle(
                                                    color: myColor.myWhite),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wifi_off,
                                    size: 40,
                                  ),
                                  FlatButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.black,
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      onPressed: () async {
                                        var connectivityResult =
                                            await (Connectivity()
                                                .checkConnectivity());
                                        print(connectivityResult);
                                        if ((connectivityResult ==
                                                ConnectivityResult.wifi) ||
                                            connectivityResult ==
                                                ConnectivityResult.mobile) {
                                          connected = true;
                                          print('connected');
                                          setState(() {});
                                        } else {
                                          print('not connected');
                                        }
                                      },
                                      child: Text('Retry',
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              ),
                            );
                          }

                          return SpinKitWave(
                            color: Colors.purple,
                          );
                        },
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: myColor.myWhite,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Recent Posts",
                        style: TextStyle(fontFamily: 'Oswald', fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
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
                                    if (map.values.toList()[i]['status'] ==
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
                                                      .toList()[i]['postedAt']
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
                                                    .toList()[i]['postedAt']
                                                    .toString()
                                                    .split("-")[1])) ==
                                            1) {
                                          // if the month difference is 1 like Nov and Oct
                                          if ((30 -
                                                      int.parse(map.values
                                                          .toList()[i]
                                                              ['postedAt']
                                                          .toString()
                                                          .split("-")[2])) +
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
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            leading: Icon(
                                              Icons.access_time,
                                              color: myColor.myPurple,
                                            ),
                                            title: Text(
                                                "${RecentPost[index]['jobTitle']}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            subtitle: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                    width: 100,
                                                    child: Text(
                                                      "${RecentPost[index]['companyName']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
//
                                              ],
                                            ),
                                            trailing: FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) => jobDetail(
                                                              RecentPost[index]
                                                                  ['jobTitle'],
                                                              RecentPost[index][
                                                                  'jobDescription'],
                                                              RecentPost[index][
                                                                  'postedBy'],
                                                              RecentPost[index]
                                                                  ['category'],
                                                              RecentPost[index]
                                                                  ['postedAt'],
                                                              RecentPost[index]
                                                                  ['allowance'],
                                                              RecentPost[index][
                                                                  'howLong'],
                                                             RecentPost[index]['companyName']
                                                          )));
                                                },
                                                child: Text("Detail")),
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
                                          Icons.wifi_off,
                                          size: 40,
                                        ),
                                        FlatButton(
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
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
                                    color: Colors.purple,
                                  );
                                }
                              })),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
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
              data['companyName']
          )));
    },
    child: Container(
      child: ListTile(
        leading: Icon(Icons.work),
        title: Text(data['jobTitle'],
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    ),
  );
}
