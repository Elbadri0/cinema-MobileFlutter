import 'package:flutter/material.dart';
class aboutPage extends StatefulWidget {
  @override
  _aboutPageState createState() => _aboutPageState();
}

class _aboutPageState extends State<aboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Center(
        child: Text("Created by ELBADRI Abdelhamid 2ACI"),
      ),
    );
  }
}
