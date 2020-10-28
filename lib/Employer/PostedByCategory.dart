import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Employer/PostJob.dart';
import 'package:intl/intl.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';

class PostedByCategory extends StatefulWidget {
  @override
  _PostedByCategoryState createState() => _PostedByCategoryState();
  String name;
  String category;
  PostedByCategory(this.name,this.category);
}
bool viewVisible =false;
class _PostedByCategoryState extends State<PostedByCategory> {

  @override
  Widget build(BuildContext context) {
    Query postedRef =FirebaseDatabase.instance.reference().child("posts").orderByChild("category").equalTo(widget.category);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category}'),
        backgroundColor: myColor.myBlack,
      ),
      body: StreamBuilder(
        stream:postedRef .onValue,
        builder: (BuildContext context,snapshot){
   if(snapshot.hasData) {
     if (snapshot.data.snapshot.value != null) {
       Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
       return ListView.builder(
         itemBuilder: (context, int index) {
           print("the suer s ${widget.name}");
           print(map.values.toList()[index]['postedBy']);
           if (map.values.toList()[index]['postedBy'] == widget.name) {
             return Dismissible(background: Container(color: Colors.pink,child: Center(child:Text('Delete')),),
               confirmDismiss:(direction){

                 return showDialog(context: context,builder: (context){
                   return AlertDialog(
                     title: Text(
                         'Are you sure you want to delete!!'),
                     actions: <Widget>[
                       FlatButton(
                           child: Text('Yes'),
                           onPressed: () {
                             setState(() {
                               FirebaseDatabase.instance.reference().child("posts").child(map.keys.toList()[index]).remove();
                             });


                             Navigator.of(context).pop();
                           }),
                       FlatButton(
                         child: Text('No'),
                         onPressed: () {
                           Navigator.of(context).pop();
                         },
                       ),

                     ],
                   );
                 });},
               key: Key(map.keys.toList()[index].toString()),
                 child:  Card(
                   color: myColor.myBlack,
                   child: ListTile(
                         leading: Icon(Icons.work, color: Colors.pink),
                         title: Text(map.values.toList()[index]['jobTitle'],style: TextStyle(color: Colors.white),),
                         subtitle: Text(map.values.toList()[index]['postedAt'],style:TextStyle(color: Colors.white) ,),
                         trailing:
                             map.values.toList()[index]['status'] == 'open'
                                 ? RaisedButton(
                               child: Text('Close'),
                               onPressed: () {
                                 setState(() {
                                   print(map.values.toList()[index]);
                                   FirebaseDatabase.instance.reference().child("posts")
                                       .child(map.keys.toList()[index])
                                       .update({

                                     'jobTitle': map.values.toList()[index]['jobTitle'],

                                     'jobDescription': map.values
                                         .toList()[index]['jobDescription'],

                                     'howLong': map.values.toList()[index]['howLong'],

                                     'companyName': map.values
                                         .toList()[index]['companyName'],

                                     'allowance': map.values.toList()[index]['allowance'],

                                     'category': map.values.toList()[index]['category'],

                                     'postedBy': map.values.toList()[index]['postedBy'],

                                     'postedAt': DateFormat('yyyy-MM-dd').format(
                                         DateTime.now()),

                                     'status': 'closed'
                                   })
                                       .then((_) {
                                     print('done');
                                   });
                                 });
                                 Flushbar(
                                   icon: Icon(Icons.check, color: Colors.green,),
                                   backgroundColor: Colors.green,

                                   title: "Sucess",
                                   message: "Job Closed",
                                   duration: Duration(seconds: 3),
                                 )
                                   ..show(context);
                               },
                             )
                                 : Text(''),


                     ),
                 ),

             );
           }
           return Container();
         },
         itemCount: map.values
             .toList()
             .length,
       );
     }
   }else{
    return  SpinKitWave(color: Colors.pink,);
   }
   return Center(child:Text('No post from this category'));

        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>PostJob(widget.category)));
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        child: Icon(Icons.add,size:25,color: Colors.pink,),
      ),
    );
  }
}
