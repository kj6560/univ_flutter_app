import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/utility/values.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _controller = TextEditingController();
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAttempted();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: Colors.white.withOpacity(0.2),
            child: Center(
                child:
                    const CircularProgressIndicator())) // Show progress indicator when loading
        : Scaffold(
            backgroundColor: Color(0xffffffff),
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              title: Text(
                "Forgot Password",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  color: Color(0xff000000),
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child:

                          ///***If you have exported images you must have to copy those images in assets/images directory.
                          Image(
                        image: NetworkImage(
                            "https://pbs.twimg.com/media/Dq6yj5QXQAAmLOQ.jpg"),
                        height: 250,
                        width: 250,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Text(
                        "Forgot Password?",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Please write your email to receive a confirmation code to set a new password.",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff545252),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _controller,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide:
                              BorderSide(color: Color(0xff000000), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide:
                              BorderSide(color: Color(0xff000000), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide:
                              BorderSide(color: Color(0xff000000), width: 1),
                        ),
                        labelText: "Enter Email",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                        hintText: "Enter Your Registered Email",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: Color(0xffffffff),
                        isDense: false,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: MaterialButton(
                        onPressed: () {
                          _sendOtp(_controller.text.toString());
                        },
                        color: Color(0xff3a57e8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Confirm Mail",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        textColor: Color(0xffffffff),
                        height: 45,
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void _sendOtp(String email) async {
    try {
      setState(() {
        _isLoading = true;
      });
      http.Response response = await http.post(Uri.parse('${Values.sendOtp}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'email': email}));
      if (response.statusCode == 200) {
        var responseObject = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("email_for_otp", email);
        prefs.setString(
            "otp_for_verification", responseObject['otp'].toString());
        setState(() {
          _isLoading = false;
        });
        Get.toNamed('/verify_otp');
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }

  void checkAttempted() async {}
}
