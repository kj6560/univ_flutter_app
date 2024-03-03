import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/utility/values.dart';

class MyCommunityBottomNavigationBar extends StatefulWidget {
  @override
  State<MyCommunityBottomNavigationBar> createState() =>
      _MyCommunityBottomNavigationBarState();
}

class _MyCommunityBottomNavigationBarState
    extends State<MyCommunityBottomNavigationBar> {
  String profilePictureUrl = '';
  int currentRoute = 0;
  final List<String> items = ["Add Photos", "Add Videos", "Add Certificates"];

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed("/home");
        break;
      case 1:
        Get.offAllNamed("/community");
        break;
      case 2:
        Get.offAllNamed("/search");
        break;
      case 3:
        Get.offAllNamed("/new");
        break;
      case 4:
        Get.offAllNamed("/reels");
        break;
      case 5:
        Get.offAllNamed("/social_profile");
        break;
      default:
    }
  }

  Future<void> loadProfilePicture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePictureUrl = prefs.getString('image') ?? "";
    });
    Values.cacheFile('${Values.profilePic}$profilePictureUrl');
  }

  @override
  void initState() {
    super.initState();
    if (Get.currentRoute == "/home") {
      setState(() {
        currentRoute = 0;
      });
    }else if (Get.currentRoute == "/community") {
      setState(() {
        currentRoute = 1;
      });
    } else if (Get.currentRoute == "/search") {
      setState(() {
        currentRoute = 2;
      });
    } else if (Get.currentRoute == "/new") {
      setState(() {
        currentRoute = 3;
      });
    } else if (Get.currentRoute == "/reels") {
      setState(() {
        currentRoute = 4;
      });
    } else if (Get.currentRoute == "/reels") {
      setState(() {
        currentRoute = 5;
      });
    }
    loadProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[Values.primaryColor, Colors.teal]),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home, size: 20), label: ""),
            const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.icons, size: 20), label: ""),
            const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.magnifyingGlass, size: 20), label: ""),
            const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.squarePlus, size: 20), label: ""),
            const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.film, size: 20), label: ""),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                    radius: 14,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    backgroundImage: CachedNetworkImageProvider(
                        '${Values.profilePic}$profilePictureUrl')),
                label: ""),
          ],
          currentIndex: currentRoute,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromRGBO(26, 188, 156, 70),
          onTap: _onItemTapped,
          unselectedFontSize: 1,
          selectedFontSize: 1,
        ),
      ),
    );
  }
}

