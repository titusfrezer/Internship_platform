import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';

import 'ApplyforJob.dart';

class chooseJob extends StatefulWidget {
  @override
  _chooseJobState createState() => _chooseJobState();
  String Category;

  chooseJob(this.Category);
}

Query chooseRef;

class _chooseJobState extends State<chooseJob> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chooseRef = FirebaseDatabase.instance
        .reference()
        .child("posts")
        .orderByChild('category')
        .equalTo(widget.Category);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Choose from Category ${widget.Category}'),
        ),
        body: StreamBuilder(
          stream: chooseRef.onValue,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.snapshot.value != null) {
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                var counter =0;
                for(var i=0;i<map.values.toList().length;i++){
                  if(map.values.toList()[i]['status'] == 'closed'){
                    counter++;
                  }
                }

                    print("the count is$counter and the list size is ${map.values.toList().length}");

               if(counter==map.values.toList().length){ return Center(child:Text('No post from ${widget.Category}'));}
               else {
                 return ListView.builder(
                   itemCount: map.values
                       .toList()
                       .length,
                   scrollDirection: Axis.vertical,
                   itemBuilder: (BuildContext context, int index) {
                     if(map.values.toList()[index]['status'] == 'open') {
                       return Container(
                         width: 120,
                         margin: EdgeInsets.symmetric(horizontal: 15),
                         child: Card(
                           color: myColor.myBlack,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10.0),
                           ),
                           child: ListTile(
                             leading: Icon(
                               Icons.work,
                               color: Colors.red,
                               size: 40,
                             ),
                             title: Padding(
                                 padding: EdgeInsets.all(8.0),
                                 child: Text(
                                   map.values.toList()[index]['jobTitle'],
                                   style: TextStyle(
                                       color: myColor.myWhite,
                                       fontStyle: FontStyle.italic),
                                 )),
                             subtitle: Padding(
                                 padding: EdgeInsets.all(8.0),
                                 child: Text(
                                   map.values.toList()[index]['companyName'],
                                   style: TextStyle(
                                       color: myColor.myWhite,
                                       fontStyle: FontStyle.italic),
                                 )),
                             trailing: GestureDetector(
                                 onTap: () {
                                   Navigator.of(context).push(MaterialPageRoute(
                                       builder: (context) =>
                                           Apply(
                                               map.values
                                                   .toList()[index]['jobTitle'],
                                               map.values
                                                   .toList()[index]['category']
                                                   .toString(),
                                               map.values
                                                   .toList()[index]['postedBy'])));
                                 },
                                 child: Text(
                                   'See more',
                                   style: TextStyle(color: myColor.myWhite),
                                 )),
                           ),
                         ),
                       );
                     }
                     return Container();
                   },
                 );
               }
              }
            }
            else {
              return SpinKitWave(
                color: Colors.pink,
              );

            }

            return Center(child: Text('No post from ${widget.Category}'));
          },
        ));
  }
}
