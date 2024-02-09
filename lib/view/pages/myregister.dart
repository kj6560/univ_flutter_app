import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/registerusercontroller.dart';
import 'package:univ_app/utility/values.dart';
import 'package:univ_app/view/contents/Register.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffffffff),
          body: Register()
      ),
    );
  }
}
