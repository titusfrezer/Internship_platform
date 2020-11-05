import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Intern/Utilities/variables.dart';

class InternWelcomePage extends StatefulWidget {
  @override
  _InternWelcomePageState createState() => _InternWelcomePageState();
}

class _InternWelcomePageState extends State<InternWelcomePage> {
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
            backgroundColor: myColor.myLightGrey,
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Hi Intern',
                style: TextStyle(
                    color: myColor.myWhite,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: myColor.myLightGrey,
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    icon: Icon(
                      Icons.search,
                      color: myColor.myBlack,
                    )),
                cursorColor: myColor.myBlack,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "Categories",
                    style: TextStyle(color: myColor.myWhite, fontSize: 18),
                  ),
                ),
                Container(
                    height: 75,
                    child: ListView.builder(
                      itemCount: 20,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 75,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            color: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                                child: Text(
                              "Software",
                              style: TextStyle(color: myColor.myWhite),
                            )),
                          ),
                        );
                      },
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: myColor.myWhite,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Your Choice",
                      style: TextStyle(fontFamily: 'Oswald', fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.favorite,
                                  color: Colors.purple,
                                ),
                                title: Text("Flutter Developer"),
                                subtitle: Text("Adika Taxi"),
                                trailing: FlatButton(
                                    onPressed: () {}, child: Text("Detail")),
                              );
                            })),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
