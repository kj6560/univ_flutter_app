import 'package:flutter/material.dart';

class EventRegistrations extends StatefulWidget {
  @override
  State<EventRegistrations> createState() => _EventRegistrationsState();
}

class _EventRegistrationsState extends State<EventRegistrations> {
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
