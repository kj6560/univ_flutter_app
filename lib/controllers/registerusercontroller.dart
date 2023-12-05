import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/services/remote_services.dart';

class RegisterUserController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void registerUser(var firstName,var lastName, var email,var phoneNumber,var password,var context)async{
    bool? registered = await RemoteServices.registerUser(firstName, lastName, email, phoneNumber, password);
    if(registered! && registered){
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration'),
            content: const Text("User Registration successful. Please proceed to login"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.offNamed("/login"); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
