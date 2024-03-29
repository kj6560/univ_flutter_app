import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/communitycontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/communitybottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/constantpages/mycommunityappbar.dart';
import 'package:univ_app/view/contents/Community.dart';
import 'package:univ_app/view/contents/Messenger.dart';

class MyMessenger extends StatefulWidget {
  const MyMessenger({super.key});

  @override
  State<MyMessenger> createState() => _MyMessengerState();
}

class _MyMessengerState extends State<MyMessenger> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.white, // Set the status bar color here
    // ));
    return SafeArea(
      child: Scaffold(
        body: Messenger(),
        bottomNavigationBar: MyCommunityBottomNavigationBar(),
      ),
    );
  }
}
