import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class createCategory extends StatefulWidget {
  @override
  _createCategoryState createState() => _createCategoryState();
}

class _createCategoryState extends State<createCategory> {
  DatabaseReference catRef=FirebaseDatabase.instance.reference().child('Categories');
  TextEditingController controller = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Category'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Center(child: Text('Create Category',style: TextStyle(fontSize: 30),)),

         TextField(decoration: InputDecoration(
              labelText: 'Category Name',
              hintText: 'Software Engineering'

            ),
                controller:controller
            ),
SizedBox(height: 30,),
          RaisedButton(
            child: isloading?SpinKitWave(color: Colors.pink,):Text('Save'),
            onPressed: (){
              setState(() {
                isloading = true;
              });
              if(controller.text.isEmpty){
                Flushbar(
                  icon: Icon(Icons.error,color: Colors.red,),
                  backgroundColor: Colors.red,

                  title:  "Error",
                  message:  "Fill the Category Name field",
                  duration:  Duration(seconds: 3),
                )..show(context);
              }else {
                setState(() {
                  isloading=false;
                });
                catRef.push().set(<dynamic, dynamic>{
                  'type': controller.text
                });


                Flushbar(
                  icon: Icon(Icons.check,color: Colors.green,),
                  backgroundColor: Colors.green,

                  title:  "Success",
                  message:  "Category posted successfully",
                  duration:  Duration(seconds: 3),
                )..show(context);

              }

            },
          )
        ],
      ),
    );
  }
}
