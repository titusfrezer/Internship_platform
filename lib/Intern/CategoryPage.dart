
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/authService.dart';

import 'ApplyforJob.dart';
FirebaseAuth _firebaseAuth;
FirebaseUser  user;

class InternCategoryPage extends StatefulWidget {
  String name;
  InternCategoryPage(this.name);
  @override
  _InternCategoryPageState createState() => _InternCategoryPageState();
}

class _InternCategoryPageState extends State<InternCategoryPage> {

  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;
    getUser();
  }
  getUser() async{
    user = await _firebaseAuth.currentUser();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Intern Platform"),
        elevation: 0.0,
        backgroundColor: myColor.myBlack,
        actions: [
          CircleAvatar(
            backgroundColor: myColor.myGrey,
            child: Icon(Icons.person),
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text("My Profile"),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text("My Applications"),
              ),
              InkWell(
                 child: ListTile(
                    leading: Icon(Icons.visibility_off),
                    title: Text('log out'),
                  ),
                onTap: () async{

                   await _firebaseAuth.signOut();

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
                'Hi ${widget.name}',
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
                      stream: FirebaseDatabase.instance.reference().child("Categories").onValue,
                      builder: (BuildContext context,snapshot){
                        if(snapshot.hasData){
                          Map<dynamic,dynamic> map = snapshot.data.snapshot.value;
                          print(map.values.toList());
                          return ListView.builder(
                            itemCount:map.values.toList().length ,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Apply(map.values.toList()[index]['type'].toString()) ));
                                },
                                child: Container(
                                  width: 120,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Card(
                                    color: myColor.myPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                        child:Padding(
                                          padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              map.values.toList()[index]['type'],
                                              style: TextStyle(color: myColor.myWhite),
                                            )
                                        )
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }


                       return SpinKitWave(color: Colors.purple,);
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
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: 5,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    leading: Icon(
                                      Icons.favorite,
                                      color: myColor.myPurple,
                                    ),
                                    title: Text("Flutter Developer"),
                                    subtitle: Text("Adika Taxi"),
                                    trailing: FlatButton(
                                        onPressed: () {}, child: Text("Detail")),
                                  );
                                })),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}