import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
class ViewProfile extends StatelessWidget {
  final email;

  ViewProfile(this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child('Users')
            .orderByChild("email")
            .equalTo(email)
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map map = snapshot.data.snapshot.value;
            print("map is $map");
            return ListView(
              children: [
                Text(map.values.toList()[0]['userName']),
                SizedBox(
                  height: 20,
                ),
                Text(map.values.toList()[0]['furtherInfo']),
                map.values.toList()[0]['github'] != ""
                    ? RaisedButton(
                    onPressed: () {
                      UrlLauncher.launch(
                          map.values.toList()[0]['github']
                      );
                    },
                        child: Text("Github projects"))
                    : Text('')
              ],
            );
          }
          return SpinKitWave(color: Colors.pink);
        },
      ),
    );
  }
}
