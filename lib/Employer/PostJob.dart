import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/Providers/Job.dart';
import 'package:internship_platform/model/PostJob.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

String initdata = "Mechanical Engineering";

class PostJob extends StatefulWidget {
  @override
  _PostJobState createState() => _PostJobState();

  String category;

  PostJob(this.category);
}

class _PostJobState extends State<PostJob> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController forhowLong = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController allowanceController = TextEditingController();
  DatabaseReference postRef =
      FirebaseDatabase.instance.reference().child('posts');

  void getUser() async {
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
      companyName = map.values.toList()[0]['userName'];
    });
  }

  void initState() {
    super.initState();
    getUser();
  }

  // posttoFirebase(String title, String description, String howLong,
  //     String allowance, String category) async {
  //   await postRef.push().set(<dynamic, dynamic>{
  //     'jobTitle': title.substring(0, 1).toUpperCase() +
  //         title.substring(1, title.length),
  //     'firstLetter': title.substring(0, 1).toUpperCase(),
  //     'jobDescription': description,
  //     'howLong': howLong,
  //     'companyName': companyName,
  //     'allowance': allowance,
  //     'category': widget.category,
  //     'postedBy': user.email,
  //     'postedAt': DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //     'status': 'open'
  //   });
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<Job>(context, listen: false);
    return Scaffold(

      backgroundColor: myColor.myBackground,
      // appBar: AppBar(
      //   title: Text('Post Job'),
      //   centerTitle: true,
      //   backgroundColor: Colors.black,
      // ),
      body: Form(
        key: _formKey,
        child: SafeArea(
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
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    reusableRow(
                        'Job Title',
                        'Enter Job Title',
                        jobTitleController,
                        FilteringTextInputFormatter.singleLineFormatter,
                        TextInputType.text,
                        'Job Title',
                        1),
                    SizedBox(
                      height: 20,
                    ),
                    reusableRow(
                        'Job Description',
                        'Enter Job Description',
                        jobDescriptionController,
                        FilteringTextInputFormatter.deny(RegExp(r'[]')),
                        TextInputType.text,
                        'Job Description',
                        5),
                    SizedBox(
                      height: 20,
                    ),
                    reusableRow(
                        'How long it take',
                        'Enter For How long',
                        forhowLong,
                        FilteringTextInputFormatter.deny(RegExp(r'[]')),
                        TextInputType.text,
                        'Duration',
                        1),
                    SizedBox(
                      height: 20,
                    ),
                    reusableRow(
                        'Allowance',
                        'Enter Job Allowance',
                        allowanceController,
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputType.number,
                        'Allowance',
                        1),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Consumer<Job>(
                        builder: (_, post, __) => post.isloading
                            ? SpinKitWave(color: Colors.black)
                            : RaisedButton(
                                color: myColor.myBlack,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text('Post',
                                    style: GoogleFonts.delius(
                                        fontWeight: FontWeight.w600,
                                        color: myColor.myWhite)),
                                onPressed: () async {
                                  // setState(() {
                                  //   isLoading = true;
                                  // });

                                  if (_formKey.currentState.validate()) {
                                    post.postJob(Post(
                                        jobTitle: jobTitleController.text,
                                        jobDescrption:
                                            jobDescriptionController.text,
                                        howLong: forhowLong.text,
                                        allowance: allowanceController.text,
                                        category: widget.category));
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
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).pop();
                                  } else {

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
      ),
    );
  }
}

Widget reusableRow(name, validator,controller, inputFormat, inputType, hintText, line) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            validator: (value){
              if(value.isEmpty){
                return '$validator';
              }
              return null;
            },
              inputFormatters: [inputFormat],
              keyboardType: inputType,
              decoration: InputDecoration(
                  filled: true, fillColor: myColor.myWhite, hintText: hintText),
              maxLines: line,
              controller: controller,

          ),

        )
      ],
    ),
  );
}
