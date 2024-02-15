import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/UserFile.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserCertificatesController extends GetxController {
  var userFiles = List<UserFile>.empty().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUserPhotos();
  }

  void fetchUserPhotos() async {
    User? data = Get.arguments;
    int? id = 0;
    if (data != null) {
      id = data.id;
    } else {
      final prefs = await SharedPreferences.getInstance();
      id = await prefs.getInt("id");
    }
    var all_photos = await RemoteServices.fetchUserFiles(id, 3);
    if (all_photos != null) {
      userFiles.value = all_photos;
      for (var files in userFiles.value) {
        Values.cacheFile(Values.userGallery + files.filePath);
      }
    }
  }

  uploadCertificate(String type, XFile? imageFile) async {
    var uploaded = await RemoteServices.uploadCertificate(type, imageFile);
  }

  void showMessage(bool status, BuildContext context) {
    if (status) {
      Values.showMsgDialog(
          "Certificates", "Your certificate has been uploaded", context, () {
        Navigator.of(context).pop();
      });
    } else {
      Values.showMsgDialog("Certificates", "Certificate upload failed", context,
          () {
        Navigator.of(context).pop();
      });
    }
  }

  void archiveUserFile(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var user_id = await prefs.getInt("id");
    var archived = await RemoteServices.archiveUserFile(id, user_id!);
    if (archived) {
      userFiles.remove(userFiles.singleWhere((element) => element.id == id));
      userFiles.refresh();
    }
  }
}
