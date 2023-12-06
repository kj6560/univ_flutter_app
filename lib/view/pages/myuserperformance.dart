import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/contents/EventGallery.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';
import 'package:univ_app/view/contents/UserPerformance.dart';

class MyUserPerformance extends StatefulWidget {
  const MyUserPerformance({super.key});

  @override
  State<MyUserPerformance> createState() => _MyUserPerformanceState();
}

class _MyUserPerformanceState extends State<MyUserPerformance> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: PreferredSize(

          preferredSize: const Size.fromHeight(55), // Set this height
          child: MyAppBar(),
        ),
        body: UserPerformance(),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}
