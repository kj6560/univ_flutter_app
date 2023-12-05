import 'package:flutter/material.dart';
import 'package:univ_app/view/contents/ForgotPassword.dart';
import 'package:univ_app/view/contents/OtpVerification.dart';

import '../contents/ResetPassword.dart';

class MyResetPassword extends StatefulWidget {
  const MyResetPassword({super.key});

  @override
  State<MyResetPassword> createState() => _MyResetPasswordState();
}

class _MyResetPasswordState extends State<MyResetPassword> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          body: ResetPassword()
      ),
    );
  }
}
