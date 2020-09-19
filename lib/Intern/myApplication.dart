import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
class MyApplication extends StatefulWidget {

  String name;
  MyApplication(this.name);
  @override

  _MyApplicationState createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  DatabaseReference myAppRef;
  FirebaseUser currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void getUser() async {
    print(_auth);

      currentUser = await _auth.currentUser();



  }

  void initState() {
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('My Application')
            ,backgroundColor: Colors.black,
      ),
        body: StreamBuilder(
          stream:FirebaseDatabase.instance.reference().child('application').orderByChild('ApplierEmail').equalTo(widget.name).onValue,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              print(currentUser!=null?currentUser.email:'no user');
          if(snapshot.data.snapshot.value!=null){
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

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
                                      FirebaseDatabase.instance.reference().child("application").child(map.keys.toList()[index]).remove();
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
                                    Text('Applied Position : ',style: TextStyle(
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
                                    Text('Application Sent To :',style: TextStyle(
                                  color: myColor.myWhite,)),
                                    Text(
                                      map.values.toList()[index]['AppliedTo'],
                                      style: TextStyle(
                                          color: myColor.myWhite,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                )),
                            trailing: Icon(Icons.check,size:35,color: Colors.red,)
                          ),
                        ),
                      ),
                    );
                  },
                );}
          else{
            return Center(child: Text('No Application yet'),);
          }

            }

            return SpinKitWave(
              color: Colors.pink,
            );
          },
        )
    );
  }
}
