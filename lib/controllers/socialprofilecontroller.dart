
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/services/remote_services.dart';

class SocialProfileController extends GetxController {
  var profilePic = "";
  var profileName = "";
  var about = "";
  var loggedout = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProfile();
  }

  void fetchProfile()async{
    final prefs = await SharedPreferences
        .getInstance();
    int? id =  prefs.getInt("id");
    profilePic = ( prefs.getString('image'))!;
    profileName = ( prefs.getString("first_name"))! + " " + ( prefs.getString("last_name"))!;
    about = (prefs.getString("about"))!;
    update();
  }
  void logout()async{
    final prefs = await SharedPreferences.getInstance();
    int? id = await prefs.getInt("id");
    if (id != 0) {
      prefs.setString("token", "");
      prefs.setInt("id", 0);
      prefs.setString("email", "");
      prefs.setString("first_name", "");
      prefs.setString("last_name", "");
      prefs.setString("image", "");
      prefs.setString("about", "");
      prefs.setString("number", "");
      prefs.setInt("user_role", 0);
      prefs.setInt("gender", 0);
      prefs.setInt("married", 0);
      prefs.setString("height", "");
      prefs.setString("weight", "");
      prefs.setString("age", "");
      prefs.setString("user_doc", "");
      prefs.setString("birthday", "");
      prefs.setString("address_line1", "");
      prefs.setString("city", "");
      prefs.setString("state", "");
      prefs.setString("pincode", "");
      await prefs.clear();
      RemoteServices.logoutUser(id);
      Get.offAllNamed("/login");
    }

  }

}
