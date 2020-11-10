import 'package:flutter/material.dart';
import 'package:internship_platform/EmployerInfo.dart';
import 'package:internship_platform/PersonalInfo.dart';
import 'package:internship_platform/WaveClipper.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
class ChoosePrivelege extends StatefulWidget {
  @override
  _ChoosePrivelegeState createState() => _ChoosePrivelegeState();
}
int radioValue = 0;
class _ChoosePrivelegeState extends State<ChoosePrivelege> {

  handleChange(int value) {
    if (this.mounted) { // check whether the state object is in tree


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
                      gradient: LinearGradient(
                          colors: [myColor.myBlack, myColor.myBlack])),
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
            padding: EdgeInsets.symmetric(horizontal: 32)
                ,child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<int>(
                  activeColor: Colors.orangeAccent,
                  value:0,groupValue: radioValue,onChanged: handleChange
              ),
              Text('Intern',style:TextStyle(color:Colors.black,fontSize: 25)),

              Radio<int>(
                  activeColor: Colors.pink,
                  value:1,groupValue: radioValue,onChanged: handleChange),
              Text('Employer',style:TextStyle(color:Colors.black,fontSize: 25))
            ],
          ),
          ),
          SizedBox(height: 15,),
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>radioValue==0?PersonalInfoPage('Intern'):EmployerInfoPage('Employer')));
                  },
                ),
              )),
          SizedBox(height: 20,),
//

        ],
      ),
    );
  }
}
