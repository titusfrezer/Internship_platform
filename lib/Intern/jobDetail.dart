import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  jobDetail(this.jobTitle, this.jobDescription, this.postedBy, this.category,this.postedAt,this.allowance,this.howLong,this.companyName);
}

class _jobDetailState extends State<jobDetail> {
  var client;
  var identity;
  var fullName;
  var email;
  var furtherInfo;

  DatabaseReference applyRef =
      FirebaseDatabase.instance.reference().child('application');
  var file;
  var isloading = false;
var image;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    getInfo();
  }

  getInfo() async {
    user = await firebaseAuth.currentUser();

    client = await db.getUser(user.email);

    identity = client[0]['identity'];
    fullName = client[0]['fullName'];
    email = client[0]['email'];
    image = client[0]['image'];
    furtherInfo = client[0]['furtherInfo'];
  }

  postToFirebase() async {
    StorageReference reference =
        FirebaseStorage.instance.ref().child('$fullName.pdf');
    StorageUploadTask uploadTask = reference.putData(file.readAsBytesSync());

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);

    applyRef.push().set(<dynamic, dynamic>{
      'ApplierName': fullName,
      'ApplierEmail': email,
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
                   "Job Title : ${ widget.jobTitle}",
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Text('Description :  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                          child: Text(
                              "${widget.jobDescription}",style: TextStyle(fontSize: 20),),
                          width: MediaQuery.of(context).size.width / 2),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(26.0),
            child: Row(
              children: [
                Text('Company Name : ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text(widget.companyName, style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:26.0),
            child: Row(
              children: [
                Text('Allowance : ',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text("${widget.allowance} br", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left:26.0),
            child: Row(
              children: [
                Text('Duration : ',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text("${widget.howLong} ", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left:26.0),
            child: Row(
              children: [
                Text('Post Date : ',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text("${DateFormat('yMMMMd').format(DateTime.parse(widget.postedAt))} ", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.only(left: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text('Select File : ',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text("Upload CV"),
                  onPressed: () async {
                    file = await FilePicker.getFile(
                        type: FileType.CUSTOM, fileExtension: 'pdf');

//                    String fileName = '${applierName.text}.pdf';
//                    print(fileName);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Center(
              child: FlatButton(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.black, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(20)),
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
                file=null;
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
                : Text('Apply',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ))
        ],
      ),
    );
  }
}
