import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/models/event.dart';
import 'package:univ_app/models/sliders.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/DBHelper.dart';
import 'package:univ_app/utility/values.dart';

class HomeController extends GetxController {
  var sliders = List<Sliders>.empty().obs;
  var categories = List<Category>.empty().obs;
  var events = List<Event>.empty().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    fetchSliders();
    fetchCategory();
    //fetchEvents();
  }

  void fetchSliders() async {
    var all_sliders = await RemoteServices.fetchSliders();
    if (all_sliders != null) {
      sliders.assignAll(all_sliders);
      update();
    }
  }

  void fetchCategory() async {
    var all_categories = await RemoteServices.fetchCategories();
    if (all_categories != null) {
      categories.assignAll(all_categories);
      print(categories.length);
      update();
    }
  }

  void fetchEvents() async {
    var all_events = await RemoteServices.fetchEvents();
    if (all_events != null) {
      events.assignAll(all_events);
    }
  }

  void filterEvents(String query) {
    if (query.length > 3) {
      events.assignAll(events.where((item) =>
          item.eventName!.toLowerCase().contains(query.toLowerCase())));
    } else {
      events.assignAll(events);
    }
    update();
  }
}
