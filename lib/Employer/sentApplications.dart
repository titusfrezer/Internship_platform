import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class sentApplications extends StatefulWidget {
  @override
  _sentApplicationsState createState() => _sentApplicationsState();
}

Query sentRef;

DatabaseReference closeRef =
    FirebaseDatabase.instance.reference().child("closed");

class _sentApplicationsState extends State<sentApplications> {
  FirebaseUser currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
var client;
  void getUser() async {
    print(_auth);
    currentUser = await _auth.currentUser();
    print("email is ${currentUser.email}");
    setState(() {
      isLoading = false;
    });

  }

  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    print("the user is$currentUser");

    return Scaffold(
//        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Sent Applications'),
          backgroundColor: Colors.black,
        ),
        body: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("application")
                    .orderByChild('AppliedTo')
                    .equalTo(currentUser.email)
                    .onValue,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.snapshot.value != null) {
                      Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                      print(map.values.toList());
                      return ListView.builder(
                        itemCount: map.values.toList().length,
//                      scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
//                            Navigator.of(context).push(MaterialPageRoute(builder:(context)=>PostJob(map.values.toList()[index]['type'].toString()) ));
                            },
                            child: Dismissible(
                              key: Key(map.values.toList()[index].toString()),
                              confirmDismiss: (direction) {
                                return showDialog(
                                    context: (context),
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Are you sure you want to delete!!'),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('Yes'),
                                              onPressed: () {
                                                setState(() {
                                                  FirebaseDatabase.instance
                                                      .reference()
                                                      .child("application")
                                                      .child(map.keys
                                                          .toList()[index])
                                                      .remove();
                                                });

                                                Navigator.of(context).pop();
                                              }),
                                          FlatButton(
                                            child: Text('No'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Card(
                                  color: myColor.myBlack,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ExpansionTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    trailing: Icon(Icons.arrow_drop_down,color:Colors.pink,size:40),
                                    title: Column(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Text('Applier Name   - ',
                                                style: TextStyle(
                                                    color: myColor.myWhite)),
                                            Text(
                                              "${map.values.toList()[index]['ApplierName']} ",
                                              style: TextStyle(
                                                  color: myColor.myWhite),
                                            ),
//
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Text('Applied Position   - ',
                                                style: TextStyle(
                                                    color: myColor.myWhite)),
                                            Text(
                                              "  ${map.values.toList()[index]['jobTitle']}",
                                              style: TextStyle(
                                                  color: myColor.myWhite),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),

                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          RaisedButton(
                                            color: Colors.black87,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Text(
                                              'Contact Intern',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              map.values.toList()[index]
                                                      ['ApplierExpertise'] =
                                                  'Software Engineer';
                                              UrlLauncher.launch(
                                                  'mailto:${map.values.toList()[index]['ApplierEmail']}?subject=Intern Application&body=This is to inform that you are selected to be our intern');
                                            },
                                          ),
                                          RaisedButton(
                                            color: Colors.black87,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Text('View Cv online',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () async {
//                                      setState(() {
//                                        isLoading = true;
//                                      });
                                              PDFDocument doc =
                                                  await PDFDocument.fromURL(
                                                      map.values.toList()[index]
                                                          ['cvUrl']);
                                              print(map.values.toList()[index]
                                                  ['cvUrl']);
                                              print("hii");
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ViewPdf(doc)));
                                            },
                                          ),
                                        ],
                                      )
                                    ],

//
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No Sent Application Yet',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      );
                    }
                  }

                  return SpinKitWave(
                    color: Colors.purple,
                  );
                },
              ));
  }
}

class ViewPdf extends StatelessWidget {
  PDFDocument document;

  ViewPdf(this.document);

  @override
  Widget build(BuildContext context) {
    print(document);
    return Scaffold(
        body: isLoading
            ? SpinKitWave(
                color: Colors.pink,
              )
            : PDFViewer(
                showPicker: false,
                document: document,
              ));
  }
}
