import 'package:flutter/material.dart';
import 'package:univ_app/view/contents/ForgotPassword.dart';
import 'package:univ_app/view/contents/OtpVerification.dart';

class MyOtpVerification extends StatefulWidget {
  const MyOtpVerification({super.key});

  @override
  State<MyOtpVerification> createState() => _MyOtpVerificationState();
}

class _MyOtpVerificationState extends State<MyOtpVerification> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: OtpVerification()
    );
  }
}
