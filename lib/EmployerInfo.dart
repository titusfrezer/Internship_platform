import 'package:flutter/material.dart';
import 'package:internship_platform/ChoosePrivelege.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/SignUp.dart';
import 'package:internship_platform/WaveClipper.dart';

import 'LoginPage.dart';
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _autoValidate = false;
bool isValid;
class EmployerInfoPage extends StatefulWidget {

  @override
  _EmployerInfoPageState createState() => _EmployerInfoPageState();
  String privelege;
  String EmployerName;
  String EmployerLocation;
  EmployerInfoPage(this.privelege);
}

class _EmployerInfoPageState extends State<EmployerInfoPage> {
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
                        gradient: LinearGradient(
                            colors: [Colors.purple.shade100,  Colors.purple.shade100])),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper3(),
                  child: Container(
                    child: Column(),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.purple, Colors.purple])),
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
                        gradient: LinearGradient(
                            colors: [myColor.myBlack, myColor.myBlack])),
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
                    widget.EmployerName = value;
                  },
                  onChanged: (String value){},
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: "Employer(Company) Name",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.person,
                          color: Colors.purple,
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
                    if(value.length<5){
                      return 'valid Location required';
                    }
                    return null;
                  },
                  onSaved: (value){
                    widget.EmployerLocation = value;
                  },
                  onChanged: (String value){},
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: "Location e.g Kazanchis",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
                          color: Colors.purple,
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
                      color: Colors.purple),
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
                                widget.privelege, widget.EmployerName,
                                widget.EmployerLocation)));
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
        _autoValidate = true;
      });
    }
  }
}

