import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univ_app/view/constantpages/bottomnavigationbar.dart';
import 'package:univ_app/view/contents/SocialProfile.dart';

class MySocialProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.white,
        ),
      ),
      body: SocialProfile(),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
