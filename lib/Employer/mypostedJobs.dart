import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:intl/intl.dart';


class MyPostedJob extends StatefulWidget {

  String name;
  MyPostedJob(this.name);
  @override

  _MyPostedJobState createState() => _MyPostedJobState();
}

class _MyPostedJobState extends State<MyPostedJob> {
  DatabaseReference myAppRef;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text('My Posted Jobs')
          ,backgroundColor: Colors.black,
        ),
        body: StreamBuilder(
          stream:FirebaseDatabase.instance.reference().child('posts').orderByChild('postedBy').equalTo(widget.name).onValue,
          builder: (BuildContext context,  snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data.snapshot.value!=null){
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
print("hello ${map.keys}");
//                    print(map.values.toList());

                return ListView.builder(
                  itemCount: map.values.toList().length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(

                      key:Key(map.values.toList()[index].toString()),
                      confirmDismiss:(direction){

                        return showDialog(context: context,builder: (context){
                          return AlertDialog(
                            title: Text(
                                'Are you sure you want to delete!!'),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    setState(() {
                                      FirebaseDatabase.instance.reference().child("posts").child(map.keys.toList()[index]).remove();
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
                        });},
                      child: Container(
                        width: 120,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Card(
                          color: myColor.myBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                              leading: Icon(
                                Icons.work,
                                color: Colors.red,
                                size: 40,
                              ),
                              title: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Position : ',style: TextStyle(
                                        color: myColor.myWhite,)),
                                      Text(
                                        map.values.toList()[index]['jobTitle'],
                                        style: TextStyle(
                                            color: myColor.myWhite,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  )),
                              subtitle: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Category :',style: TextStyle(
                                        color: myColor.myWhite,)),
                                      Text(
                                        map.values.toList()[index]['category'],
                                        style: TextStyle(
                                            color: myColor.myWhite,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  )),
                              trailing: map.values.toList()[index]['status'] == 'open'?RaisedButton(
                                child: Text('Close'),
                                onPressed: (){
                                  setState(() {
                                  print(map.values.toList()[index]);
                                  FirebaseDatabase.instance.reference().child("posts").child(map.keys.toList()[index])
                                      .update({

                                    'jobTitle':map.values.toList()[index]['jobTitle'],

                                    'jobDescription':map.values.toList()[index]['jobDescription'],

                                    'howLong' :map.values.toList()[index]['howLong'],

                                    'companyName':map.values.toList()[index]['companyName'],

                                    'allowance':map.values.toList()[index]['allowance'],

                                    'category':map.values.toList()[index]['category'],

                                    'postedBy':map.values.toList()[index]['postedBy'],

                                    'postedAt':DateFormat('yyyy-MM-dd').format(DateTime.now()),

                                    'status': 'closed'
                                  }).then((_){
                                    print('done');
                                  });
                                  });
                                  Flushbar(
                                    icon: Icon(Icons.check,color: Colors.green,),
                                    backgroundColor: Colors.green,

                                    title:  "Sucess",
                                    message:  "Job Closed",
                                    duration:  Duration(seconds: 3),
                                  )..show(context);
                                },
                              ):Text('Already Closed')
                          ),
                        ),
                      ),
                    );
                  },
                );}


            }
            else{
              return SpinKitWave(
                color: Colors.pink,
              );

            }
            return Center(child: Text('No Posted Job yet'),);

          },
        )
    );
  }
}
