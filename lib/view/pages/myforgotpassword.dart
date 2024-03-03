import 'package:flutter/material.dart';
import 'package:univ_app/view/contents/ForgotPassword.dart';

class MyForgotPassword extends StatefulWidget {
  const MyForgotPassword({super.key});

  @override
  State<MyForgotPassword> createState() => _MyCommunityState();
}

class _MyCommunityState extends State<MyForgotPassword> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: ForgotPassword()
    );
  }
}
