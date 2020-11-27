import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:internship_platform/Intern/Utilities/variables.dart';
import 'package:internship_platform/model/PostJob.dart';
import 'package:intl/intl.dart';

class Job extends ChangeNotifier{
  DatabaseReference postRef =
  FirebaseDatabase.instance.reference().child('posts');

  void postJob(Post job) async{

    isLoading = true;
    notifyListeners();
    user = await firebaseAuth.currentUser();
   await FirebaseDatabase.instance
        .reference()
        .child("Users")
        .orderByChild('email')
        .equalTo(user.email)
        .once()
        .then((DataSnapshot snapshot) {
      Map map = snapshot.value;
      print("map is ${map.values.toList()}");
      companyName = map.values.toList()[0]['userName'];
    });
    await postRef.push().set(<dynamic, dynamic>{
      'jobTitle': job.jobTitle.substring(0, 1).toUpperCase() +
          job.jobTitle.substring(1, job.jobTitle.length),
      'firstLetter': job.jobTitle.substring(0, 1).toUpperCase(),
      'jobDescription': job.jobDescrption,
      'howLong': job.howLong,
      'companyName': companyName,
      'allowance': job.allowance,
      'category': job.category,
      'postedBy': user.email,
      'postedAt': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'status': 'open'
    });

    isLoading = false;
    notifyListeners();
    }

    bool get isloading => isLoading;
}