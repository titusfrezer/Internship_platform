import 'package:flutter/material.dart';

class InternLandingPage extends StatefulWidget {
  @override
  _InternLandingPageState createState() => _InternLandingPageState();
}

class _InternLandingPageState extends State<InternLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE1E1E2),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: IconButton(icon: Icon(Icons.list), onPressed: () {})),
                Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: IconButton(icon: Icon(Icons.person), onPressed: () {}))
              ],
            ),
          )
        ],
      ),
    );
  }
}
