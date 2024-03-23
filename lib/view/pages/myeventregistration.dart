import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int user_id = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUpUser();
  }
  void setUpUser() async{
    final prefs = await SharedPreferences.getInstance();
    var loggedinUserId = prefs.getInt("id");
    setState(() {
      user_id = loggedinUserId!;
    });
  }
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
        body: const Placeholder(),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}
