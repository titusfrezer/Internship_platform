import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/main.dart';
import 'package:intl/intl.dart';
List<String> _getdata = List();
String initdata= "Mechanical Engineering";
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
  TextEditingController AllowanceController = TextEditingController();
  var isloading = false;
  DatabaseReference postRef = FirebaseDatabase.instance.reference().child('posts');
  DatabaseReference catRef;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  PosttoFirebase(String title,String description,String howLong,String companyName,String allowance,String category)async{
     await postRef.push().set(<dynamic, dynamic> {
       'jobTitle':title.substring(0,1).toUpperCase()+title.substring(1,title.length),

       'firstLetter':title.substring(0,1).toUpperCase(),

       'jobDescription':description,

       'howLong' :howLong,

       'companyName':companyName,

       'allowance':allowance,

       'category':widget.category,

       'postedBy':user.email,

       'postedAt':DateFormat('yyyy-MM-dd').format(DateTime.now()),

       'status':'open'
     });
     setState(() {
       isloading = false;
     });
  }
  void getUser() async{
    user = await _auth.currentUser();
  }
  void initState(){

    super.initState();
   getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Post Job on Category ${widget.category})'),
        centerTitle: true,
        backgroundColor: Colors.black,
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
               if(AllowanceController.text.isNotEmpty || forhowLong.text.isNotEmpty || jobDescriptionController.text.isNotEmpty
               || jobTitleController.text.isNotEmpty || companyNameController.text.isNotEmpty){
                 await PosttoFirebase(
                     jobTitleController.text, jobDescriptionController.text,
                     forhowLong.text, companyNameController.text,
                     AllowanceController.text,initdata);
                 Flushbar(
                   icon: Icon(Icons.check,color: Colors.green,),
                   backgroundColor: Colors.green,

                   title:  "Success",
                   message:  "Job posted successfully",
                   duration:  Duration(seconds: 3),
                 )..show(context);
               }
               else{
                 setState(() {
                   isloading = false;
                 });
                 Flushbar(
                   icon: Icon(Icons.error,color: Colors.red,),
                   backgroundColor: Colors.red,

                   title:  "Error",
                   message:  "Fill the Above fields",
                   duration:  Duration(seconds: 3),
                 )..show(context);
               }

             }
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
    );
  }
}
Widget ReusableRow(name,controller){
  return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(name,style: TextStyle(fontSize: 20),),
      ),
      Expanded(

        child: TextField(decoration: InputDecoration(

        ),
          controller:controller
        ),
      )
    ],
  );
}
