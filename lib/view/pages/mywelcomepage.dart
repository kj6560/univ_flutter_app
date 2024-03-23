import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';
import 'package:univ_app/view/contents/Welcome.dart';

class MyWelcome extends StatefulWidget {
  const MyWelcome({super.key});

  @override
  State<MyWelcome> createState() => _MyWelcomeState();
}

class _MyWelcomeState extends State<MyWelcome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar:  PreferredSize(
          preferredSize: const Size.fromHeight(60), // Set this height
          child: Welcome(),
        ),
        body: const Placeholder(),//SocialProfile(),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}
