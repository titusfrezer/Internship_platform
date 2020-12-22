import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Utilities/variables.dart';
class MyApplication extends StatefulWidget {

  String name;
  MyApplication(this.name);
  @override

  _MyApplicationState createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  DatabaseReference myAppRef;

  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.myBackground,
      appBar: AppBar(
        title:Text('My Application')
            ,backgroundColor: myColor.myBackground,
      ),
        body: !connected ?Center(child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              color: myColor.myWhite,
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

          if(snapshot.data.snapshot.value!=null){
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

//                    print(map.values.toList());

                return ListView.builder(
                  itemCount: map.values.toList().length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return index % 2 == 0 ?Dismissible(

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
                          color: index % 2 == 0
                              ? (index % 3 == 0? myColor.myYellow:myColor.myGreen)
                              : index % 3 == 0
                              ? myColor.myBlue
                              : myColor
                              .myYellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ExpansionTile(
                            leading: Icon(
                              Icons.work,
                              color: Colors.white,
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
                                      style: GoogleFonts.alice(
                                          color: myColor.myWhite,
                                          fontSize: 15),
                                    ),
                                  ],
                                )),
                                trailing: Icon(
                                    Icons.arrow_drop_down,
                                    color:Colors.white,
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

                    ):Dismissible(
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
                          color: myColor.myWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ExpansionTile(
                            leading: Icon(
                              Icons.work,
                              color: Colors.black,
                              size: 40,
                            ),
                            title: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text('Applied Position : ',style: TextStyle(
                                      color: myColor.myBlack,)),
                                    SizedBox(height: 10,),
                                    Text(
                                      map.values.toList()[index]['jobTitle'],
                                      style: GoogleFonts.openSans(
                                          color: myColor.myBlack,
                                          fontSize: 15),
                                    ),
                                  ],
                                )),
                            trailing: Icon(
                              Icons.arrow_drop_down,
                              color:Colors.black,
                              size: 40,),
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Application Sent To :',style: TextStyle(
                                        color: myColor.myBlack,)),
                                      Text(
                                        map.values.toList()[index]['AppliedTo'],
                                        style: TextStyle(
                                            color: myColor.myBlack,
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
            return Center(child: Text('No Application yet',style: TextStyle(color: myColor.myWhite),),);
          }

            }

            return SpinKitWave(
              color: Colors.black,
              size:24
            );
          },
        )
    );
  }
}
