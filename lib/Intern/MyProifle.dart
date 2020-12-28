import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_platform/Intern/CategoryPage.dart';
import 'package:internship_platform/Utilities/variables.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController furtherController = TextEditingController();
  TextEditingController telegramController = TextEditingController();
  TextEditingController githubController = TextEditingController();

  void initState() {
    super.initState();

    getInfo();
    isLoading = false;
  }

  getInfo() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    connected = ((connectivityResult == ConnectivityResult.wifi) ||
        (connectivityResult == ConnectivityResult.mobile));
    print("connected $connected");
    client = await db.getUser(widget.email);
    identity = client[0]['identity'];
  }

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);
    List<int> imageBytes = image2.readAsBytesSync();

    setState(() {
      image = image2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Query checkUser = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .orderByChild("email")
        .equalTo(widget.email);
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: myColor.myBackground,
        appBar: AppBar(
          title: Text("My Profile"),
          backgroundColor: myColor.myBackground,
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: StreamBuilder(
              stream: checkUser.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map map = snapshot.data.snapshot.value;
                  nameController.text = map.values.toList()[0]['userName'];
                  furtherController.text =
                      map.values.toList()[0]['furtherInfo'];
                  telegramController.text =
                      map.values.toList()[0]['telegram'];
                  githubController.text = map.values.toList()[0]['github'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () async {
                          print('hi');
//                          url = await getImage();
                          await getImage();
//                          print("url is $downloadUrl");
                        },
                        child: image != null
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 300,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: 300,
                                        width: 300,
                                        child: CircleAvatar(
                                            backgroundColor: myColor.myWhite,
                                            backgroundImage: FileImage(image)),
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

                                  ],
                                ),
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
                                          alignment: Alignment.center,
                                          child: CircleAvatar(
                                            backgroundColor: myColor.myWhite,
                                            child: Icon(Icons.person,
                                                size: 100, color:myColor.myWhite),
                                          ),
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
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Valid name';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.montserrat(
                                    color: myColor.myBlack),
                                decoration: InputDecoration(
                                  fillColor: myColor.myWhite,
                                  filled: true,
                                  icon: Icon(Icons.person,
                                      color: myColor.myWhite),
                                ),
                                controller: nameController,
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter valid Field';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.montserrat(
                                    color: myColor.myBlack),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: myColor.myWhite,
                                    icon: Icon(Icons.work,
                                        color: myColor.myWhite)),
                                controller: furtherController,
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isNotEmpty &&
                                      !(Uri.parse(value).isAbsolute)) {
                                    return 'Telegram Field should be link';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.montserrat(
                                    color: myColor.myBlack),
                                decoration: InputDecoration(
                                    hintText: telegramController.text.isEmpty
                                        ? 'Your Telegram Account(https://t.me/titus)'
                                        : telegramController.text,
                                    filled: true,
                                    fillColor: myColor.myWhite,
                                    icon: FaIcon(
                                      FontAwesomeIcons.telegram,
                                      color:myColor.myWhite,
                                    )),
                                controller: telegramController,
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isNotEmpty &&
                                      !(Uri.parse(value).isAbsolute)) {
                                    return 'Valid Github field required';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.montserrat(
                                    color: myColor.myBlack),
                                decoration: InputDecoration(
                                    hintText: githubController.text.isEmpty
                                        ? 'Your Github Account(https://github.com/titusfrezer)'
                                        : telegramController.text,
                                    filled: true,
                                    fillColor: myColor.myWhite,
                                    icon: FaIcon(
                                      FontAwesomeIcons.github,
                                      color: myColor.myWhite,
                                    )),
                                controller: githubController,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: isLoading
                                  ? SpinKitWave(
                                      color: myColor.myBlack,
                                      size: 25,
                                    )
                                  : Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15,vertical: 25),
                                      height: 50,
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: myColor.myWhite,
                                        shape: RoundedRectangleBorder(

                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Text(
                                          'Update',
                                          style: GoogleFonts.delius(
                                              fontWeight: FontWeight.w600,
                                              color: myColor.myBlack),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
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

                                            var updatedfurther =
                                                furtherController.text;
                                            var updatedName =
                                                nameController.text;
                                            var updatedTelegram =
                                                telegramController.text;
                                            var updatedGithub =
                                                githubController.text;

                                            if (image != null) {
                                              StorageReference ref = FirebaseStorage
                                                  .instance
                                                  .ref()
                                                  .child(
                                                      "profile,${widget.email}");
                                              StorageUploadTask uploadTask =
                                                  ref.putFile(image);

                                              url = await (await uploadTask
                                                      .onComplete)
                                                  .ref
                                                  .getDownloadURL();
                                            } else {
                                              url =
                                                  map.values.toList()[0]['url'];
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
                                              'url': url,
                                              'telegram':updatedTelegram,
                                              'github':updatedGithub
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
                } else if (!connected) {
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
                                  connected = true;
                                });
                              } else {
                                setState(() {
                                  connected = false;
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
                return SpinKitWave(color: Colors.purple);
              }),
        ));
  }
}
