import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/contents/EventDetails.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';

class MyEventDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: MyAppBar(),
      ),
      body: EventDetails(),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
