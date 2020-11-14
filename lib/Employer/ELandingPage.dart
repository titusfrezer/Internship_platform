import 'dart:convert';

import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Employer/MyProfile.dart';
import 'package:internship_platform/Employer/PostedByCategory.dart';
import 'package:internship_platform/Employer/createCategory.dart';
import 'package:internship_platform/Employer/mypostedJobs.dart';
import 'package:internship_platform/Employer/sentApplications.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';

import '../LoginPage.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
  String name;

  LandingPage(this.name);
}

class _LandingPageState extends State<LandingPage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    getUser();
    print('hi');
  }

  bool connected = false;
  var client;
  var imageurl;
  var decodedImage;
  var fullName;

  getUser() async {
    user = await firebaseAuth.currentUser();
    client = await db.getUser(widget.name);
    fullName = client[0]['fullName'];
    imageurl = client[0]['image'];
    print(imageurl);
    decodedImage =
        imageurl == 'none' ? null : Base64Decoder().convert(imageurl);
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
    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .orderByChild("email")
        .equalTo(user.email)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print("value is ${values['url']}");
        imageurl = values['url'];
        // decodedImage = Base64Decoder().convert(values['decodedImage']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.myBackground,
      drawer: Drawer(
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
                title: Text('My Profile'),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyProfile(widget.name, imageurl)));
              },
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.assignment_ind),
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
                leading: Icon(Icons.send),
                title: Text('Sent Application'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => sentApplications()));
              },
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.category),
                title: Text('Create Category'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => createCategory()));
              },
            ),
            InkWell(
              child: ListTile(
                  leading: Icon(Icons.visibility_off), title: Text('Log out')),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                style: GoogleFonts.combo(
                    fontSize: 18,
                    color: myColor.myBlack,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Flexible(
              child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("Categories")
                    .onValue,
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
                                      map.values.toList()[index]['type'].toString().substring(0,1).toUpperCase(),
                                    style: TextStyle(
                                      color: myColor.myBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: myColor.myWhite,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(

                                  alignment: Alignment.center,
                                    child: Text(
                                  map.values.toList()[index]['type'],textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: GoogleFonts.alice(
                                      color: myColor.myBlack, fontSize: 16),
                                )),
                              ],
                            ));
                      },
                    );
                  }

                  return Center(
                      child: SpinKitWave(
                    color: myColor.myBlack,
                    size: 25,
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
