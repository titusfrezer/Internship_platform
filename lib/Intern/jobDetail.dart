import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/util/dbclient.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class jobDetail extends StatefulWidget {
  @override
  _jobDetailState createState() => _jobDetailState();

  String jobTitle;
  String jobDescription;
  String postedBy;
  String category;
  String postedAt;
  String allowance;
  String howLong;
  String companyName;

  jobDetail(this.jobTitle, this.jobDescription, this.postedBy, this.category,
      this.postedAt, this.allowance, this.howLong, this.companyName);
}

class _jobDetailState extends State<jobDetail> {
  
  DatabaseReference applyRef =
      FirebaseDatabase.instance.reference().child('application');
  File file;
  var telegram;
  var github;

  @override
  void initState() {

    // TODO: implement initState
isLoading = false;
    super.initState();
    getInfo();
  }

  getInfo() async {
    user = await firebaseAuth.currentUser();

    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .orderByChild('email')
        .equalTo(user.email)
        .once()
        .then((DataSnapshot snapshot) {
      Map map = snapshot.value;
      print("map is ${map.values.toList()}");
      fullName = map.values.toList()[0]['userName'];
      furtherInfo = map.values.toList()[0]['furtherInfo'];
      imageurl = map.values.toList()[0]['url'];
      telegram = map.values.toList()[0]['telegram'];
      github = map.values.toList()[0]['github'];
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    connected = ((connectivityResult == ConnectivityResult.wifi) ||
        (connectivityResult == ConnectivityResult.mobile));
    print("connected $connected");
  }

  postToFirebase() async {
    StorageReference reference =
        FirebaseStorage.instance.ref().child('$fullName.pdf');
    StorageUploadTask uploadTask = reference.putData(file.readAsBytesSync());

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);

    applyRef.push().set(<dynamic, dynamic>{
      'ApplierName': fullName,
      'ApplierEmail': user.email,
      'ApplierExpertise': furtherInfo,
      'cvUrl': url,
      'category': widget.category,
      'AppliedTo': widget.postedBy,
      'jobTitle': widget.jobTitle,
      'imageUrl':imageurl,
      'telegram': telegram,
      'github':github
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.myBackground,

      body: SafeArea(
        child: Column(
          children: [
            ClipPath(
            child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: myColor.myWhite,
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: myColor.myBlack,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ),
                ),

                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                    color: myColor.myBlack,
                    image: DecorationImage(
                        image: AssetImage("image/internship.jpg"),
                        fit: BoxFit.fill)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      15,
                    ),
                    bottomRight: Radius.circular(15)),
                color: Colors.white,
              ),
              height: 150,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      widget.jobTitle,
                      style: GoogleFonts.cabinCondensed(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: myColor.myBlack),
                    ),
                    contentPadding: EdgeInsets.all(0),
                    subtitle: Row(
                      children: [
                        Text(
                          '${DateFormat('yMMMMd').format(DateTime.parse(widget.postedAt))}',
                          style: GoogleFonts.scada(
                              fontSize: 16, color: myColor.myDarkGrey),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                          child: Text(
                            widget.allowance,
                            style: GoogleFonts.scada(
                                fontSize: 16, color: myColor.myBlack),
                          ),
                          decoration: BoxDecoration(
                              color: myColor.myBackground,
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
                        widget.companyName,
                        style: GoogleFonts.scada(
                            fontSize: 18, color: myColor.myBlack),
                      ),
                      Text(
                        'Duration : ${widget.howLong}',
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
                  color: myColor.myWhite,
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
                            color: myColor.myBlack,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:
                            ListView(scrollDirection: Axis.vertical, children: [
                          Text(
                            widget.jobDescription,
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
                  color: myColor.myWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        15,
                      ),
                      topRight: Radius.circular(15)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height:50,
                        child: RaisedButton(
                          color: myColor.myWhite,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: myColor.myDarkGrey,
                                  width: 0.25,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              file != null
                                  ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("$fullName",
                                          style: GoogleFonts.delius(
                                              fontWeight: FontWeight.w600,
                                              color: myColor.myBlack,fontSize: 13)),
                                      Text(".pdf")
                                    ],
                                  )
                                  : Text(
                                        "Upload CV (Max 500KB)",
                                        style: GoogleFonts.delius(
                                          fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: myColor.myBlack),
                                      ),

                              Icon(Icons.file_upload)
                            ],
                          ),
                          onPressed: () async {

                            file = await FilePicker.getFile(
                                type: FileType.CUSTOM, fileExtension: 'pdf');
                            setState(() {

                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex:2,
                      child: SizedBox(
                        height: 50,
                        child: RaisedButton(
                          color: myColor.myBlack,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () async {
                            var connectivityResult = await (Connectivity().checkConnectivity());
                            connected = ((connectivityResult == ConnectivityResult.wifi) ||
                                (connectivityResult == ConnectivityResult.mobile));
                            print("connected $connected");
                            setState(() {
                              isLoading = true;
                            });

                            if (file != null) {
                              if (connected) {
                                if(file.lengthSync()>500000){
                                  print("file size is ${file.lengthSync()}");
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Flushbar(
                                    icon: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                    backgroundColor: Colors.red,
                                    title: "Wrong",
                                    message: "File size must not exceed 500KB",
                                    duration: Duration(seconds: 3),
                                  )..show(context);
                                }else {
                                  await postToFirebase();
                                  Flushbar(
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    backgroundColor: Colors.green,
                                    title: "Success",
                                    message: "Application posted successfully",
                                    duration: Duration(seconds: 3),
                                  )
                                    ..show(context);
                                  file = null;
                                }
                              } else {
                                Flushbar(
                                  icon: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                  backgroundColor: Colors.red,
                                  title: "Error",
                                  message: "No Internet Connection",
                                  duration: Duration(seconds: 3),
                                )
                                  ..show(context);
                                setState(() {
                                  isLoading = false;
                                  file = null;
                                });
                              }
                            }
                            else {
                              setState(() {
                                isLoading = false;
                              });
                              Flushbar(
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                backgroundColor: Colors.red,
                                title: "Wrong",
                                message: "Upload Cv",
                                duration: Duration(seconds: 3),
                              )..show(context);
                            }
                          },
                          child: isLoading
                              ? SpinKitWave(
                                  color: myColor.myWhite,
                            size:20
                                )
                              : Text(
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
            )
          ],
        ),
      ),
    );
  }
}
