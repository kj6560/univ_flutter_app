import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';

class Welcome extends StatefulWidget {
  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[Center(child: Text("Coming soon"))],
          ),
        ));
  }
}
