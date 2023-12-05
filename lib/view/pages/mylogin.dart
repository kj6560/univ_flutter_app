import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/user.dart';
import 'dart:convert';
import 'package:univ_app/utility/values.dart';
import 'package:get/get.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var _isLoading = false;

  void login(String email, String password) async {
    try {
      setState(() {
        _isLoading = true;
      });
      http.Response response =
          await http.post(Uri.parse('${Values.baseUrl}/api/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({'email': email, 'password': password}));
      if (response.statusCode == 200) {
        var responseObject = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", responseObject['token']);
        var userObj = responseObject['user'];
        prefs.setInt("id", userObj['id']);

        prefs.setBool("show_welcome", false);
        prefs.setString("email", userObj['email']);
        prefs.setString("first_name", userObj['first_name']);
        prefs.setString("last_name", userObj['last_name']);
        prefs.setString("image", userObj['image'] ?? "");
        prefs.setString("about", userObj['about'] ?? "Update Your Profile");
        prefs.setString("number", userObj['number'] ?? "");
        prefs.setInt("user_role", userObj['user_role'] ?? "");
        prefs.setInt("gender", userObj['gender'] ?? 2);
        prefs.setInt("married", userObj['married'] ?? 2);
        prefs.setString("height", userObj['height'] ?? "");
        prefs.setString("weight", userObj['weight'] ?? "");
        prefs.setString("age", userObj['age'] ?? "");
        prefs.setString("user_doc", userObj['user_doc'] ?? "");
        prefs.setString("birthday", userObj['birthday'] ?? "");
        prefs.setString("address_line1", userObj['address_line1'] ?? "");
        prefs.setString("city", userObj['city'] ?? "");
        prefs.setString("state", userObj['state'] ?? "");
        prefs.setString("pincode", userObj['pincode'] ?? "");
        var _token = prefs.getString("token");
        setState(() {
          _isLoading = false;
        });
        if (_token != null) {
          Get.offNamed("/home");
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }

  void signup() {
    Navigator.of(context).pushNamed('register');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
            backgroundColor: const Color(0xffe6e6e6),
            body: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  height:
                      MediaQuery.of(context).size.height * 0.35000000000000003,
                  decoration: BoxDecoration(
                    color: const Color(0xff3a57e8),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.zero,
                    border:
                        Border.all(color: const Color(0x4d9e9e9e), width: 1),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  padding: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    border:
                        Border.all(color: const Color(0x4d9e9e9e), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const CircleAvatar(
                            radius: 60,
                            child: Image(
                              image: AssetImage('assets/logo_white.png'),
                              height: 100,
                              width: 100,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Login",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 22,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            child: TextField(
                              controller: emailController,
                              obscureText: false,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xff000000), width: 1),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xff000000), width: 1),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xff000000), width: 1),
                                ),
                                hintText: "Enter Email",
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff494646),
                                ),
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                isDense: false,
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ),
                          ),
                          TextField(
                            controller: passwordController,
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
                              disabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color(0xff000000), width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color(0xff000000), width: 1),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color(0xff000000), width: 1),
                              ),
                              hintText: "Enter Password",
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff494646),
                              ),
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              isDense: false,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 30),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Get.offNamed("/forgot_password");
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color(0xff3a57e8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              login(emailController.text.toString(),
                                  passwordController.text.toString());
                            },
                            color: const Color(0xff3a57e8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            padding: const EdgeInsets.all(16),
                            textColor: const Color(0xffffffff),
                            height: 40,
                            minWidth: MediaQuery.of(context).size.width,
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: Text(
                                    "Don't have an account?",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.offAllNamed("/register");
                                  },
                                  child: const Text(
                                    "SignUp",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
