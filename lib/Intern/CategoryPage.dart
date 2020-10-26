
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/Intern/chooseJob.dart';
import 'package:internship_platform/authService.dart';

import 'ApplyforJob.dart';
import 'jobDetail.dart';
import 'myApplication.dart';
import 'package:intl/intl.dart';
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
  bool connected=false;
  getUser() async{
    user = await _firebaseAuth.currentUser();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('connected via cellular');
      connected=true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('connected via wifi');
      connected=true;
    }
    else if(connectivityResult==ConnectivityResult.none){
      print('not connected');
      connected=false;

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
    var capitalizedValue = value.substring(0,1).toUpperCase()+value.substring(1);
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
          print("${DATA[individualKey]['jobTitle']} is the value");
          queryResultSet.add(DATA[individualKey]);

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
    return Scaffold(
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
              ListTile(
                leading: Icon(Icons.person),
                title: Text("My Profile"),
              ),
              InkWell(
                child:ListTile(
                  leading: Icon(Icons.description),
                  title: Text("My Applications"),
                ),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder:(context)=>MyApplication(widget.name)));
                },
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
                onChanged: (value){

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
                                  Navigator.of(context).push(MaterialPageRoute(builder:(context)=>chooseJob(map.values.toList()[index]['type'].toString()) ));
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
                        if(!connected){

                          return Center(
                            child: RaisedButton(child:Text('No conncection'),onPressed: ()async{
                              var connectivityResult = await (Connectivity().checkConnectivity());
                              print(connectivityResult);
                              if((connectivityResult==ConnectivityResult.wifi)||connectivityResult==ConnectivityResult.mobile){
                                connected = true;
                                print('connected');
                                setState(() {

                                });
                              }else{
                                print('not connected');
                              }
                            },),
                          );

                        }


                       return SpinKitWave(color: Colors.purple,);
                      },

                    )),
                ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: tempSearchStore.map((element) {
                    print('the element to be build is ${element['jobTitle']}');
                    return buildResultCard(element, context);
                  }).toList(),
                ),
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
                              stream: FirebaseDatabase.instance.reference().child("posts").onValue,
                              builder: (context, snapshot) {
                                if(snapshot.hasData) {
                                  Map<dynamic,dynamic> map = snapshot.data.snapshot.value;

                                  var counter =0;
                                  for(var i=0;i<map.values.toList().length;i++){
                                    if(int.parse(map.values.toList()[i]['postedAt'].toString().split("-")[0]) == DateTime.now().year &&
                                        int.parse(map.values.toList()[i]['postedAt'].toString().split("-")[1])==DateTime.now().month &&
                                            DateTime.now().day-(int.parse(map.values.toList()[i]['postedAt'].toString().split("-")[2])) <=5){

                                      counter++;
                                    }
                                  }
                                  if(counter==0){
                                    return Center(child: Text('No recent post yet'),);
                                  }
                                  else {
                                    return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: map.values
                                            .toList()
                                            .length,
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          var year = map.values
                                              .toList()[index]['postedAt']
                                              .toString()
                                              .split("-")[0];
                                          var month = map.values
                                              .toList()[index]['postedAt']
                                              .toString()
                                              .split("-")[1];
                                          var day = map.values
                                              .toList()[index]['postedAt']
                                              .toString()
                                              .split("-")[2];
                                          if (int.parse(year) == DateTime
                                              .now()
                                              .year &&
                                              int.parse(month) == DateTime
                                                  .now()
                                                  .month && (DateTime
                                              .now()
                                              .day) - (int.parse(day)) <= 5) {
                                            return ListTile(
                                              leading: Icon(
                                                Icons.favorite,
                                                color: myColor.myPurple,
                                              ),
                                              title: Text("${map.values
                                                  .toList()[index]['jobTitle']}"),
                                              subtitle: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  Container(width: 100,
                                                      child: Text("${map.values
                                                          .toList()[index]['companyName']} company",
                                                        overflow: TextOverflow
                                                            .ellipsis,)),

                                                  Text('${map.values
                                                      .toList()[index]['postedAt']}')
                                                ],
                                              ),
                                              trailing: FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                jobDetail(map.values
                                                                    .toList()[index]['jobTitle'],
                                                                    map.values
                                                                        .toList()[index]['category'],
                                                                    map.values
                                                                        .toList()[index]['postedTo'])));
                                                  },
                                                  child: Text("Detail")),
                                            );
                                          }
                                          return Container();
                                        });
                                  }
                                }
                                return SpinKitWave(color: Colors.purple,);
                              }
                            )),
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
Widget buildResultCard(data, BuildContext context) {

  return InkWell(
    onTap: () {

    },
    child: Row(
      children: <Widget>[
        Icon(Icons.work)
          ,
        Text(data['jobTitle'],
            style: TextStyle(color: Colors.white24, fontSize: 20)),
      ],
    ),
  );
}
