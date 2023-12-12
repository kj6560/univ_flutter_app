import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  String profilePictureUrl = '';
  int currentRoute = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed("/home");
        break;
      case 1:
        Get.offAllNamed("/community");
        break;
      case 2:
        Get.offAllNamed("/performance");
        break;
      case 3:
        Get.offAllNamed("/social_profile");
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    if (Get.currentRoute == "/home") {
      setState(() {
        currentRoute = 0;
      });
    } else if (Get.currentRoute == "/community") {
      setState(() {
        currentRoute = 1;
      });
    } else if (Get.currentRoute == "/performance") {
      setState(() {
        currentRoute = 2;
      });
    } else if (Get.currentRoute == "/social_profile") {
      setState(() {
        currentRoute = 3;
      });
    }
    loadProfilePicture();
  }

  Future<void> loadProfilePicture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePictureUrl = prefs.getString('image') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Performance',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_rounded),
          label: 'Profile',
        ),
      ],
      currentIndex: currentRoute,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromRGBO(26, 188, 156, 70),
      onTap: _onItemTapped,
    );
  }
}
