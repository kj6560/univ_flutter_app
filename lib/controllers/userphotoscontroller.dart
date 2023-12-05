import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/UserFile.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

class UserPhotosController extends GetxController {
  var userFiles = List<UserFile>.empty().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUserPhotos();
  }

  void fetchUserPhotos() async {
    final prefs = await SharedPreferences
        .getInstance();
    int? id = await prefs.getInt("id");
    var all_photos = await RemoteServices.fetchUserFiles(id, 1);
    if (all_photos != null) {
      userFiles.value = all_photos;
      userFiles.value = all_photos;
      for(var files in userFiles.value){
        Values.cacheFile(Values.userGallery +
            files.filePath);
      }
    }
  }
}
