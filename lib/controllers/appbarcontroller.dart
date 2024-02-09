

import 'package:get/get.dart';

class AppbarController extends GetxController {
  String topQuote = "A great day to run";
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchTopQuote();
  }

  void fetchTopQuote() async {

  }
}
