import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:intl/intl.dart';

class MyPostedJob extends StatefulWidget {
  String name;

  MyPostedJob(this.name);

  @override
  _MyPostedJobState createState() => _MyPostedJobState();
}

class _MyPostedJobState extends State<MyPostedJob> {
  TextEditingController jobTitle = TextEditingController();
  TextEditingController jobDescription = TextEditingController();
  TextEditingController howLong = TextEditingController();
  TextEditingController allowance = TextEditingController();
  DatabaseReference myAppRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColor.myBackground,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: myColor.myWhite,
                          borderRadius: BorderRadius.circular(20)),
                      child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.15),
                      alignment: Alignment.center,
                      child: Text(
                        "My Posted Jobs",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child('posts')
                      .orderByChild('postedBy')
                      .equalTo(widget.name)
                      .onValue,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.snapshot.value != null) {
                        Map<dynamic, dynamic> map =
                            snapshot.data.snapshot.value;
                        print("hello ${map.keys}");
//                    print(map.values.toList());

                        return ListView.builder(
                          itemCount: map.values.toList().length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            jobTitle.text =
                                map.values.toList()[index]['jobTitle'];
                            jobDescription.text =
                                "${map.values.toList()[index]['jobDescription']}";
                            howLong.text =
                                map.values.toList()[index]['howLong'];
                            allowance.text =
                                map.values.toList()[index]['allowance'];
                            return index % 2 == 0
                                ? Dismissible(
                                    key: Key(
                                        map.keys.toList()[index].toString()),
                                    confirmDismiss: (direction) {
                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Are you sure you want to delete!!'),
                                              actions: <Widget>[
                                                FlatButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      setState(() {
                                                        FirebaseDatabase
                                                            .instance
                                                            .reference()
                                                            .child("posts")
                                                            .child(map.keys
                                                                    .toList()[
                                                                index])
                                                            .remove();
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
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
                                      width: 120,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Card(
                                        color: myColor.myBlack,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ExpansionTile(
                                            leading: Icon(
                                              Icons.school,
                                              color: myColor.myWhite,
                                              size: 40,
                                            ),
                                            title: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                map.values.toList()[index]
                                                    ['jobTitle'],
                                                overflow: TextOverflow.fade,
                                                style: GoogleFonts.alice(
                                                    color: myColor.myWhite,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_drop_down,
                                              color: myColor.myWhite,
                                              size: 40,
                                            ),
                                            subtitle: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  map.values.toList()[index]
                                                      ['category'],
                                                  style: GoogleFonts.scada(
                                                      color: myColor.myWhite,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                )),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    map.values.toList()[index]
                                                                ['status'] ==
                                                            'open'
                                                        ? RaisedButton(
                                                            color:
                                                                myColor.myWhite,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            child: Text(
                                                                'Close Job'),
                                                            onPressed: () {
                                                              setState(() {
                                                                print(map.values
                                                                        .toList()[
                                                                    index]);
                                                                FirebaseDatabase
                                                                    .instance
                                                                    .reference()
                                                                    .child(
                                                                        "posts")
                                                                    .child(map
                                                                            .keys
                                                                            .toList()[
                                                                        index])
                                                                    .update({
                                                                  'status':
                                                                      'closed'
                                                                }).then((_) {
                                                                  print('done');
                                                                });
                                                              });
                                                              Flushbar(
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                title:
                                                                    "Success",
                                                                message:
                                                                    "Job Closed",
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                              )..show(context);
                                                            },
                                                          )
                                                        : RaisedButton(
                                                            color:
                                                                myColor.myWhite,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            child: Text(
                                                                'Post Job'),
                                                            onPressed: () {
                                                              setState(() {
                                                                print(map.values
                                                                        .toList()[
                                                                    index]);
                                                                FirebaseDatabase
                                                                    .instance
                                                                    .reference()
                                                                    .child(
                                                                        "posts")
                                                                    .child(map
                                                                            .keys
                                                                            .toList()[
                                                                        index])
                                                                    .update({
                                                                  'status':
                                                                      'open'
                                                                }).then((_) {
                                                                  print('done');
                                                                });
                                                              });
                                                              Flushbar(
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                title:
                                                                    "Success",
                                                                message:
                                                                    "Job Opened",
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                              )..show(context);
                                                            },
                                                          ),
                                                    SizedBox(width: 20),
                                                    RaisedButton(
                                                      color: myColor.myWhite,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                      ),
                                                      child: Text(
                                                        'Edit',
                                                      ),
                                                      onPressed: () {
                                                        return showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Edit Post'),
                                                                content:
                                                                    Container(
                                                                  height: 250,
                                                                  width: 350,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                    children: [
                                                                      TextField(
                                                                        controller:
                                                                            jobTitle,
                                                                        decoration:
                                                                            InputDecoration(labelText: 'Job Title'),
                                                                      ),
                                                                      TextField(
                                                                        minLines:
                                                                            2,
                                                                        maxLines:
                                                                            4,
                                                                        controller:
                                                                            jobDescription,
                                                                        decoration:
                                                                            InputDecoration(labelText: 'Job Description'),
                                                                      ),
                                                                      TextField(
                                                                        controller:
                                                                            howLong,
                                                                        decoration:
                                                                            InputDecoration(labelText: 'For How Long '),
                                                                      ),
                                                                      TextField(
                                                                        controller:
                                                                            allowance,
                                                                        decoration:
                                                                            InputDecoration(labelText: 'Allowance(In Birr)'),
                                                                      ),
                                                                    ],
                                                                  )),
                                                                ),
                                                                actions: [
                                                                  Row(
                                                                    children: [
                                                                      FlatButton(
                                                                        child: Text(
                                                                            'Cancel',style:TextStyle(color:Colors.black)),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                      FlatButton(
                                                                        child: Text(
                                                                            'Update',style:TextStyle(color:Colors.black)),
                                                                        onPressed:
                                                                            () async {
                                                                          FirebaseDatabase
                                                                              .instance
                                                                              .reference()
                                                                              .child("posts")
                                                                              .child(map.keys.toList()[index])
                                                                              .update({
                                                                            'jobTitle':
                                                                                jobTitle.text,
                                                                            'jobDescription':
                                                                                jobDescription.text,
                                                                            'howLong':
                                                                                howLong.text,
                                                                            'allowance':
                                                                                allowance.text,
                                                                            'postedAt':
                                                                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                                          }).then((_) {
                                                                            print('done');
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Flushbar(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.check,
                                                                              color: Colors.green,
                                                                            ),
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            title:
                                                                                "Success",
                                                                            message:
                                                                                "Post Updated",
                                                                            duration:
                                                                                Duration(seconds: 3),
                                                                          )..show(
                                                                              context);
                                                                        },
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]),
                                      ),
                                    ),
                                  )
                                : Dismissible(
                                    key: Key(
                                        map.keys.toList()[index].toString()),
                                    confirmDismiss: (direction) {
                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Are you sure you want to delete!!'),
                                              actions: <Widget>[
                                                FlatButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      setState(() {
                                                        FirebaseDatabase
                                                            .instance
                                                            .reference()
                                                            .child("posts")
                                                            .child(map.keys
                                                                    .toList()[
                                                                index])
                                                            .remove();
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
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
                                      width: 120,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Card(
                                        color: myColor.myWhite,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ExpansionTile(
                                            leading: Icon(
                                              Icons.school,
                                              color: myColor.myBlack,
                                              size: 40,
                                            ),
                                            title: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                map.values.toList()[index]
                                                    ['jobTitle'],
                                                overflow: TextOverflow.fade,
                                                style: GoogleFonts.alice(
                                                    color: myColor.myBlack,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_drop_down,
                                              color: myColor.myBlack,
                                              size: 40,
                                            ),
                                            subtitle: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  map.values.toList()[index]
                                                      ['category'],
                                                  style: GoogleFonts.scada(
                                                      color: myColor.myBlack,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                )),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    map.values.toList()[index]
                                                                ['status'] ==
                                                            'open'
                                                        ? RaisedButton(
                                                            color:
                                                                myColor.myBlack,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            child: Text(
                                                              'Close Job',
                                                              style: TextStyle(
                                                                  color: myColor
                                                                      .myWhite),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                print(map.values
                                                                        .toList()[
                                                                    index]);
                                                                FirebaseDatabase
                                                                    .instance
                                                                    .reference()
                                                                    .child(
                                                                        "posts")
                                                                    .child(map
                                                                            .keys
                                                                            .toList()[
                                                                        index])
                                                                    .update({
                                                                  'status':
                                                                      'closed'
                                                                }).then((_) {
                                                                  print('done');
                                                                });
                                                              });
                                                              Flushbar(
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                title:
                                                                    "Success",
                                                                message:
                                                                    "Job Closed",
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                              )..show(context);
                                                            },
                                                          )
                                                        : RaisedButton(
                                                            color:
                                                                myColor.myBlack,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            child: Text(
                                                              'Post Job',
                                                              style: TextStyle(
                                                                  color: myColor
                                                                      .myBlack),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                print(map.values
                                                                        .toList()[
                                                                    index]);
                                                                FirebaseDatabase
                                                                    .instance
                                                                    .reference()
                                                                    .child(
                                                                        "posts")
                                                                    .child(map
                                                                            .keys
                                                                            .toList()[
                                                                        index])
                                                                    .update({
                                                                  'status':
                                                                      'open'
                                                                }).then((_) {
                                                                  print('done');
                                                                });
                                                              });
                                                              Flushbar(
                                                                icon: Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                title: "Sucess",
                                                                message:
                                                                    "Job Opened",
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                              )..show(context);
                                                            },
                                                          ),
                                                    SizedBox(width: 20),
                                                    RaisedButton(
                                                      color: myColor.myBlack,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                      ),
                                                      child: Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                            color: myColor
                                                                .myWhite),
                                                      ),
                                                      onPressed: () {
                                                        return showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Edit Post'),
                                                                content:
                                                                    Container(
                                                                  height: 250,
                                                                  width: 350,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                    children: [
                                                                      TextField(
                                                                        controller:
                                                                            jobTitle,
                                                                        decoration:
                                                                            InputDecoration(labelText: 'Job Title'),
                                                                      ),
                                                                      TextField(
                                                                        minLines:
                                                                            2,
                                                                        maxLines:
                                                                            4,
                                                                        controller:
                                                                            jobDescription,
                                                                        decoration:
                                                                            InputDecoration(labelText: 'Job Description'),
                                                                      ),
                                                                      TextField(
                                                                        controller:
                                                                            howLong,
                                                                        decoration:
                                                                            InputDecoration(labelText: 'For How Long '),
                                                                      ),
                                                                      TextField(
                                                                        controller:
                                                                            allowance,
                                                                        decoration:
                                                                            InputDecoration(labelText: 'Allowance(In Birr)'),
                                                                      ),
                                                                    ],
                                                                  )),
                                                                ),
                                                                actions: [
                                                                  Row(
                                                                    children: [
                                                                      FlatButton(
                                                                        child: Text(
                                                                            'Cancel'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                      FlatButton(
                                                                        child: Text(
                                                                            'Update'),
                                                                        onPressed:
                                                                            () async {
                                                                          FirebaseDatabase
                                                                              .instance
                                                                              .reference()
                                                                              .child("posts")
                                                                              .child(map.keys.toList()[index])
                                                                              .update({
                                                                            'jobTitle':
                                                                                jobTitle.text,
                                                                            'jobDescription':
                                                                                jobDescription.text,
                                                                            'howLong':
                                                                                howLong.text,
                                                                            'allowance':
                                                                                allowance.text,
                                                                            'postedAt':
                                                                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                                          }).then((_) {
                                                                            print('done');
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Flushbar(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.check,
                                                                              color: Colors.green,
                                                                            ),
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            title:
                                                                                "Success",
                                                                            message:
                                                                                "Post Updated",
                                                                            duration:
                                                                                Duration(seconds: 3),
                                                                          )..show(
                                                                              context);
                                                                        },
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]),
                                      ),
                                    ),
                                  );
                          },
                        );
                      }
                    } else {
                      return SpinKitWave(
                        color: myColor.myBlack,
                       
                      );
                    }
                    return Center(
                      child: Text('No Posted Job yet'),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
