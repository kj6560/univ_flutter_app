import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/view/pages/mycommunity.dart';
import 'package:univ_app/view/pages/myeventdetails.dart';
import 'package:univ_app/view/pages/myeventgallery.dart';
import 'package:univ_app/view/pages/myeventregistration.dart';
import 'package:univ_app/view/pages/myforgotpassword.dart';
import 'package:univ_app/view/pages/myhome.dart';
import 'package:univ_app/view/pages/mylogin.dart';
import 'package:univ_app/view/pages/myotpverification.dart';
import 'package:univ_app/view/pages/myregister.dart';
import 'package:univ_app/view/pages/myresetpassword.dart';
import 'package:univ_app/view/pages/mysocialprofile.dart';
import 'package:univ_app/view/pages/myuserperformance.dart';
import 'package:univ_app/view/pages/myuserprofile.dart';
import 'package:univ_app/view/pages/mywelcomepage.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => const MySudoHome()),
      GetPage(name: '/welcome', page: () => const MyWelcome()),
      GetPage(name: '/home', page: () => const MyHome()),
      GetPage(name: '/social_profile', page: () => const MySocialProfile()),
      GetPage(name: '/user_profile', page: () => const MyUserProfile()),
      GetPage(name: '/performance', page: () => const MyUserPerformance()),
      GetPage(name: '/event_details', page: () => const MyEventDetails()),
      GetPage(name: '/event_gallery', page: () => const MyEventGallery()),
      GetPage(name: '/event_registration', page: () => const MyEventRegistration()),
      GetPage(name: '/community', page: () => const MyCommunity()),
      GetPage(name: '/register', page: () => const MyRegister()),
      GetPage(name: '/login', page: () => const MyLogin()),
      GetPage(name: '/forgot_password', page: () => const MyForgotPassword()),
      GetPage(name: '/verify_otp', page: () => const MyOtpVerification()),
      GetPage(name: '/reset_password', page: () => const MyResetPassword()),
    ],
    home: MySudoHome(),
  ));
}

class MySudoHome extends StatefulWidget {
  const MySudoHome({super.key});

  @override
  State<MySudoHome> createState() => _MySudoHomeState();
}

class _MySudoHomeState extends State<MySudoHome> {
  @override
  void initState() {
    // TODO: implement initState
    isReady();
    super.initState();
  }

  void isReady() async {
    final prefs = await SharedPreferences.getInstance();
    var _token = prefs.getString("token");
    bool? show_welcome =  prefs.getBool("show_welcome");
    bool? welcome = show_welcome ?? false;
    if (_token != null && _token!.isNotEmpty) {
      Get.offAllNamed("/home");
    } else if(welcome){
      Get.offAllNamed("/welcome");
    }else{
      Get.offAllNamed("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const CircularProgressIndicator(
        color: Colors.blueAccent,
      ),
    );
  }
}
