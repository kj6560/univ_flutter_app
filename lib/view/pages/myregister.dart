import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/registerusercontroller.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RegisterUserController _controller = Get.put(RegisterUserController());
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            backgroundColor: const Color(0xff3a57e8),
            body: Align(
              alignment: Alignment.center,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          "Sign Up",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 24,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: firstNameController,
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
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            hintText: "First Name",
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            filled: true,
                            fillColor: const Color(0xfff2f2f3),
                            isDense: false,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            prefixIcon: const Icon(Icons.person,
                                color: Color(0xff3a57e8), size: 24),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: lastNameController,
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
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            hintText: "Last Name",
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            filled: true,
                            fillColor: const Color(0xfff2f2f3),
                            isDense: false,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            prefixIcon: const Icon(Icons.person,
                                color: Color(0xff3a57e8), size: 24),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: emailController,
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
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            hintText: "Email",
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            filled: true,
                            fillColor: const Color(0xfff2f2f3),
                            isDense: false,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            prefixIcon: const Icon(Icons.mail,
                                color: Color(0xff3a57e8), size: 24),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: numberController,
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
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            hintText: "Phone Number",
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            filled: true,
                            fillColor: const Color(0xfff2f2f3),
                            isDense: false,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            prefixIcon: const Icon(Icons.contact_phone,
                                color: Color(0xff3a57e8), size: 24),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
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
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00ffffff), width: 1),
                            ),
                            hintText: "Password",
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            filled: true,
                            fillColor: const Color(0xfff2f2f3),
                            isDense: false,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            prefixIcon: const Icon(Icons.lock,
                                color: Color(0xff3a57e8), size: 24),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            _controller.registerUser(
                                firstNameController.text.toString(),
                                lastNameController.text.toString(),
                                emailController.text.toString(),
                                numberController.text.toString(),
                                passwordController.text.toString(),
                                context);
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          color: const Color(0xffffd261),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          textColor: const Color(0xff4d4d4d),
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Already have an account?",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xffe2dcdc),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: InkWell(
                                onTap: () {
                                  Get.offAllNamed("/login");
                                },
                                child: const Text(
                                  "SignIn",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color(0xffffffff),
                                  ),
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
          );
  }
}
