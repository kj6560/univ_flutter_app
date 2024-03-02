import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _controller = TextEditingController();
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RemoteServices.showSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: Colors.white.withOpacity(0.2),
            child: const Center(
                child:
                    CircularProgressIndicator())) // Show progress indicator when loading
        : Scaffold(
            backgroundColor: const Color(0xffffffff),
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xffffffff),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              title: const Text(
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
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://pbs.twimg.com/media/Dq6yj5QXQAAmLOQ.jpg",
                        height: 250,
                        width: 250,
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const Padding(
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
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Please enter your registered mobile number to receive a confirmation code for setting up a new password.",
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(
                              color: Color(0xff000000), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(
                              color: Color(0xff000000), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(
                              color: Color(0xff000000), width: 1),
                        ),
                        labelText: "Enter Mobile Number",
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                        hintText: "Enter Your Registered Mobile Number",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        isDense: false,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: MaterialButton(
                        onPressed: () {
                          if(Values.isValidPhoneNumber(_controller.text.toString())){
                            _sendOtp(_controller.text.toString(), context);
                          }else{
                            Values.showMsgDialog("Forgot Password", "Invalid email", context, () {
                              Navigator.of(context).pop();
                            });
                          }

                        },
                        color: Values.primaryColor,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.all(16),
                        textColor: const Color(0xffffffff),
                        height: 45,
                        minWidth: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Proceed",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void _sendOtp(String number, var context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      print(Uri.parse(Values.sendSmsOtp));
      http.Response response = await http.post(Uri.parse(Values.sendSmsOtp),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'number': number}));
      var responseObject = jsonDecode(response.body);
      print(responseObject);
      if (response.statusCode == 200) {

        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
            "otp_for_verification", responseObject['otp'].toString());
        prefs.setString("number_for_otp", number);
        setState(() {
          _isLoading = false;
        });
        Get.toNamed('/verify_otp');
      }else{
        setState(() {
          _isLoading = false;
        });
        Values.showMsgDialog("Forgot Password", responseObject['msg'], context, () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Values.showInternetErrorDialog("Forgot Password",e, context);
    }
  }
}
