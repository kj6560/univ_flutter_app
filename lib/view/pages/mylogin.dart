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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    RemoteServices.showSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Color(0xffffffff),
          body: Login()),
    );
  }
}
