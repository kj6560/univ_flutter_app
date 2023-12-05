

import 'package:get/get.dart';

class LocationController extends GetxController {
  RxString address = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchLocation();
  }

  void fetchLocation() async {

  }
}
