import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';

class MyEventRegistration extends StatefulWidget {
  const MyEventRegistration({super.key});

  @override
  State<MyEventRegistration> createState() => _MyEventRegistrationState();
}

class _MyEventRegistrationState extends State<MyEventRegistration> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed("/home");
        break;
      case 1:
        Get.offAllNamed("/community");
        break;
      case 2:
        Get.offAllNamed("/social_profile");
      default:
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55), // Set this height
          child: MyAppBar(),
        ),
        body: SocialProfile(),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}
