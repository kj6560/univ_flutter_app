import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
            color: Values.primaryColor.withOpacity(0.2),
            child: const Center(
                child:
                    CircularProgressIndicator())) // Show progress indicator when loading
        : Scaffold(
            backgroundColor: Values.primaryColor,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topLeft,

                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                    padding: const EdgeInsets.all(0),
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                      border:
                          Border.all(color: const Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Text(
                                      "Reset Password",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              "Create your new password as per our password policy: ",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                color: Color(0xff000000),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Choose your border color
                                  width: 1.0, // Choose your border width
                                ),
                                borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
                              ),
                              child: const Text(
                                Values.passwordPolicy,
                                style: TextStyle(
                                  // Add any additional styles for the text here
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 16),
                              child: Text(
                                "Create  New Password",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xff494949),
                                ),
                              ),
                            ),
                            TextField(
                              controller: _passwordController,
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                hintText: "Enter New Password",
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xffa4a4a4),
                                ),
                                filled: true,
                                fillColor: const Color(0xfff2f2f3),
                                isDense: false,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                prefixIcon: const Icon(Icons.lock_open,
                                    color: Color(0xff212435), size: 24),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 0),
                              child: Text(
                                "Confirm Password",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xff494949),
                                ),
                              ),
                            ),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: true,
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                hintText: "Enter Confirm Password",
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xffa4a4a4),
                                ),
                                filled: true,
                                fillColor: const Color(0xfff2f2f3),
                                isDense: false,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                prefixIcon: const Icon(Icons.lock_open,
                                    color: Color(0xff212435), size: 24),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: MaterialButton(
                                onPressed: () {
                                  _resetPassword(
                                      _passwordController.text.toString(),
                                      _confirmPasswordController.text
                                          .toString(),
                                      context);
                                },
                                color: Values.primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.all(16),
                                textColor: const Color(0xffffffff),
                                height: 45,
                                minWidth: MediaQuery.of(context).size.width,
                                child: const Text(
                                  "Reset Password",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 120, 0, 0),
                    child: Container(
                      height: 80,
                      width: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvm8ciTcatzbqVYzzE6wLvIEBM3aCtRSviplxKnkUTkWHB1Fi907Cxbnm5FAX-ufKu-4M&usqp=CAU",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void _resetPassword(
      String password, String confirmPassword, var context) async {
    setState(() {
      _isLoading = true;
    });
    if (password.contains(confirmPassword) &&
        Values.isValidPassword(password)) {
      try {
        final prefs = await SharedPreferences.getInstance();
        var savedEmail = prefs.getString("email_for_otp");
        var savedOtp = prefs.getString("otp_for_verification");
        http.Response response = await http.post(
            Uri.parse(Values.resetPassword),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'email': savedEmail,
              'otp': int.parse(savedOtp!),
              'password': password
            }));

        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });
          Values.showMsgDialog(
              "Password Reset",
              "Password Reset Successful. Please login to continue",
              context, () {
            Navigator.pop(context);
            Get.offAllNamed("/login");
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        Values.showInternetErrorDialog("Reset Password",e, context);
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      if (Values.isValidPassword(password)) {
        Values.showMsgDialog(
            "Reset Password", "Passwords Do not Match", context, () {
          Navigator.of(context).pop();
        });
      } else {
        Values.showMsgDialog("Invalid passwords",
            "Plz create a password as per our password policy", context, () {
          Navigator.of(context).pop();
        });
      }
    }
  }
}
