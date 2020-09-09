import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:file_picker/file_picker.dart';
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
var isloading=false;
var file;
class Apply extends StatefulWidget {
  @override
  _ApplyState createState() => _ApplyState();


}

class _ApplyState extends State<Apply> {
  TextEditingController applierName = TextEditingController();
  TextEditingController areaofExpertise = TextEditingController();
  TextEditingController appplierEmail = TextEditingController();
  DatabaseReference applyRef = FirebaseDatabase.instance.reference().child('application');
  bool _autoValidate = false;
  String _name;
  String _email;
  String _expertise;

  posttoFirebase(String name,String email,String expertise)async{

    StorageReference reference = FirebaseStorage.instance.ref().child('${name}.pdf');
    StorageUploadTask uploadTask = reference.putData(file.readAsBytesSync());

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    int length = await file.length();
    print('the length is ${length}');
//    documentFileUpload(url,length);
    applyRef.push().set(<dynamic,dynamic>{

       'ApplierName': name,

       'ApplierEmail' :email,

       'ApplierExpertise':expertise,

       'cvUrl' : url
    });
    setState(() {
      isloading = false;
    });
  }
  Future getPdfAndUpload() async {
    file =
    await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');
//    String name = file.path.split('/').last;
    String fileName = '${applierName.text}.pdf';
    print(fileName);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: FormUI(),
          ),
        ),
      ),
    );
  }

  Widget FormUI() {
    return new Column(
      children: <Widget>[
         TextFormField(

          decoration: const InputDecoration(labelText: 'Name'),
          keyboardType: TextInputType.text,
           validator: validateName,
           onSaved: (String val) {
             _name = val;
           },
           controller: applierName,
        ),
         TextFormField(
          decoration: const InputDecoration(labelText: 'Area of expertise',
              hintText: 'e.g Software Engineering(Laravel)'),
          keyboardType: TextInputType.text,
           validator: validateField,
           onSaved: (String val) {
             _expertise = val;
           },
        ),
         TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
           validator: validateEmail,
           onSaved: (String val) {
             _email = val;
           },
        ),
         SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.only(left: 2, right: 40, bottom: 20),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        child: Text('Select File',
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("Pick File"),
                      onPressed: () {
                        getPdfAndUpload();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
         RaisedButton(
          onPressed:() async{

            _validateInputs();
            setState(() {
              isloading = true;
            });
           await posttoFirebase(_name,_email,_expertise);

            Flushbar(
              icon: Icon(Icons.check,color: Colors.green,),
              backgroundColor: Colors.green,

              title:  "Success",
              message:  "Job posted successfully",
              duration:  Duration(seconds: 3),
            )..show(context);
          },
          child: isloading?SpinKitWave(color: Colors.pinkAccent,): Text('Apply'),
        )
      ],
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validateField(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length < 10)
      return 'please make sure it is at least 10 character';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}
