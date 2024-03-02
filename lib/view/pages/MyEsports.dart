import 'package:flutter/material.dart';
import 'package:univ_app/view/contents/Esports.dart';

import '../constantpages/MyCustomAppBar.dart';
import '../constantpages/bottomnavigationbar.dart';

class MyEsports extends StatefulWidget {
  const MyEsports({super.key});

  @override
  State<MyEsports> createState() => _MyEsportsState();
}

class _MyEsportsState extends State<MyEsports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Esports(),
      bottomNavigationBar:
      MyBottomNavigationBar(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
