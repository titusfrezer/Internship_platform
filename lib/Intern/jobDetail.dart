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
  var client;
  var fullName;
  var email;
  var furtherInfo;

  DatabaseReference applyRef =
      FirebaseDatabase.instance.reference().child('application');
  var file;
  var isloading = false;


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    firebaseAuth = FirebaseAuth.instance;
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

    });

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
      'jobTitle': widget.jobTitle
    });
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.myBackground,
      // appBar: AppBar(
      //   title: Text('Apply'),
      //   backgroundColor: Colors.black,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            ClipPath(
              // clipper: WaveClipper1(),

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
                // child: Column(
                //   children: <Widget>[
                //     SizedBox(
                //       height: 40,
                //     ),
                //     Icon(
                //       Icons.work,
                //       color: Colors.pink,
                //       size: 60,
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     Text(
                //      "Job Title : ${ widget.jobTitle}",
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.w700,
                //           fontSize: 30),
                //     ),
                //   ],
                // ),
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
            Expanded(child:         Container(
              margin: EdgeInsets.symmetric( horizontal: 20,vertical: 10),

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
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
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
            ),),
            Align(
              alignment: Alignment.bottomCenter,
              child:Container(

                decoration: BoxDecoration(
                  color: myColor.myWhite,
                  borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(
                        15,
                      ),
                    topRight: Radius.circular(15)),
                ),

                padding: EdgeInsets.symmetric(horizontal:20,vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Container(
                      height: 50,
                      width:125,
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
                            Text("Upload CV",style:GoogleFonts.delius(

                            fontWeight: FontWeight.w600,
                            color: myColor.myBlack),),
                            Icon(Icons.file_upload)
                          ],
                        ),
                        onPressed: () async {
                          file = await FilePicker.getFile(
                              type: FileType.CUSTOM, fileExtension: 'pdf');

//                    String fileName = '${applierName.text}.pdf';
//                    print(fileName);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(

                      child: SizedBox(
                        height: 50,
                        child: RaisedButton(
                          color: myColor.myBlack,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () async {
                            setState(() {
                              isloading = true;
                            });
                            if (file != null) {
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
                              )..show(context);
                              file = null;
                            } else {
                              setState(() {
                                isloading = false;
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
                          child: isloading
                              ? SpinKitWave(
                            color: Colors.pinkAccent,
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
