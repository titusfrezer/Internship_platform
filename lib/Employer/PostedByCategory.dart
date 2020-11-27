

import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Employer/PostJob.dart';
import 'package:internship_platform/ReusableTextField.dart';
import 'package:intl/intl.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';

class PostedByCategory extends StatefulWidget {
  @override
  _PostedByCategoryState createState() => _PostedByCategoryState();
  String name;
  String category;

  PostedByCategory(this.name, this.category);
}

bool viewVisible = false;

class _PostedByCategoryState extends State<PostedByCategory> {

 TextEditingController jobTitle = TextEditingController();
 TextEditingController jobDescription = TextEditingController();
 TextEditingController howLong = TextEditingController();
 TextEditingController allowance=TextEditingController();
 var counter =0;
  @override
  Widget build(BuildContext context) {
    Query postedRef = FirebaseDatabase.instance.reference()
        .child("posts")
        .orderByChild("category")
        .equalTo(widget.category);
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
                    child: Text('${widget.category}',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder(
                stream: postedRef.onValue,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.snapshot.value != null) {
                      Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                      for(var i=0;i<map.values.toList().length;i++){
                        if(map.values.toList()[i]['postedBy'] == widget.name){
                          counter++;
                          break;
                        }
                      }
                      if(counter >0 ) {
                        return ListView.builder(
                          itemBuilder: (context, int index) {
                            print(map.values.toList()[index]['postedBy']);
                            if (map.values.toList()[index]['postedBy'] == widget.name) {

                              return index % 2 == 0 ?Dismissible(
                                confirmDismiss: (direction) {
                                  return showDialog(
                                      context: context, builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Are you sure you want to delete!!'),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text('Yes'),
                                            onPressed: () {
                                              setState(() {
                                                FirebaseDatabase.instance.reference()
                                                    .child("posts").child(
                                                    map.keys.toList()[index])
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
                                key: Key(map.keys.toList()[index].toString()),
                                child: Container(

                                  margin:
                                  EdgeInsets.symmetric(horizontal: 15),
                                  child: Card(
                                    color: myColor.myBlack,
                                    child: ExpansionTile(
                                      leading: Icon(Icons.school,color: myColor.myWhite,),
                                      title:
                                          Text(map.values.toList()[index]['jobTitle'],
                                            overflow: TextOverflow.fade,
                                            style: GoogleFonts.openSans(
                                                color: myColor.myWhite,
                                                fontSize: 18),),

                                      trailing: Icon(
                                        Icons.arrow_drop_down, color: myColor.myWhite,
                                        size: 40,),
                                      subtitle:

                                          Text("${DateFormat('yMMMMd').format(DateTime.parse(map.values.toList()[index]['postedAt']))}",
                                            style: GoogleFonts.montserrat(
                                                color: myColor.myWhite,
                                                fontStyle: FontStyle.italic),),

                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              map.values.toList()[index]['status'] ==
                                                  'open' ?
                                              RaisedButton(
                                                color: myColor.myWhite,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50.0),
                                                ),
                                                child: Text('Close Job'),
                                                onPressed: () {
                                                  setState(() {
                                                    print(map.values.toList()[index]);
                                                    FirebaseDatabase.instance.reference()
                                                        .child(
                                                        "posts")
                                                        .child(map.keys.toList()[index])
                                                        .update({
                                                      'status': 'closed'
                                                    })
                                                        .then((_) {
                                                      print('done');
                                                    });
                                                  });
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.check, color: Colors.green,),
                                                    backgroundColor: Colors.green,

                                                    title: "Success",
                                                    message: "Job Closed",
                                                    duration: Duration(seconds: 3),
                                                  )
                                                    ..show(context);
                                                },
                                              ) : RaisedButton(child: Text('Post Job'),
                                                color: myColor.myWhite,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50.0),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    print(map.values.toList()[index]);
                                                    FirebaseDatabase.instance.reference()
                                                        .child(
                                                        "posts")
                                                        .child(map.keys.toList()[index])
                                                        .update({

                                                      'status': 'open'
                                                    })
                                                        .then((_) {
                                                      print('done');
                                                    });
                                                  });
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.check, color: Colors.green,),
                                                    backgroundColor: Colors.green,

                                                    title: "Success",
                                                    message: "Job Opened",
                                                    duration: Duration(seconds: 3),
                                                  )
                                                    ..show(context);
                                                },),
                                              SizedBox(width: 20),
                                              RaisedButton(
                                                color: myColor.myWhite,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50.0),
                                                ),
                                                child: Text('Edit',),
                                                onPressed: () {
                                                  jobTitle.text = map.values.toList()[index]['jobTitle'];
                                                  jobDescription.text =
                                                  "${map.values.toList()[index]['jobDescription']}";
                                                  howLong.text = map.values.toList()[index]['howLong'];
                                                  allowance.text = map.values.toList()[index]['allowance'];
                                                  return showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text('Edit Post'),
                                                          content: Container(
                                                            height: 270,
                                                            width: 350,
                                                            child: SingleChildScrollView(

                                                                child: Column(
                                                                  children: [
                                                                    ReusableTextField(jobTitle,  FilteringTextInputFormatter.deny(RegExp(r'[]')), TextInputType.text, 'Job Title', 1),
                                                                    ReusableTextField(jobDescription,
                                                                        FilteringTextInputFormatter.deny(RegExp(r'[]')),TextInputType.text,'Job Description',3),
                                                                    ReusableTextField(howLong,
                                                                        FilteringTextInputFormatter.deny(RegExp(r'[]')),TextInputType.text,'Duration',1),
                                                                    ReusableTextField( allowance,
                                                                        FilteringTextInputFormatter.digitsOnly,TextInputType.number,'Allowance',1),
                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                          actions: [

                                                            Row(
                                                              children: [
                                                                FlatButton(
                                                                  child: Text('Cancel'),
                                                                  onPressed: () {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text('Update'),
                                                                  onPressed: () async {
                                                                    FirebaseDatabase
                                                                        .instance
                                                                        .reference()
                                                                        .child(
                                                                        "posts")
                                                                        .child(map.keys
                                                                        .toList()[index])
                                                                        .update({

                                                                      'jobTitle': jobTitle
                                                                          .text,

                                                                      'jobDescription': jobDescription
                                                                          .text,

                                                                      'howLong': howLong
                                                                          .text,

                                                                      'allowance': allowance
                                                                          .text,


                                                                      'postedAt': DateFormat(
                                                                          'yyyy-MM-dd')
                                                                          .format(
                                                                          DateTime.now()),


                                                                    })
                                                                        .then((_) {
                                                                      print('done');
                                                                    });
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                    Flushbar(
                                                                      icon: Icon(
                                                                        Icons.check,
                                                                        color: Colors
                                                                            .green,),
                                                                      backgroundColor: Colors
                                                                          .green,

                                                                      title: "Sucess",
                                                                      message: "Post Updated",
                                                                      duration: Duration(
                                                                          seconds: 3),
                                                                    )
                                                                      ..show(context);
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
                                      ],


                                    ),
                                  ),
                                ),

                              ):Dismissible(
                                confirmDismiss: (direction) {
                                  return showDialog(
                                      context: context, builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Are you sure you want to delete!!'),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text('Yes'),
                                            onPressed: () {
                                              setState(() {
                                                FirebaseDatabase.instance.reference()
                                                    .child("posts").child(
                                                    map.keys.toList()[index])
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
                                key: Key(map.keys.toList()[index].toString()),
                                child: Container(

                                  margin:
                                  EdgeInsets.symmetric(horizontal: 15),
                                  child: Card(
                                    color: myColor.myWhite,
                                    child: ExpansionTile(
                                      leading: Icon(Icons.school,color: myColor.myBlack,),
                                      title:
                                      Text(map.values.toList()[index]['jobTitle'],
                                        overflow: TextOverflow.fade,
                                        style: GoogleFonts.openSans(
                                            color: myColor.myBlack,
                                            fontSize: 18),),

                                      trailing: Icon(
                                        Icons.arrow_drop_down, color: myColor.myBlack,
                                        size: 40,),
                                      subtitle:
                                          Text("${DateFormat('yMMMMd').format(DateTime.parse(map.values.toList()[index]['postedAt']))}",
                                            style: GoogleFonts.montserrat(
                                                color: myColor.myBlack,
                                                fontStyle: FontStyle.italic),),

                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              map.values.toList()[index]['status'] ==
                                                  'open' ?
                                              RaisedButton(
                                                color: myColor.myBlack,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50.0),
                                                ),
                                                child: Text('Close Job',style: TextStyle(color:myColor.myWhite),),
                                                onPressed: () {
                                                  setState(() {
                                                    print(map.values.toList()[index]);
                                                    FirebaseDatabase.instance.reference()
                                                        .child(
                                                        "posts")
                                                        .child(map.keys.toList()[index])
                                                        .update({
                                                      'status': 'closed'
                                                    })
                                                        .then((_) {
                                                      print('done');
                                                    });
                                                  });
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.check, color: Colors.green,),
                                                    backgroundColor: Colors.green,

                                                    title: "Success",
                                                    message: "Job Closed",
                                                    duration: Duration(seconds: 3),
                                                  )
                                                    ..show(context);
                                                },
                                              ) : RaisedButton(child: Text('Post Job',style: TextStyle(color:myColor.myWhite),),
                                                color: myColor.myBlack,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50.0),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    print(map.values.toList()[index]);
                                                    FirebaseDatabase.instance.reference()
                                                        .child(
                                                        "posts")
                                                        .child(map.keys.toList()[index])
                                                        .update({

                                                      'status': 'open'
                                                    })
                                                        .then((_) {
                                                      print('done');
                                                    });
                                                  });
                                                  Flushbar(
                                                    icon: Icon(
                                                      Icons.check, color: Colors.green,),
                                                    backgroundColor: Colors.green,

                                                    title: "Success",
                                                    message: "Job Opened",
                                                    duration: Duration(seconds: 3),
                                                  )
                                                    ..show(context);
                                                },),
                                              SizedBox(width: 20),
                                              RaisedButton(
                                                color: myColor.myBlack,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50.0),
                                                ),
                                                child: Text('Edit',style: TextStyle(color:myColor.myWhite),),
                                                onPressed: () {
                                                  jobTitle.text = map.values.toList()[index]['jobTitle'];
                                                  jobDescription.text =
                                                  "${map.values.toList()[index]['jobDescription']}";
                                                  howLong.text = map.values.toList()[index]['howLong'];
                                                  allowance.text = map.values.toList()[index]['allowance'];
                                                  return showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text('Edit Post'),
                                                          content: Container(
                                                            height: 270,
                                                            width: 350,
                                                            child: SingleChildScrollView(

                                                                child: Column(
                                                                  children: [
                                                                    ReusableTextField(jobTitle,  FilteringTextInputFormatter.deny(RegExp(r'[]')), TextInputType.text, 'Job Title', 1),
                                                                    ReusableTextField(jobDescription,
                                                                        FilteringTextInputFormatter.deny(RegExp(r'[]')),TextInputType.text,'Job Description',3),
                                                                    ReusableTextField(howLong,
                                                                        FilteringTextInputFormatter.deny(RegExp(r'[]')),TextInputType.text,'Duration',1),
                                                                    ReusableTextField( allowance,
                                                                        FilteringTextInputFormatter.digitsOnly,TextInputType.number,'Allowance',1),
                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                          actions: [

                                                            Row(
                                                              children: [
                                                                FlatButton(
                                                                  child: Text('Cancel'),
                                                                  onPressed: () {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text('Update'),
                                                                  onPressed: () async {
                                                                    FirebaseDatabase
                                                                        .instance
                                                                        .reference()
                                                                        .child(
                                                                        "posts")
                                                                        .child(map.keys
                                                                        .toList()[index])
                                                                        .update({

                                                                      'jobTitle': jobTitle
                                                                          .text,

                                                                      'jobDescription': jobDescription
                                                                          .text,

                                                                      'howLong': howLong
                                                                          .text,

                                                                      'allowance': allowance
                                                                          .text,


                                                                      'postedAt': DateFormat(
                                                                          'yyyy-MM-dd')
                                                                          .format(
                                                                          DateTime.now()),


                                                                    })
                                                                        .then((_) {
                                                                      print('done');
                                                                    });
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                    Flushbar(
                                                                      icon: Icon(
                                                                        Icons.check,
                                                                        color: Colors
                                                                            .green,),
                                                                      backgroundColor: Colors
                                                                          .green,

                                                                      title: "Sucess",
                                                                      message: "Post Updated",
                                                                      duration: Duration(
                                                                          seconds: 3),
                                                                    )
                                                                      ..show(context);
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
                                      ],


                                    ),
                                  ),
                                ),

                              );
                            }
                            return Container();
                          },
                          itemCount: map.values
                              .toList()
                              .length,
                        );
                      }

                    }
                  } else {
                    return SpinKitWave(color: myColor.myBlack,);
                  }
                  return Center(child: Text('No post from this category'));
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PostJob(widget.category)));
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: Icon(Icons.add, size: 25, color: Colors.pink,),
      ),
    );
  }
}
