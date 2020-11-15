import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
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
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        print('hi');
//                          url = await getImage();
                        await getImage();
//                          print("url is $downloadUrl");
                      },
                      child: _image != null
                          ? Container(
                        height: 300,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: FloatingActionButton(
                                  foregroundColor: myColor.myBlack,
                                  backgroundColor: myColor.myWhite,
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 25,
                                  ),
                                  onPressed: () async {
                                    await getImage();
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: myColor.myWhite,
                                      borderRadius:
                                      BorderRadius.circular(20)),
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(_image))),
                      )
                          : widget.imageUrl != null
                          ? Container(
                        height: 300,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          fit: StackFit.expand,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: ClipOval(

                                child: FadeInImage(
                                    height: 300,
                                    width: 300,
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage(
                                        'image/internship.jpg'),
                                    image: NetworkImage(map.values
                                        .toList()[0]['url'])),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: FloatingActionButton(
                                  foregroundColor: myColor.myBlack,
                                  backgroundColor: myColor.myWhite,
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 25,
                                  ),
                                  onPressed: () async {
                                    await getImage();
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: myColor.myWhite,
                                      borderRadius:
                                      BorderRadius.circular(
                                          20)),
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(
                        height: 300,
                        color: myColor.myBackground,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: myColor.myWhite,
                                          borderRadius:
                                          BorderRadius.circular(
                                              20)),
                                      child: IconButton(
                                          icon: Icon(
                                              Icons.arrow_back),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop();
                                          }),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left:
                                          MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.15),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "My Profile",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.person,
                                  size: 45, color: Colors.purple),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 25,
                                  ),
                                  onPressed: () async {
                                    await getImage();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                              style:  GoogleFonts.delius(

                                  color: myColor.myBlack),
                              decoration: InputDecoration(
                                fillColor: myColor.myWhite,
                                filled: true,
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.purple, width: 2.0),
// //                      borderRadius: BorderRadius.circular(25.0),
//                               ),
                                icon: Icon(Icons.person, color: myColor.myBlack),
                                // border: OutlineInputBorder()
//                labelText: fullName
//                      hintText: identity
                              ),
                              controller: nameController,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                              style: GoogleFonts.delius(

                                  color: myColor.myBlack),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: myColor.myWhite,
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: const BorderSide(
                                  //       color: Colors.purple, width: 2.0),
//                      borderRadius: BorderRadius.circular(25.0),
                                  // ),
                                  // focusColor: Colors.transparent,
                                  // border: OutlineInputBorder(),
                                  icon:
                                  Icon(Icons.add_location, color: myColor.myBlack)
//                labelText: 'FullName',
//                      hintText: furtherInfo
                              ),
                              controller: furtherController,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,

                            child: isLoading
                                ? SpinKitWave(
                              color: myColor.myBlack,
                              size: 25,
                            )
                                :  Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              height: 50,
                              width: double.infinity,
                              child: RaisedButton(
                                color: myColor.myBlack,

                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text('Update', style: GoogleFonts.delius(
                                    fontWeight: FontWeight.w600,
                                    color: myColor.myWhite),),
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
                                    var updatedfurther =
                                        furtherController.text;
                                    var updatedName =
                                        nameController.text;
                                    if (_image != null) {
                                      StorageReference ref = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child("profile,${widget.email}");
                                      StorageUploadTask uploadTask =
                                      ref.putFile(_image);

                                      url =
                                      await (await uploadTask.onComplete)
                                          .ref
                                          .getDownloadURL();
                                    } else {
                                      url = map.values.toList()[0]['url'];
                                    }

                                    print("url is $url");
                                    print("identity is $identity");
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child("Users")
                                        .child(map.keys.toList()[0])
                                        .update({
                                      'furtherInfo': updatedfurther,
                                      'userName': updatedName,
                                      'url': url
                                    }).then((_) {
                                      db.updateUser(
                                          User(
                                              identity,
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
                                        message:
                                        "Profile updated successfully",
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
                                      message: "Profile updation error",
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
