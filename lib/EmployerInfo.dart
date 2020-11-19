import 'package:flutter/material.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/SignUp.dart';
import 'package:internship_platform/WaveClipper.dart';



class EmployerInfoPage extends StatefulWidget {

  @override
  _EmployerInfoPageState createState() => _EmployerInfoPageState();
  String privelege;
  String employerName;
  String employerLocation;
  EmployerInfoPage(this.privelege);
}

class _EmployerInfoPageState extends State<EmployerInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,

        autovalidate: autoValidate,
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
                        gradient:  SweepGradient(colors: [
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
                          "Employer Infomation",
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
                  validator: (value){
                    if(value.length<5){
                      return 'valid name required';
                    }
                    return null;
                  },
                  onSaved: (value){
                    widget.employerName = value;
                  },
                  onChanged: (String value){},
                  cursorColor: myColor.myBlack,
                  decoration: InputDecoration(
                      hintText: "Employer(Company) Name",
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
                  validator: (value){
                    if(value.length<3){
                      return 'valid Location required';
                    }
                    return null;
                  },
                  onSaved: (value){
                    widget.employerLocation = value;
                  },
                  onChanged: (String value){},
                  cursorColor:myColor.myBlack,
                  decoration: InputDecoration(
                      hintText: "Location e.g Kazanchis",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.add_location,
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUpPage(
                                widget.privelege, widget.employerName,
                                widget.employerLocation)));
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
      _formKey.currentState.save();
      isValid= true;
    } else {
      isValid=false;
//    If all data are not valid then start auto validation.
      setState(() {
        autoValidate = true;
      });
    }
  }
}

