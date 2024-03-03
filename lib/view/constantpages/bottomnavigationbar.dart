import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/utility/values.dart';

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
        Get.offAllNamed("/esports");
        break;
      case 3:
        Get.offAllNamed("/performance");
        break;
      case 4:
        Get.offAllNamed("/social_profile");
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    loadProfilePicture();
    if (Get.currentRoute == "/home") {
      setState(() {
        currentRoute = 0;
      });
    } else if (Get.currentRoute == "/community") {
      setState(() {
        currentRoute = 1;
      });
    }else if (Get.currentRoute == "/esports") {
      setState(() {
        currentRoute = 2;
      });
    } else if (Get.currentRoute == "/performance") {
      setState(() {
        currentRoute = 3;
      });
    } else if (Get.currentRoute == "/social_profile") {
      setState(() {
        currentRoute = 4;
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
    return BottomAppBar(
      child: BottomNavigationBar(
        iconSize: 22,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Community',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: 'Esports',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Performance',
          ),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                  radius: 10,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  backgroundImage: CachedNetworkImageProvider(
                      '${Values.profilePic}$profilePictureUrl')),
              label: "Profile"),
        ],
        currentIndex: currentRoute,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromRGBO(26, 188, 156, 70),
        onTap: _onItemTapped,
      ),
    );
  }
}


