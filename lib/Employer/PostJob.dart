import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostJob extends StatefulWidget {
  @override
  _PostJobState createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController forhowLong = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController AllowanceController = TextEditingController();
  var isloading = false;
  DatabaseReference postRef = FirebaseDatabase.instance.reference().child('posts');
  FirebaseAuth _auth = FirebaseAuth.instance;
  PosttoFirebase(String title,String description,String howLong,String companyName,String allowance)async{
     await postRef.push().set(<dynamic, dynamic> {
       'jobTitle':title,

       'jobDescription':description,

       'howLong' :howLong,

       'companyName':companyName,

       'allowance':allowance
     });
     setState(() {
       isloading = false;
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Post Job'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        children: <Widget>[
           ReusableRow('Company Name', companyNameController),
           SizedBox(height: 10,),
           ReusableRow('Job Title',jobTitleController),
           SizedBox(height: 10,),
           ReusableRow('Job Description', jobDescriptionController),
           SizedBox(height: 10,),
           ReusableRow('How long it take', forhowLong),
           SizedBox(height: 10,),
           ReusableRow('Allowance', AllowanceController),
           RaisedButton(
             child: isloading?SpinKitWave(color: Colors.pinkAccent,):Text('Post'),
             onPressed: () async {
               setState(() {
                 isloading = true;
               });
               await PosttoFirebase(
                   jobTitleController.text, jobDescriptionController.text,
                   forhowLong.text, companyNameController.text,
                   AllowanceController.text);
               Flushbar(
                 icon: Icon(Icons.check,color: Colors.green,),
                 backgroundColor: Colors.green,

                 title:  "Success",
                 message:  "Job posted successfully",
                 duration:  Duration(seconds: 3),
               )..show(context);
             }
           ),
          RaisedButton(
            child: Text('logout'),
            onPressed: (){
              _auth.signOut();
            },
          )
        ],
      ),
    );
  }
}
Widget ReusableRow(name,controller){
  return Row(
    children: <Widget>[
      Text(name),
      Container(
        height: 40,
        width: 50,
        child: TextField(
          controller:controller
        ),
      )
    ],
  );
}
