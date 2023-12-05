import 'package:get/get.dart';

import 'package:univ_app/models/sliders.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../utility/values.dart';

class SliderController extends GetxController {
  var sliders = List<Sliders>.empty().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchSliders();
  }

  void fetchSliders() async {
    var all_sliders = await RemoteServices.fetchSliders();
    if (all_sliders != null) {
      for (var slider in all_sliders) {
        Values.cacheFile('${Values.sliderImageUrl}/${slider.image}');
        sliders.add(Sliders(image: '${Values.sliderImageUrl}/${slider.image}'));
      }
      sliders.value = all_sliders;
    }
  }
}
