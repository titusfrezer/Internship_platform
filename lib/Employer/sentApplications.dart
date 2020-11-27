import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class sentApplications extends StatefulWidget {
  @override
  _sentApplicationsState createState() => _sentApplicationsState();
  String email;

  sentApplications(this.email);
}

Query sentRef;

DatabaseReference closeRef =
    FirebaseDatabase.instance.reference().child("closed");

class _sentApplicationsState extends State<sentApplications> {
  void getUser() async {
    user = await firebaseAuth.currentUser();

    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColor.myBackground,
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
                        "Sent Applications",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child("application")
                      .orderByChild('AppliedTo')
                      .equalTo(widget.email)
                      .onValue,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.snapshot.value != null) {
                        Map<dynamic, dynamic> map =
                            snapshot.data.snapshot.value;

                        print(map.values.toList());
                        return ListView.builder(
                          itemCount: map.values.toList().length,
//                      scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return index % 2 == 0
                                ? Dismissible(
                                    key: Key(
                                        map.values.toList()[index].toString()),
                                    confirmDismiss: (direction) {
                                      return showDialog(
                                          context: (context),
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Are you sure you want to delete!!'),
                                              actions: <Widget>[
                                                FlatButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      setState(() {
                                                        FirebaseDatabase
                                                            .instance
                                                            .reference()
                                                            .child(
                                                                "application")
                                                            .child(map.keys
                                                                    .toList()[
                                                                index])
                                                            .remove();
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                                FlatButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: 120,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Card(
                                        color: myColor.myBlack,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ExpansionTile(
                                          leading: map.values.toList()[index]
                                                      ['imageUrl'] !=
                                                  null
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            child: Container(
                                                              width: 200,
                                                              height: 200,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(map
                                                                              .values
                                                                              .toList()[index]
                                                                          [
                                                                          'imageUrl']),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: ClipOval(
                                                    child: FadeInImage(
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(map
                                                              .values
                                                              .toList()[index]
                                                          ['imageUrl']),
                                                      placeholder: AssetImage(
                                                          'image/internship.jpg'),
                                                    ),
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  color: myColor.myWhite,
                                                  size: 40,
                                                ),
                                          trailing: Icon(Icons.arrow_drop_down,
                                              color: myColor.myWhite, size: 40),
                                          title: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "${map.values.toList()[index]['ApplierName']} ",
                                              overflow: TextOverflow.fade,
                                              style: GoogleFonts.openSans(
                                                  color: myColor.myWhite,
                                                  fontSize: 18),
                                            ),
                                          ),
//
                                          subtitle: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "  ${map.values.toList()[index]['jobTitle']}",
                                              style: GoogleFonts.montserrat(
                                                  color: myColor.myWhite,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),

                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  map.values.toList()[0]['telegram']!=null?IconButton(icon: FaIcon(FontAwesomeIcons.telegram,color: Colors.white,), onPressed: (){
                                                    UrlLauncher.launch(map.values.toList()[0]['telegram']);
                                                  }):Container(),
                                                  RaisedButton(
                                                    color: myColor.myWhite,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Text(
                                                      'Contact Intern',
                                                      style: TextStyle(
                                                          color:
                                                              myColor.myBlack),
                                                    ),
                                                    onPressed: () {
                                                      UrlLauncher.launch(
                                                          'mailto:${map.values.toList()[index]['ApplierEmail']}?subject=Intern Application&body=This is to inform that you are selected to be our intern');
                                                    },
                                                  ),
                                                  SizedBox(width: 20),
                                                  RaisedButton(
                                                    color: myColor.myWhite,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Text(
                                                        'View Cv online',
                                                        style: TextStyle(
                                                            color: myColor
                                                                .myBlack)),
                                                    onPressed: () async {
//                                      setState(() {
//                                        isLoading = true;
//                                      });
                                                      PDFDocument doc =
                                                          await PDFDocument
                                                              .fromURL(map
                                                                      .values
                                                                      .toList()[
                                                                  index]['cvUrl']);
                                                      print(map.values
                                                              .toList()[index]
                                                          ['cvUrl']);
                                                      print("hii");
                                                      await Navigator.of(
                                                              context)
                                                          .push(MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ViewPdf(
                                                                      doc)));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],

//
                                        ),
                                      ),
                                    ),
                                  )
                                : Dismissible(
                                    key: Key(
                                        map.values.toList()[index].toString()),
                                    confirmDismiss: (direction) {
                                      return showDialog(
                                          context: (context),
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Are you sure you want to delete!!'),
                                              actions: <Widget>[
                                                FlatButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      setState(() {
                                                        FirebaseDatabase
                                                            .instance
                                                            .reference()
                                                            .child(
                                                                "application")
                                                            .child(map.keys
                                                                    .toList()[
                                                                index])
                                                            .remove();
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                                FlatButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: 120,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Card(
                                        color: myColor.myWhite,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ExpansionTile(
                                          leading: map.values.toList()[index]
                                                      ['imageUrl'] !=
                                                  null
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            child: Container(
                                                              width: 200,
                                                              height: 200,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(map
                                                                              .values
                                                                              .toList()[index]
                                                                          [
                                                                          'imageUrl']),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: ClipOval(
                                                    child: FadeInImage(
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(map
                                                              .values
                                                              .toList()[index]
                                                          ['imageUrl']),
                                                      placeholder: AssetImage(
                                                          'image/internship.jpg'),
                                                    ),
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  color: myColor.myBlack,
                                                  size: 40,
                                                ),
                                          trailing: Icon(Icons.arrow_drop_down,
                                              color: myColor.myBlack, size: 40),
                                          title: Text(
                                            "${map.values.toList()[index]['ApplierName']} ",
                                            overflow: TextOverflow.fade,
                                            style: GoogleFonts.openSans(
                                                color: myColor.myBlack,
                                                fontSize: 18),
                                          ),
//

                                          subtitle: Text(
                                            "  ${map.values.toList()[index]['jobTitle']}",
                                            style: GoogleFonts.montserrat(
                                                color: myColor.myBlack,
                                                fontStyle: FontStyle.italic),
                                          ),

                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  RaisedButton(
                                                    color: myColor.myBlack,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                                width: 1,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                    child: Text(
                                                      'Contact Intern',
                                                      style: TextStyle(
                                                          color:
                                                              myColor.myWhite),
                                                    ),
                                                    onPressed: () {
                                                      UrlLauncher.launch(
                                                          'mailto:${map.values.toList()[index]['ApplierEmail']}?subject=Intern Application&body=This is to inform that you are selected to be our intern');
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  RaisedButton(
                                                    color: Colors.black87,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                                width: 1,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                    child: Text(
                                                        'View Cv online',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    onPressed: () async {
//                                      setState(() {
//                                        isLoading = true;
//                                      });
                                                      PDFDocument doc =
                                                          await PDFDocument
                                                              .fromURL(map
                                                                      .values
                                                                      .toList()[
                                                                  index]['cvUrl']);
                                                      print(map.values
                                                              .toList()[index]
                                                          ['cvUrl']);
                                                      print("hii");
                                                      await Navigator.of(
                                                              context)
                                                          .push(MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ViewPdf(
                                                                      doc)));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],

//
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No Sent Application Yet',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        );
                      }
                    }

                    return SpinKitWave(
                      color: myColor.myBlack,
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class ViewPdf extends StatelessWidget {
  PDFDocument document;

  ViewPdf(this.document);

  @override
  Widget build(BuildContext context) {
    print(document);
    return Scaffold(
        backgroundColor: myColor.myBackground,
        body: isLoading
            ? SpinKitWave(
                color: myColor.myBlack,
                size: 25,
              )
            : PDFViewer(
                showPicker: false,
                document: document,
              ));
  }
}
