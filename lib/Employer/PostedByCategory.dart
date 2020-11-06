import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Employer/PostJob.dart';
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
      appBar: AppBar(
        title: Text('${widget.category}'),
        backgroundColor: myColor.myBlack,
      ),
      body: StreamBuilder(
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
                    print("the suer s ${widget.name}");
                    print(map.values.toList()[index]['postedBy']);
                    if (map.values.toList()[index]['postedBy'] == widget.name) {
                      jobTitle.text = map.values.toList()[index]['jobTitle'];
                      jobDescription.text =
                      "${map.values.toList()[index]['jobDescription']}";
                      howLong.text = map.values.toList()[index]['howLong'];
                      allowance.text = map.values.toList()[index]['allowance'];
                      return Dismissible(background: Container(color: Colors
                          .pink,
                        child: Center(child: Text('Delete')),),
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
                        child: Card(
                          color: myColor.myBlack,
                          child: ExpansionTile(
                            leading: Icon(Icons.work, color: Colors.pink),
                            title: Row(
                              children: [
                                Text('Job Title  - ',
                                    style: TextStyle(color: Colors.white)),
                                Text(map.values.toList()[index]['jobTitle'],
                                  style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_drop_down, color: Colors.pink,
                              size: 40,),
                            subtitle: Row(
                              children: [

                                Text('Posted At  - ',
                                    style: TextStyle(color: Colors.white)),
                                Text(map.values.toList()[index]['postedAt'],
                                  style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    map.values.toList()[index]['status'] ==
                                        'open' ?
                                    RaisedButton(
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

                                          title: "Sucess",
                                          message: "Job Closed",
                                          duration: Duration(seconds: 3),
                                        )
                                          ..show(context);
                                      },
                                    ) : RaisedButton(child: Text('Post Job'),
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

                                          title: "Sucess",
                                          message: "Job Opened",
                                          duration: Duration(seconds: 3),
                                        )
                                          ..show(context);
                                      },),
                                    SizedBox(width: 20),
                                    RaisedButton(
                                      child: Text('Edit',),
                                      onPressed: () {
                                        return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Edit Post'),
                                                content: Container(
                                                  height: 250,
                                                  width: 350,
                                                  child: SingleChildScrollView(

                                                      child: Column(
                                                        children: [
                                                          TextField(
                                                            controller: jobTitle,
                                                            decoration: InputDecoration(
                                                                labelText: 'Job Title'
                                                            ),
                                                          ),
                                                          TextField(
                                                            minLines: 2,
                                                            maxLines: 4,
                                                            controller: jobDescription,
                                                            decoration: InputDecoration(
                                                                labelText: 'Job Description'
                                                            ),

                                                          ),
                                                          TextField(
                                                            controller: howLong,
                                                            decoration: InputDecoration(
                                                                labelText: 'For How Long '
                                                            ),
                                                          ),
                                                          TextField(
                                                            controller: allowance,
                                                            decoration: InputDecoration(
                                                                labelText: 'Allowance(In Birr)'
                                                            ),
                                                          ),
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

                      );
                    }
                    return Container();
                  },
                  itemCount: map.values
                      .toList()
                      .length,
                );
              }
              else{
                return Center(child:Text("No post from this category"));
              }
            }
          } else {
            return SpinKitWave(color: Colors.pink,);
          }
          return Center(child: Text('No post from this category'));
        },
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
