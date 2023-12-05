import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/controllers/eventcontroller.dart';

class Community extends StatefulWidget {
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
            "We are developing an awesome community!! \nPlease stay connected for more updates",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),));
  }
}
