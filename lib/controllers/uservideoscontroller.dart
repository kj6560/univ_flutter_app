import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/UserFile.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

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
    final prefs = await SharedPreferences.getInstance();
    int? id = await prefs.getInt("id");
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
