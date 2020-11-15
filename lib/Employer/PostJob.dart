import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:intl/intl.dart';

String initdata = "Mechanical Engineering";

class PostJob extends StatefulWidget {
  @override
  _PostJobState createState() => _PostJobState();

  String category;

  PostJob(this.category);
}

class _PostJobState extends State<PostJob> {
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController forhowLong = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController allowanceController = TextEditingController();
  var isloading = false;
  DatabaseReference postRef =
      FirebaseDatabase.instance.reference().child('posts');
  DatabaseReference catRef;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  var client;
  var companyName;
  var email;

  void getUser() async {
    user = await _auth.currentUser();

    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .orderByChild('email')
        .equalTo(user.email)
        .once()
        .then((DataSnapshot snapshot) {
      Map map = snapshot.value;
      print("map is ${map.values.toList()}");
      companyName = map.values.toList()[0]['userName'];
    });
  }

  void initState() {
    super.initState();
    getUser();
  }

  posttoFirebase(String title, String description, String howLong,
      String allowance, String category) async {
    await postRef.push().set(<dynamic, dynamic>{
      'jobTitle': title.substring(0, 1).toUpperCase() +
          title.substring(1, title.length),
      'firstLetter': title.substring(0, 1).toUpperCase(),
      'jobDescription': description,
      'howLong': howLong,
      'companyName': companyName,
      'allowance': allowance,
      'category': widget.category,
      'postedBy': user.email,
      'postedAt': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'status': 'open'
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
      //   title: Text('Post Job'),
      //   centerTitle: true,
      //   backgroundColor: Colors.black,
      // ),
      body: SafeArea(
        child: Column(
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
                      "Post Job",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  reusableRow('Job Title', jobTitleController,
                      FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z]')),TextInputType.text,'Job Title',1),
                  SizedBox(
                    height: 20,
                  ),
                  reusableRow('Job Description', jobDescriptionController,
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),TextInputType.text,'Job Description',5),
                  SizedBox(
                    height: 20,
                  ),
                  reusableRow('How long it take', forhowLong,
                      FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z 0-9]')),TextInputType.text,'Duration',1),
                  SizedBox(
                    height: 20,
                  ),
                  reusableRow('Allowance', allowanceController,
                      FilteringTextInputFormatter.digitsOnly,TextInputType.number,'Allowance',1),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),

                    child: RaisedButton(
                        color: myColor.myBlack,
                        shape: RoundedRectangleBorder(


                            side: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50)),
                        child: isloading
                            ? SpinKitWave(
                                color: Colors.pinkAccent,
                              )
                            : Text('Post',style: GoogleFonts.delius(
                            fontWeight: FontWeight.w600,
                            color: myColor.myWhite)),
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });

                          if (allowanceController.text.isNotEmpty &&
                              forhowLong.text.isNotEmpty &&
                              jobDescriptionController.text.isNotEmpty &&
                              jobTitleController.text.isNotEmpty) {
                            await posttoFirebase(
                                jobTitleController.text,
                                jobDescriptionController.text,
                                forhowLong.text,
                                allowanceController.text,
                                initdata);
                            Flushbar(
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              backgroundColor: Colors.green,
                              title: "Success",
                              message: "Job posted successfully",
                              duration: Duration(seconds: 3),
                            )..show(context);
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
                              title: "Error",
                              message: "Fill the Above fields",
                              duration: Duration(seconds: 3),
                            )..show(context);
                          }
                        }),
                  ),

//          RaisedButton(
//            child: Text('logout'),
//            onPressed: () async{
//              await _auth.signOut();
//
//            },
//          )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget reusableRow(name, controller, inputFormat,inputType,hintText,line) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     name,
        //     style: TextStyle(fontSize: 20),
        //   ),
        // ),
        Expanded(
          child: TextField(

              inputFormatters: [inputFormat],
              keyboardType: inputType,
              decoration: InputDecoration(


                filled: true,
                fillColor: myColor.myWhite,
                hintText: hintText
              ),
              maxLines: line,
              controller: controller),
        )
      ],
    ),
  );
}
