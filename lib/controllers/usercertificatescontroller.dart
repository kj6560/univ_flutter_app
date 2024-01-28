import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/UserFile.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

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
    if(data != null){
      id = data.id;
    }else{
      final prefs = await SharedPreferences
          .getInstance();
      id = await prefs.getInt("id");
    }
    var all_photos = await RemoteServices.fetchUserFiles(id, 3);
    if (all_photos != null) {
      userFiles.value = all_photos;
      for(var files in userFiles.value){
        Values.cacheFile(Values.userGallery +
            files.filePath);
      }
    }
  }
}
