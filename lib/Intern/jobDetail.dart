import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Providers/Apply.dart';
import 'package:internship_platform/Utilities/variables.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/model/ApplyForJob.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class jobDetail extends StatelessWidget {

  String jobTitle;
  String jobDescription;
  String postedBy;
  String category;
  String postedAt;
  String allowance;
  String howLong;
  String companyName;
  String token;
  jobDetail(this.jobTitle, this.jobDescription, this.postedBy, this.category,
      this.postedAt, this.allowance, this.howLong, this.companyName,this.token);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.myBackground,
      appBar: AppBar(title:Text("Detail"),backgroundColor: myColor.myBackground,),
      body: SafeArea(
        child: Column(
          children: [



            Padding(


              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(


                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(

                          child: Icon(Icons.school,color: myColor.myWhite,size: 25,),
                        ),
                      ),
                       SizedBox(height: 15),
                       Text(
                        jobTitle,overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cabinCondensed(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                            color: myColor.myWhite),
                      ),
                    ]
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    subtitle: Row(
                      children: [
                        Text(
                          '${DateFormat('yMMMMd').format(DateTime.parse(postedAt))}',
                          style: GoogleFonts.scada(
                              fontSize: 16, color: myColor.myDarkGrey),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                          child: allowance!="0"?Text(
                            "$allowance birr",
                            style: GoogleFonts.scada(
                                fontSize: 16, color: myColor.myBlack),
                          ):Text("No Allowance"),
                          decoration: BoxDecoration(
                              color: myColor.myYellow,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                     companyName,
                        style: GoogleFonts.scada(
                            fontSize: 18, color: myColor.myWhite),
                      ),
                      Text(
                        'Duration : $howLong',
                        style: GoogleFonts.scada(
                            fontSize: 16, color: myColor.myLightGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: myColor.myBackground,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        15,
                      ),
                      bottomRight: Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Text(
                        'Description',
                        style: GoogleFonts.delius(
                            fontSize: 20,
                            color: myColor.myWhite,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:
                            ListView(scrollDirection: Axis.vertical, children: [
                          Text(
                            jobDescription,
                            style: GoogleFonts.scada(
                              fontSize: 16,
                              color: myColor.myDarkGrey,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: myColor.myGreen,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        15,
                      ),
                      topRight: Radius.circular(15)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child:  Consumer<Apply>(
               builder: (_, application, __)=>
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 0,
                        child: SizedBox(
                          height: 50,
                          child: RaisedButton(
                            color: myColor.myWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: myColor.myDarkGrey,
                                    width: 0.25,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(

                              children: [
                                application.isFileChosen
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: [
                                          Text("$fullName",
                                              style: GoogleFonts.delius(
                                                  fontWeight: FontWeight.w600,
                                                  color: myColor.myBlack,
                                                  fontSize: 20)),
                                          Text(".pdf")
                                        ],
                                      )
                                    : Column(

                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Upload CV",overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.delius(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: myColor.myBlack),
                                          ),

                                        Text("(Max 500KB)", style: TextStyle(
                                            fontSize: 12,
                                            color: myColor.myBlack),overflow: TextOverflow.ellipsis)
                                      ],
                                    ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.file_upload)
                              ],
                            ),
                            onPressed: () async {
                              application.chooseFile();
                              // setState(() {});
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(

                        child: SizedBox(
                          height: 50,
                          child: application.isloading
                                ? SpinKitWave(color: myColor.myBlack, size: 20)
                                : RaisedButton(
                                    color: myColor.myBlack,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    onPressed: () async {
                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());
                                      connected = ((connectivityResult ==
                                              ConnectivityResult.wifi) ||
                                          (connectivityResult ==
                                              ConnectivityResult.mobile));
                                      print("connected $connected");

                                      if (application.isFileChosen) {
                                        if (connected) {
                                          if (file.lengthSync() > 500000) {
                                            print(
                                                "file size is ${file.lengthSync()}");
                                            Flushbar(
                                              icon: Icon(
                                                Icons.error,
                                                color: Colors.black,
                                              ),
                                              backgroundColor: Colors.red,
                                              title: "Wrong",
                                              message:
                                                  "File size must not exceed 500KB",
                                              duration: Duration(seconds: 3),
                                            )..show(context);
                                          } else {
                                              application.submitApplication(
                                                ApplyForJob(
                                                    category: category,
                                                    AppliedTo: postedBy,
                                                    jobTitle: jobTitle,
                                                  token:token
                                                ));
                                            Flushbar(
                                              icon: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              backgroundColor: Colors.green,
                                              title: "Success",
                                              message:
                                                  "Application posted successfully",
                                              duration: Duration(seconds: 3),
                                            )..show(context);
                                            file = null;
                                          }
                                        } else {
                                          Flushbar(
                                            icon: Icon(
                                              Icons.error,
                                              color: Colors.black,
                                            ),
                                            backgroundColor: Colors.red,
                                            title: "Error",
                                            message: "No Internet Connection",
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        }
                                      } else {
                                        Flushbar(
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.black,
                                          ),
                                          backgroundColor: Colors.red,
                                          title: "Wrong",
                                          message: "Upload Cv",
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                      }
                                    },
                                    child: Text(
                                      'Apply',
                                      style: GoogleFonts.delius(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: myColor.myWhite),
                                    ),
                                  ),
                          ),
                        ),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
