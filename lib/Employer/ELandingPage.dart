import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Employer/PostJob.dart';
import 'package:internship_platform/Employer/PostedByCategory.dart';
import 'package:internship_platform/Employer/createCategory.dart';
import 'package:internship_platform/Employer/mypostedJobs.dart';
import 'package:internship_platform/Employer/sentApplications.dart';
import 'package:internship_platform/Intern/ApplyforJob.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/authService.dart';
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
  String name;
  LandingPage(this.name);
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.myBlack,
      appBar: AppBar(
        backgroundColor: myColor.myBlack,
        title: Text('Landing Page'),

      ),
      drawer:Drawer(
        child: ListView(
          children: <Widget>[
            InkWell(
              child: ListTile(
                leading: Icon(Icons.send),
                title: Text('My Posted Jobs'),
              ),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyPostedJob(widget.name)));
              },
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.send),
                title: Text('Sent Application'),
              ),
              onTap: (){
                Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>sentApplications()));
              },
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.category),
                title: Text('Create Category'),
              ),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>createCategory()));
              },
            ),

            InkWell(
              child:ListTile(
                leading:Icon(Icons.visibility_off),
                title:Text('Log out')
              ),
              onTap: (){
                AuthService().signOut();
                Navigator.of(context).pop();
              },
            )

          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              "Categories",
              style: TextStyle(color: myColor.myWhite, fontSize: 18),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: FirebaseDatabase.instance.reference().child("Categories").onValue,
                builder: (BuildContext context,snapshot){
                  if(snapshot.hasData){
                    Map<dynamic,dynamic> map = snapshot.data.snapshot.value;
                    print(map.values.toList());
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        mainAxisSpacing: 25,
                        crossAxisSpacing: 25),
                      itemCount:map.values.toList().length ,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder:(context)=>PostedByCategory(widget.name,map.values.toList()[index]['type'].toString())));
                          },
                          child: Card(
                              color: myColor.myPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[
                                  Icon(Icons.category,size: 50,),
                                  Center(

                                          child: Text(

                                            map.values.toList()[index]['type'],
                                            style: TextStyle(color: myColor.myWhite,),
                                          )

                                  ),
                                ],
                              )
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


    );
  }
}
