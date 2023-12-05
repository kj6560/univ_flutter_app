import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/constantpages/myappbar.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';

class MySocialProfile extends StatefulWidget {
  const MySocialProfile({super.key});

  @override
  State<MySocialProfile> createState() => _MySocialProfileState();
}

class _MySocialProfileState extends State<MySocialProfile> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: SocialProfile(),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}
