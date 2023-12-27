import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/communitycontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/contents/Community.dart';

class MyCommunity extends StatefulWidget {
  const MyCommunity({super.key});

  @override
  State<MyCommunity> createState() => _MyCommunityState();
}

class _MyCommunityState extends State<MyCommunity> {
  SliderController sliderController = Get.put(SliderController());
  EventController eventController = Get.put(EventController());
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55), // Set this height
          child: MyAppBar(),
        ),
        body: Community(),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}
