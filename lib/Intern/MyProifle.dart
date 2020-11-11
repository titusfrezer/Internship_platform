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
import 'package:internship_platform/Intern/CategoryPage.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/model/eventItem.dart';

class MyProfile extends StatefulWidget {
  String email;
  var imageUrl;

  MyProfile(this.email, this.imageUrl);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Query userRef;

  var identity;
  var isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController furtherController = TextEditingController();
  bool checkConnection = false;
  Query checkUser;

  void initState() {
    super.initState();

    getInfo();
  }

  getInfo() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    checkConnection = ((connectivityResult == ConnectivityResult.wifi) ||
        (connectivityResult == ConnectivityResult.mobile));
    print("connected $checkConnection");
  }

  // Uint8List _bytesImage;
  File _image;
  String base64Image;
  var url;
  var downloadUrl;

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);
    List<int> imageBytes = image2.readAsBytesSync();
    base64Image = base64Encode(imageBytes);
    print(base64Image);
    // _bytesImage = Base64Decoder().convert(base64Image);

    setState(() {
      _image = image2;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkUser = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .orderByChild("email")
        .equalTo(widget.email);
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
                      builder: (context) => InternCategoryPage(widget.email)),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
          title: Text('My Profile'),
        ),
        body: StreamBuilder(
            stream: checkUser.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map map = snapshot.data.snapshot.value;
                nameController.text = map.values.toList()[0]['userName'];
                furtherController.text = map.values.toList()[0]['furtherInfo'];
                return ListView(
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
                                      ? CircleAvatar(
                                          child: Row(
                                            children: [
                                              SizedBox(width: 62),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: 25,
                                                ),
                                                onPressed: () async {
                                                  await getImage();
                                                },
                                              ),
                                            ],
                                          ),
                                          backgroundColor: myColor.myBlack,
                                          radius: 55,
                                          backgroundImage: FileImage(_image),
                                        )
                                      : widget.imageUrl != null
                                          ? ClipOval(

                                            child: Stack(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                // SizedBox(width: 62),

                                                FadeInImage(
                                                  width: 100,
                                                  height: 100,
                                                  fit:BoxFit.cover,
                                                    placeholder: AssetImage(
                                                        'image/internship.jpg'),
                                                    image: NetworkImage(map.values.toList()[0]['url'])),
                                              SizedBox(height: 40,),
                                                IconButton(color: Colors.white,
                                                  icon: Icon(

                                                    Icons.edit,
                                                    size: 25,
                                                  ),
                                                  onPressed: () async {
                                                    await getImage();
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                          : CircleAvatar(
                                              radius: 55,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Icon(Icons.person,
                                                        size: 45,
                                                        color: Colors.purple),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 25,
                                                    ),
                                                    onPressed: () async {
                                                      await getImage();
                                                    },
                                                  )
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
                              borderSide: const BorderSide(
                                  color: Colors.purple, width: 2.0),
                            ),
                            icon: Icon(Icons.person, color: Colors.black),
                            border: OutlineInputBorder()),
                        controller: nameController,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 18.0, right: 8),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.purple, width: 2.0),
                            ),
                            focusColor: myColor.myBlack,
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.work, color: Colors.black)),
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
                                  if (!checkConnection) {
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
                                      nameController.text.isNotEmpty) {
                                    var updatedfurther = furtherController.text;
                                    var updatedName = nameController.text;
                                    if (_image != null) {
                                      // if image is selected using image picker
                                      StorageReference ref = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child("profile,${widget.email}");
                                      StorageUploadTask uploadTask =
                                          ref.putFile(_image);

                                      url = await (await uploadTask.onComplete)
                                          .ref
                                          .getDownloadURL();
                                    } else {
                                      url = map.values.toList()[0]['url'];
                                    }

                                    FirebaseDatabase.instance
                                        .reference()
                                        .child("Users")
                                        .child(map.keys.toList()[0])
                                        .update({
                                      'furtherInfo': updatedfurther,
                                      'userName': updatedName,
                                      'url': url,
                                      // 'decodedImage':base64Image
                                    }).then((_) {
                                      db.updateUser(
                                          User(
                                              map.values.toList()[0]['identity'],
                                              widget.email.toString(),
                                              updatedName,
                                              updatedfurther,
                                              'none'),
                                          widget.email);

                                      setState(() {
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
                );
              } else if (!checkConnection) {
                print('hi');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.signal_wifi_off,
                        size: 40,
                        color: myColor.myBlack,
                      ),
                      FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () async {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            print(connectivityResult);
                            if ((connectivityResult ==
                                    ConnectivityResult.wifi) ||
                                connectivityResult ==
                                    ConnectivityResult.mobile) {
                              print('connected');
                              setState(() {
                                checkConnection = true;
                              });
                            } else {
                              setState(() {
                                checkConnection = false;
                              });
                              print('not connected');
                            }
                          },
                          child: Text('Retry',
                              style: TextStyle(color: myColor.myBlack)))
                    ],
                  ),
                );
              }
              return SpinKitDualRing(color: Colors.purple);
            }));
  }
}
