import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/utility/values.dart';

class OtpVerification extends StatefulWidget {
  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Values.primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      "Verification",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child:

                        ///***If you have exported images you must have to copy those images in assets/images directory.
                        Image(
                      image: NetworkImage(
                          "https://cdn3.iconfinder.com/data/icons/infinity-blue-office/48/005_084_email_mail_verification_tick-512.png"),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                " We have send you an access code via SMS for Mobile number verifications.",
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff000000),
                ),
              ),
            ),
            const Text(
              "Enter Code here",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                color: Color(0xff545454),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 10, 50),
              child: OtpTextField(
                numberOfFields: 6,
                showFieldAsBox: true,
                fieldWidth: 50,
                filled: true,
                fillColor: const Color(0x00000000),
                enabledBorderColor: const Color(0xffaaaaaa),
                focusedBorderColor: const Color(0xff3a57e8),
                borderWidth: 2,
                margin: const EdgeInsets.all(0),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                obscureText: false,
                borderRadius: BorderRadius.circular(8.0),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  color: Color(0xff000000),
                ),
                onCodeChanged: (String code) {
                  if(code.length == 6){
                    _verifyOtp(code);
                  }
                },
                onSubmit: (String verificationCode) {
                  if(verificationCode.length == 6){
                    _verifyOtp(verificationCode);
                  }
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: InkWell(
                  onTap: () {
                    print("clicked on resend");
                  },
                  child: const Text(
                    "Resend Code",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Values.primaryColor,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _verifyOtp(String otp) async {
    try {

        final prefs = await SharedPreferences.getInstance();
        var savedEmail = prefs.getString("email_for_otp");
        var savedOtp =  prefs.getString("otp_for_verification");
        if(savedOtp!.contains(otp)){
          prefs.setBool("show_reset", true);
          Get.toNamed('/reset_password');
        }

    } catch (e) {
      print(e.toString());
    } finally {}
  }
}
