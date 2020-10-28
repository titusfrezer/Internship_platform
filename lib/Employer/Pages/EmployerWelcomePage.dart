import 'package:flutter/material.dart';

import '../../Utilities/variables.dart';

class EmployerWelcomePage extends StatefulWidget {
  @override
  _EmployerWelcomePageState createState() => _EmployerWelcomePageState();
}

class _EmployerWelcomePageState extends State<EmployerWelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Intern Platform"),
        elevation: 0.0,
        backgroundColor: myColor.myBlack,
        actions: [
          CircleAvatar(
            backgroundColor: myColor.myGrey,
            child: Icon(Icons.person),
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text("My Profile"),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text("My Applications"),
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


            Expanded(
              child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Text(
                      "Categories",
                      style: TextStyle(color: myColor.myWhite, fontSize: 18),
                    ),
                  ),
                  Expanded(

                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 15),
                        itemCount: 20,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 75,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              color: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  CircleAvatar(backgroundColor: myColor.myGrey,radius: 30,
                                  child: Text("S",style: TextStyle(color: Colors.purple),),),
                                 SizedBox(
                                height: 20,
                            ),
                                  Container(
                                      child: Text(
                                        "Software",
                                        style: TextStyle(color: myColor.myWhite,fontSize: 18),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
