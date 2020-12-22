import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:internship_platform/Utilities/variables.dart';
import 'package:internship_platform/model/ApplyForJob.dart';
import 'package:intl/intl.dart';

class Apply extends ChangeNotifier{
  DatabaseReference applyRef =
  FirebaseDatabase.instance.reference().child('application');
  var telegram;
  var github;
  chooseFile () async{

    file = await FilePicker.getFile(
        type: FileType.CUSTOM, fileExtension: 'pdf');
    await getInfo(); // to get the name of the file
    isfileChosen = true;
    notifyListeners();

  }
  getInfo() async{

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
      fullName = map.values.toList()[0]['userName'];
      furtherInfo = map.values.toList()[0]['furtherInfo'];
      imageurl = map.values.toList()[0]['url'];
      telegram = map.values.toList()[0]['telegram'];
      github = map.values.toList()[0]['github'];
    });
  }
  void submitApplication(ApplyForJob application) async{
    // await getInfo();
    isLoading = true;
    notifyListeners();
    StorageReference reference =
    FirebaseStorage.instance.ref().child('$fullName.pdf');
    StorageUploadTask uploadTask = reference.putData(file.readAsBytesSync());

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    await applyRef.push().set(<dynamic, dynamic>{
      'ApplierName': fullName,
      'ApplierEmail': user.email,
      'ApplierExpertise': furtherInfo,
      'cvUrl': url,
      'category': application.category,
      'AppliedTo': application.AppliedTo,
      'jobTitle': application.jobTitle,
      'imageUrl':imageurl,
      'telegram': telegram,
      'github':github,
      'token':application.token
    });

    isLoading = false;
    isfileChosen = false;
    notifyListeners();
  }

  bool get isloading => isLoading;
  bool get isFileChosen => isfileChosen;
}