import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/UserFile.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

import '../models/user.dart';

class UserVideosController extends GetxController {
  var userFiles = List<UserFile>.empty().obs;
  var file_path = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUserVideos();
  }

  void fetchUserVideos() async {
    User? data = Get.arguments;
    int? id = 0;
    if(data != null){
      id = data.id;
    }else{
      final prefs = await SharedPreferences
          .getInstance();
      id = await prefs.getInt("id");
    }
    var all_videos = await RemoteServices.fetchUserFiles(id, 2);
    if (all_videos != null) {
      userFiles.value = all_videos;
      userFiles.value = all_videos;
      for(var videoFiles in userFiles.value){
        Values.cacheFile(Values.userGallery +videoFiles.filePath);
      }
    }
  }


}
