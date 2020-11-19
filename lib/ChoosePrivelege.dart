import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_platform/EmployerInfo.dart';
import 'package:internship_platform/PersonalInfo.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';

class ChoosePrivelege extends StatefulWidget {
  @override
  _ChoosePrivelegeState createState() => _ChoosePrivelegeState();
}



class _ChoosePrivelegeState extends State<ChoosePrivelege> {
  handleChange(int value) {
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        radioValue = value;
        print('changeed');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
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
                        Icons.school,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Choose Privelege",
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
          Center(
            child: Text('Continue As :'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: [
                    Radio<int>(
                        activeColor: myColor.myBlack,
                        value: 0,
                        groupValue: radioValue,
                        onChanged: handleChange),
                    Text('Intern',
                        style: GoogleFonts.delius(
                            color: Colors.black, fontSize: 20)),
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                        activeColor: myColor.myBlack,
                        value: 1,
                        groupValue: radioValue,
                        onChanged: handleChange),
                    Text('Employer',
                        style: GoogleFonts.delius(
                            color: Colors.black, fontSize: 20))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: myColor.myBlack),
                child: FlatButton(
                  child: Text("Next",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => radioValue == 0
                            ? PersonalInfoPage('Intern')
                            : EmployerInfoPage('Employer')));
                  },
                ),
              )),
          SizedBox(
            height: 20,
          ),
//
        ],
      ),
    );
  }
}
