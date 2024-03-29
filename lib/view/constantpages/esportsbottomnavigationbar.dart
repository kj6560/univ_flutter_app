import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/utility/values.dart';

class MyEsportsBottomNavigationBar extends StatefulWidget {
  @override
  State<MyEsportsBottomNavigationBar> createState() => _MyEsportsBottomNavigationBarState();
}

class _MyEsportsBottomNavigationBarState extends State<MyEsportsBottomNavigationBar> {
  String profilePictureUrl = '';
  int currentRoute = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed("/home");
        break;
      case 1:
        Get.toNamed("/community");
        break;
      case 2:
        Get.toNamed("/esports");
        break;
      case 3:
        Get.toNamed("/performance");
        break;
      case 4:
        Get.toNamed("/social_profile");
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
      color: Colors.black,
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home, size: 20), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.peopleArrows, size: 20), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.basketball, size: 20), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.squarePollVertical, size: 20), label: ""),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                  radius: 14,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  backgroundImage: CachedNetworkImageProvider(
                      '${Values.profilePic}$profilePictureUrl')),
              label: " "),
        ],
        currentIndex: currentRoute,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromRGBO(26, 188, 156, 70),
        onTap: _onItemTapped,
        unselectedFontSize: 1,
        selectedFontSize: 1,
      ),
    );
  }
}


