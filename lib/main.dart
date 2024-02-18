import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/view/pages/mycommunity.dart';
import 'package:univ_app/view/pages/myeventdetails.dart';
import 'package:univ_app/view/pages/myeventgallery.dart';
import 'package:univ_app/view/pages/myeventregistration.dart';
import 'package:univ_app/view/pages/myfollowers.dart';
import 'package:univ_app/view/pages/myfollowings.dart';
import 'package:univ_app/view/pages/myforgotpassword.dart';
import 'package:univ_app/view/pages/myhome.dart';
import 'package:univ_app/view/pages/mylogin.dart';
import 'package:univ_app/view/pages/mymessenger.dart';
import 'package:univ_app/view/pages/myotpverification.dart';
import 'package:univ_app/view/pages/mypostdetail.dart';
import 'package:univ_app/view/pages/myreels.dart';
import 'package:univ_app/view/pages/myregister.dart';
import 'package:univ_app/view/pages/myresetpassword.dart';
import 'package:univ_app/view/pages/mysocialprofile.dart';
import 'package:univ_app/view/pages/myuserperformance.dart';
import 'package:univ_app/view/pages/myuserprofile.dart';
import 'package:univ_app/view/pages/mypickaction.dart';
import 'package:univ_app/view/pages/myusersearch.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => const MySudoHome()),
      GetPage(
        name: '/search',
        page: () => MyUserSearch(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/post_detail',
        page: () => MyPostDetail(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/messenger',
        page: () => const MyMessenger(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/home',
        page: () => MyHome(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/new',
        page: () => MyPickAction(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/social_profile',
        page: () => MySocialProfile(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/user_profile',
        page: () => MyUserProfile(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/performance',
        page: () => MyUserPerformance(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/event_details',
        page: () => MyEventDetails(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/event_gallery',
        page: () => MyEventGallery(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
          name: '/event_registration', page: () => const MyEventRegistration()),
      GetPage(
        name: '/community',
        page: () => MyCommunity(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/reels',
        page: () => MyReels(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/followers',
        page: () => MyFollowers(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/followings',
        page: () => MyFollowings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/register',
        page: () => const MyRegister(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/login',
        page: () => const MyLogin(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/forgot_password',
        page: () => const MyForgotPassword(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/verify_otp',
        page: () => const MyOtpVerification(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/reset_password',
        page: () => const MyResetPassword(),
        transition: Transition.rightToLeft,
      )
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

    if (_token != null && _token!.isNotEmpty) {
      Get.offAllNamed("/home");
    } else {
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
