import 'package:connectivity/connectivity.dart';
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
   bool connected =false;
  void getUser() async {
    print(_auth);

      currentUser = await _auth.currentUser();
    var connectivityResult =
    await (Connectivity()
        .checkConnectivity());
    print(connectivityResult);
    if ((connectivityResult ==
        ConnectivityResult.wifi) ||
        connectivityResult ==
            ConnectivityResult.mobile) {
      connected = true;
      print('connected');
      setState(() {});
    } else {
      print('not connected');
    }


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
        body: !connected ?Center(child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 40,
            ),
            FlatButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius:
                    BorderRadius.circular(50)),
                onPressed: () async {
                  var connectivityResult =
                  await (Connectivity()
                      .checkConnectivity());
                  print(connectivityResult);
                  if ((connectivityResult ==
                      ConnectivityResult.wifi) ||
                      connectivityResult ==
                          ConnectivityResult.mobile) {
                    connected = true;
                    print('connected');
                    setState(() {});
                  } else {
                    print('not connected');
                  }
                },
                child: Text('Retry',
                    style:
                    TextStyle(color: Colors.black)))
          ],
        )):StreamBuilder(
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
//              background: Container(color:Colors.red,child:Text('Delete')),
                      key:Key(map.keys.toList()[index].toString()),
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
                          child: ExpansionTile(
                            leading: Icon(
                              Icons.work,
                              color: Colors.red,
                              size: 40,
                            ),
                            title: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text('Applied Position : ',style: TextStyle(
                                  color: myColor.myWhite,)),
                                    SizedBox(height: 10,),
                                    Text(
                                      map.values.toList()[index]['jobTitle'],
                                      style: TextStyle(
                                          color: myColor.myWhite,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                )),
                                trailing: Icon(
                                    Icons.arrow_drop_down,
                                    color:Colors.pink,
                                size: 40,),
                            children: [
                              Padding(
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
                                  ))
                            ],
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
