import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

class RegisterUserController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<String> registerUser(var firstName, var lastName, var email, var phoneNumber,
      var password, var context) async {
    if (!Values.isValidEmail(email)) {
      return "Invalid email provided";
    }
    if (firstName.isEmpty || lastName.isEmpty) {
      return "Invalid first name or last name";
    }
    if (phoneNumber.isEmpty || !Values.isValidPhoneNumber(phoneNumber)) {
      return "Invalid phone number";
    }

    String? registered = await RemoteServices.registerUser(
        firstName, lastName, email, phoneNumber, password);
    if (registered !=null) {
      try {
        return registered;
      } catch (e, s) {
        return e.toString();
      }
    }else{
      return "A user with email: $email already exists!! Please login to continue.";
    }
    return "";
  }

  Future showErrorDialog(String msg, var context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
