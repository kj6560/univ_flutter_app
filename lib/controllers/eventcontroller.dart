import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/models/event.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

class EventController extends GetxController {
  var events = List<Event>.empty().obs;
  List<Event> eventList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchEvents();
  }

  void fetchEvents() async {
    var all_events = await RemoteServices.fetchEvents();
    if (all_events != null) {
      events.value = all_events;
      for(var event in events.value){
        Values.cacheFile("${Values.eventImageUrl}/${event.eventImage}");
      }
      eventList = all_events;
    }
  }

  void filterEvents(String query) {
    events.value = eventList
        .where((element) =>
            element.eventName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void filterEventsByCategory(String category_id) {
    events.value = eventList
        .where((element) =>
            element.eventCategory.toString()!.contains(category_id))
        .toList();
  }

  Future<String> registerForEvent(var event_id) async {
    final prefs = await SharedPreferences.getInstance();
    String? first_name = prefs.getString("first_name");
    String? last_name = prefs.getString("last_name");
    String? phone = prefs.getString("number")!;
    String? email = prefs.getString("email")!;
    var response = await RemoteServices.registerForEvents(jsonEncode({
      'first_name': first_name,
      'last_name': last_name,
      'number': phone,
      'email': email,
      'event_id': event_id
    }));

    String msg = response['message'];
    return msg;
  }

  bool showDialogToUser(var msg, var _context) {
    bool done = false;
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Event Registration'),
          content: Text(msg!),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                done = true;
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return done;
  }
}
