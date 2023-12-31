import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed("/home");
        break;
      case 1:
        Get.offAllNamed("/search");
        break;
      case 2:
        Get.offAllNamed("/new");
        break;
      case 3:
        Get.offAllNamed("/reels");
        break;
      case 4:
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
    } else if (Get.currentRoute == "/search") {
      setState(() {
        currentRoute = 1;
      });
    } else if (Get.currentRoute == "/new") {
      setState(() {
        currentRoute = 2;
      });
    } else if (Get.currentRoute == "/reels") {
      setState(() {
        currentRoute = 3;
      });
    } else if (Get.currentRoute == "/reels") {
      setState(() {
        currentRoute = 4;
      });
    }
    loadProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 40), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.search, size: 40), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded, size: 40), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.ondemand_video_rounded, size: 40), label: ""),
        BottomNavigationBarItem(icon: CircleAvatar(
                radius: 20,
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                backgroundImage: CachedNetworkImageProvider(
                    '${Values.profilePic}$profilePictureUrl')), label: ""),
      ],
      currentIndex: currentRoute,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromRGBO(26, 188, 156, 70),
      onTap: _onItemTapped,
    );
  }
}
