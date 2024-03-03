import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/view/contents/Login.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Login(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
