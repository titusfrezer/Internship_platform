
import 'package:flutter/material.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/SignUp.dart';
import 'package:internship_platform/WaveClipper.dart';


final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _autoValidate = false;
bool isValid= true;
class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
  String privelege;
  String fullName;
  String fieldofStudy;

  PersonalInfoPage(this.privelege);
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipper2(),
                  child: Container(
                    child: Column(),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: SweepGradient(colors: [
                          myColor.myDarkGrey,
                          myColor.myWhite,
                        ])),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper3(),
                  child: Container(
                    child: Column(),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: SweepGradient(colors: [
                          myColor.myWhite,
                          myColor.myLightGrey,
                          myColor.myWhite,
                          myColor.myLightGrey,
                        ])),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper1(),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 60,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Personal Infomation",
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
                        gradient: SweepGradient(colors: [
                          myColor.myDarkGrey,
                          myColor.myBlack,
                          myColor.myDarkGrey,
                          myColor.myBlack,
                          myColor.myDarkGrey,
                        ])),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  onSaved: (value) {
                    widget.fullName = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name required';
                    }
                    return null;
                  },
                  onChanged: (String value) {},
                  cursorColor: myColor.myBlack,
                  decoration: InputDecoration(
                      hintText: "Full Name",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.person,
                          color: myColor.myBlack,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  onSaved: (value) {
                    widget.fieldofStudy = value;
                  },
                  validator: (value) {
                    if (value.length<5 ) {
                      return 'Valid Field of Study required';
                    }
                    return null;
                  },
                  onChanged: (String value) {},
                  cursorColor: myColor.myBlack,
                  decoration: InputDecoration(
                      hintText: "Field of Study",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.school,
                          color: myColor.myBlack,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: myColor.myBlack),
                  child: FlatButton(
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      _validateInputs();
                      if(isValid) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpPage(
                                widget.privelege, widget.fullName,
                                widget.fieldofStudy)));
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _validateInputs() {

    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      isValid=true;
      _formKey.currentState.save();
    } else {
      isValid=false;
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
