import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Employer/MyProfile.dart';
import 'package:internship_platform/Employer/PostJob.dart';
import 'package:internship_platform/Employer/PostedByCategory.dart';
import 'package:internship_platform/Employer/createCategory.dart';
import 'package:internship_platform/Employer/mypostedJobs.dart';
import 'package:internship_platform/Employer/sentApplications.dart';
import 'package:internship_platform/Intern/ApplyforJob.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/authService.dart';

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

  getUser() async {
    user = await firebaseAuth.currentUser();
    client = await db.getUser(widget.name);
    fullName = client[0]['fullName'];
    imageurl = client[0]['image'];
    print(imageurl);
    decodedImage = imageurl=='none'?null:Base64Decoder().convert(imageurl);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.myBlack,
      appBar: AppBar(
        backgroundColor: myColor.myBlack,
        title: Text('Landing Page'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[

            ClipRect(
              child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExactAssetImage(
                              'image/internship.jpg'),
                          fit: BoxFit.cover)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 1.9, sigmaX: 2.5),
                    child: UserAccountsDrawerHeader(
                      decoration:
                      BoxDecoration(color: Colors.transparent),
                      accountName: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.pink,
                          child: Text(widget.name
                              .substring(0, 1)
                              .toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),)),
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
              child:ListTile(
                leading:Icon(Icons.person),
                title:Text('My Profile'),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder:(context)=>MyProfile(widget.name,decodedImage)));
              },

            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.post_add),
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
              onTap: () {
                AuthService().signOut();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
              height: 160,
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              "Categories",
              style: TextStyle(color: myColor.myWhite, fontSize: 18),
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
                        mainAxisSpacing: 25,
                        crossAxisSpacing: 25),
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
                        child: Card(
                            color: myColor.myPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.category,
                                  size: 50,
                                ),
                                Center(
                                    child: Text(
                                  map.values.toList()[index]['type'],
                                  style: TextStyle(
                                    color: myColor.myWhite,
                                  ),
                                )),
                              ],
                            )),
                      );
                    },
                  );
                }

                return Center(
                    child: SpinKitWave(
                  color: Colors.pink,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
