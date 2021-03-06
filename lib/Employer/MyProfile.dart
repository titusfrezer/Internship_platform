import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_platform/Employer/ELandingPage.dart';
import 'package:internship_platform/Intern/CategoryPage.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/model/eventItem.dart';


class MyProfile extends StatefulWidget {
  String email;
  var decodedImage;

  MyProfile(this.email, this.decodedImage);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Query userRef;
  var imageUrl;
  var imageurl;

  var identity;
  var individualKey;
  var isLoading = false;
  TextEditingController companyNameController = TextEditingController();
  TextEditingController furtherController = TextEditingController();

  bool connected = false;

  void initState() {
    super.initState();

    getInfo();
  }

  getInfo() async {


    var client = await db.getUser(widget.email);
    imageurl = client[0]['image'];
//    decodedImage = Base64Decoder().convert(imageurl);
    print(client);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('connected via cellular');
      connected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('connected via wifi');
      connected = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      print('not connected');
      connected = false;
    }
    print("identit is ${client[0]['identity']}");
    fullName = client[0]['fullName'];

    furtherInfo = client[0]['furtherInfo'];

    identity = client[0]['identity'];

    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .orderByChild("email")
        .equalTo(widget.email)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print("value is ${values['url']}");
        individualKey = key;
        imageUrl = values['url'];
      });
    });
    companyNameController.text = fullName;
    furtherController.text = furtherInfo;
  }

  Uint8List _bytesImage;
  File _image;
  String base64Image;
  var url;
  var downloadUrl;

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 30
    );
    List<int> imageBytes = image2.readAsBytesSync();
    print(imageBytes);
    base64Image = base64Encode(imageBytes);
    print('string is');
    print(base64Image);
    print("You selected gallery image : " + image2.path);

    _bytesImage = Base64Decoder().convert(base64Image);

    setState(() {
      _image = image2;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("image is ${imageurl != null}");
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LandingPage(widget.email)),
                      (Route<dynamic> route) => false,
                );
              });
            },
          ),
          title: Text('My Profile'),
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
                    Center(
                      child: GestureDetector(
                          onTap: () async {
                            print('hi');
//                          url = await getImage();
                            await getImage();
//                          print("url is $downloadUrl");
                          },
                          child: _image != null
                              ? CircleAvatar(child: Row(

                            children: [

                              SizedBox(width: 62),
                              IconButton(icon:Icon(Icons.edit,size: 25,),onPressed: () async{
                                await getImage();
                              },),
                            ],
                          ),
                            backgroundColor: myColor.myBlack,
                            radius: 55,
                            backgroundImage: FileImage(_image),
                          )
                              : widget.decodedImage != null
                              ? CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Row(

                                children: [

                                  SizedBox(width: 62),
                                  IconButton(icon:Icon(Icons.edit,size: 25,),onPressed: () async{
                                    await getImage();
                                  },),
                                ],
                              ),
                              radius: 55,
                              backgroundImage: MemoryImage(
                                widget.decodedImage,
                              ))
                              : CircleAvatar(

                            radius: 55,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Icon(Icons.person,
                                      size: 45, color: Colors.purple),
                                ),
                                IconButton(icon:Icon(Icons.edit,size: 25,),onPressed: () async{
                                  await getImage();
                                },)
                              ],
                            ),
                            backgroundColor: Colors.black,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail, color: Colors.black),
                        SizedBox(width: 10),
                        Text(widget.email,
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
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
              padding: EdgeInsets.only(left: 18.0, right: 8),
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.purple, width: 2.0),
//                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    icon: Icon(Icons.person, color: Colors.black),
                    border: OutlineInputBorder()
//                labelText: fullName
//                      hintText: identity
                ),
                controller: companyNameController,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 18.0, right: 8),
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.purple, width: 2.0),
//                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusColor: myColor.myBlack,
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.work, color: Colors.black)
//                labelText: 'FullName',
//                      hintText: furtherInfo
                ),
                controller: furtherController,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: isLoading
                    ? SpinKitWave(
                  color: Colors.pink,
                )
                    : FlatButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text('Update'),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (!connected) {
                      setState(() {
                        isLoading = false;
                      });
                      Flushbar(
                        icon: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        backgroundColor: Colors.red,
                        title: "Error",
                        message: "Network Error",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                    if (furtherController.text.isNotEmpty &&
                        companyNameController.text.isNotEmpty) {
                      if(_image!=null){
                        StorageReference ref = FirebaseStorage.instance
                            .ref()
                            .child("profile,${widget.email}");
                        StorageUploadTask uploadTask = ref.putFile(_image);

                        url = await (await uploadTask.onComplete)
                            .ref
                            .getDownloadURL();
                      }else{

                        url = imageUrl;
                        base64Image = widget.decodedImage!=null?base64Encode(widget.decodedImage):'none';
                      }

                      print("url is $url");
                      print("identity is $identity");
                      FirebaseDatabase.instance
                          .reference()
                          .child("Users")
                          .child(individualKey)
                          .update({
                        'email': widget.email,
                        'furtherInfo': furtherController.text,
                        'identity': identity,
                        'userName': companyNameController.text,
                        'url': url
                      }).then((_) {
                        db.updateUser(
                            User(
                                identity,
                                widget.email.toString(),
                                companyNameController.text,
                                furtherController.text,
                                base64Image),
                            widget.email);

                        setState(() {
                          // fullName = companyNameController.text;
                          // furtherInfo = furtherController.text;
                          isLoading = false;
                        });
                        Flushbar(
                          icon: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          backgroundColor: Colors.green,
                          title: "Success",
                          message: "Profile updated successfully",
                          duration: Duration(seconds: 3),
                        )..show(context);
                        print('done');
                      });

//                            InternCategoryPage(widget.email);
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      Flushbar(
                        icon: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        backgroundColor: Colors.red,
                        title: "Error",
                        message: "Profile updated error",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                  },
                ))
          ],
        ));
  }
}
