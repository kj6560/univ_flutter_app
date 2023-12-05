import 'package:get/get.dart';
import 'package:univ_app/services/remote_services.dart';

class TemperatureController extends GetxController {
  String temperature = "";
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //fetchTemperature();
  }

  static void fetchTemperature(var latitude,var longitude) async {
    RemoteServices.fetchTemperature(latitude,longitude);
  }
}
