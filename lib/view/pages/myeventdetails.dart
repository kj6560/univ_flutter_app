import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/contents/EventDetails.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';

class MyEventDetails extends StatefulWidget {
  const MyEventDetails({super.key});

  @override
  State<MyEventDetails> createState() => _MyEventDetailsState();
}

class _MyEventDetailsState extends State<MyEventDetails> {
  // int _selectedIndex = 0;
  // void _onItemTapped(int index) {
  //   switch (index) {
  //     case 0:
  //       Get.offAllNamed("/home");
  //       break;
  //     case 1:
  //       Get.offAllNamed("/community");
  //       break;
  //     case 2:
  //       Get.offAllNamed("/social_profile");
  //     default:
  //   }
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55), // Set this height
          child: MyAppBar(),
        ),
        body: EventDetails(),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}
