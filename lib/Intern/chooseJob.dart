import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/Intern/jobDetail.dart';


class chooseJob extends StatefulWidget {
  @override
  _chooseJobState createState() => _chooseJobState();
  String Category;

  chooseJob(this.Category);
}



class _chooseJobState extends State<chooseJob> {
  List chooseJobList = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Query chooseRef = FirebaseDatabase.instance
        .reference()
        .child("posts")
        .orderByChild('category')
        .equalTo(widget.Category);

    return Scaffold(

        backgroundColor: myColor.myBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Internship Platform",
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
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(widget.Category,
                    style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: myColor.myBlack)),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: chooseRef.onValue,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {

                       chooseJobList.clear();

                      if (snapshot.data.snapshot.value != null) {
                        Map<dynamic, dynamic> map =
                            snapshot.data.snapshot.value;
                        var counter = 0;
                        for (var i = 0; i < map.values.toList().length; i++) {
                          if (map.values.toList()[i]['status'] == 'closed') {
                            counter++;
                          }
                          else if (map.values.toList()[i]['status'] == 'open'){
                            chooseJobList.add(map.values.toList()[i]);
                          }
                        }

//                    print("the count is$counter and the list size is ${map.values.toList().length}");
                        // if all of post are closed!!
                        if (counter == map.values.toList().length) {
                          return Center(
                              child: Text('No post from ${widget.Category}'));
                        } else {
                          return ListView.builder(
                            itemCount: chooseJobList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {

                                return index % 2 == 0? Container(
                                  width: 120,
                                  height: 100,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Card(
                                    color: myColor.myBlack,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.school,
                                        color: myColor.myWhite,
                                        size: 40,
                                      ),
                                      title: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            chooseJobList[index]
                                                ['jobTitle'],
                                            overflow: TextOverflow.fade,
                                            style: GoogleFonts.openSans(
                                                color: myColor.myWhite,
                                                fontSize: 18),
                                          )),
                                      subtitle: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            chooseJobList[index]
                                                ['companyName'],
                                            style: GoogleFonts.montserrat(
                                                color: myColor.myWhite,
                                                fontStyle: FontStyle.italic),
                                          )),
                                      trailing: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => jobDetail(
                                                    chooseJobList[index]
                                                        ['jobTitle'],
                                                    chooseJobList[index]
                                                            ['jobDescription']
                                                        .toString(),
                                                    chooseJobList[index]
                                                        ['postedBy'],
                                                    chooseJobList[index]
                                                        ['category'],
                                                    chooseJobList[index]
                                                        ['postedAt'],
                                                    chooseJobList[index]
                                                        ['allowance'],
                                                    chooseJobList[index]
                                                        ['howLong'],
                                                    chooseJobList[index]
                                                        ['companyName'])));
                                          },
                                          child: Text(
                                            'See more',
                                            style: GoogleFonts.delius(color: myColor.myWhite,fontWeight: FontWeight.w500),
                                          )),
                                    ),
                                  ),
                                ):Container(
                                  width: 120,
                                  height: 100,
                                  margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                  child: Card(
                                    color: myColor.myWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.school,
                                        color: myColor.myBlack,
                                        size: 40,
                                      ),
                                      title: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            chooseJobList[index]
                                            ['jobTitle'],
                                            overflow: TextOverflow.fade,
                                            style: GoogleFonts.openSans(
                                                color: myColor.myBlack,
                                                fontSize: 18),
                                          )),
                                      subtitle: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            chooseJobList[index]
                                            ['companyName'],
                                            style: GoogleFonts.montserrat(
                                                color: myColor.myDarkGrey,
                                                fontStyle: FontStyle.italic),
                                          )),
                                      trailing: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => jobDetail(
                                                    chooseJobList[index]
                                                    ['jobTitle'],
                                                    chooseJobList[index]
                                                    ['jobDescription']
                                                        .toString(),
                                                    chooseJobList[index]
                                                    ['postedBy'],
                                                    chooseJobList[index]
                                                    ['category'],
                                                    chooseJobList[index]
                                                    ['postedAt'],
                                                    chooseJobList[index]
                                                    ['allowance'],
                                                    chooseJobList[index]
                                                    ['howLong'],
                                                    chooseJobList[index]
                                                    ['companyName'])));
                                          },
                                          child: Text(
                                            'See more',
                                            style: GoogleFonts.delius(color: myColor.myBlack,fontWeight: FontWeight.w500),
                                          )),
                                    ),
                                  ),
                                );

                            },
                          );
                        }
                      }
                    } else {
                      return SpinKitWave(
                        color: myColor.myBlack,
                      );
                    }

                    return Center(
                        child: Text('No post from ${widget.Category}'));
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
