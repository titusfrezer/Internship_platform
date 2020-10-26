import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/util/dbclient.dart';
import 'package:firebase_storage/firebase_storage.dart';
class jobDetail extends StatefulWidget {
  @override
  _jobDetailState createState() => _jobDetailState();

  String jobTitle;
  String category;
  String postedBy;

  jobDetail(this.jobTitle,this.category,this.postedBy);

}

class _jobDetailState extends State<jobDetail> {

  var client;
  var identity;
  var fullName;
  var email;
  var furtherInfo;
  FirebaseAuth _firebaseAuth;
  FirebaseUser user;
  var db = new DatabaseHelper();
  DatabaseReference applyRef = FirebaseDatabase.instance.reference().child('application');
  var file;
  var isloading=false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _firebaseAuth = FirebaseAuth.instance;

  }

  getInfo() async{
    user = await _firebaseAuth.currentUser();
    client= await db.getUser(user.email);

    identity = client[0]['identity'];
    fullName = client[0]['fullName'];
    furtherInfo = client[0]['furtherInfo'];
  }

  postToFirebase() async{

    StorageReference reference = FirebaseStorage.instance.ref().child('$fullName.pdf');
    StorageUploadTask uploadTask = reference.putData(file.readAsBytesSync());

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);


    applyRef.push().set(<dynamic,dynamic>{

      'ApplierName': fullName,

      'ApplierEmail' :user.email,

      'ApplierExpertise':furtherInfo,

      'cvUrl' : url,

      'category':widget.category,

      'AppliedTo':widget.postedBy,

      'jobTitle':widget.jobTitle
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          ClipPath(
            clipper: WaveClipper1(),
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Icon(
                    Icons.work,
                    color: Colors.pink,
                    size: 60,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.jobTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 30),
                  ),
                ],
              ),
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [myColor.myBlack, myColor.myBlack])),
            ),
          ),

          Text(widget.category),
          Text(widget.postedBy),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text('Select File',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text("Pick File"),
                  onPressed: () async{
                   file= await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');

//                    String fileName = '${applierName.text}.pdf';
//                    print(fileName);
                  },
                ),

              ],
            ),
          ),
          Center(
              child:RaisedButton(

                onPressed: () async{

                  setState(() {
                    isloading = true;
                  });
                  if(file!=null) {
                    await postToFirebase();
                    Flushbar(
                      icon: Icon(Icons.check,color: Colors.green,),
                      backgroundColor: Colors.green,

                      title:  "Success",
                      message:  "Application posted successfully",
                      duration:  Duration(seconds: 3),
                    )..show(context);
                  }else{

                    setState(() {
                      isloading=false;
                    });
                    Flushbar(
                      icon: Icon(Icons.error,color: Colors.red,),
                      backgroundColor: Colors.red,

                      title:  "Wrong",
                      message:  "Upload Cv",
                      duration:  Duration(seconds: 3),
                    )..show(context);
                  }


                },
                child: isloading?SpinKitWave(color: Colors.pinkAccent,): Text('Apply'),
              )
          )
        ],
      ),
    );
  }
}
