

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:univ_app/models/esports.dart';
import 'package:univ_app/services/remote_services.dart';

import '../models/event.dart';
import '../utility/DBHelper.dart';
import '../utility/values.dart';

class EsportsController extends GetxController {

  var header_text = "".obs;
  var images = List<String>.empty().obs;

  var events = List<Event>.empty().obs;
  List<Event> eventList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchEsportsEvents();
    fetchEsportsData();
  }

  void fetchEsportsData() async {
      var response = await RemoteServices.fetchEsportsData();
      if(response != null){
        var esportsData = jsonDecode(response);
        Esports esports = Esports(id: esportsData['id'], headerText: esportsData['header_text'], images: esportsData['images'], status: esportsData['status'], createdAt: DateTime.parse(esportsData['created_at']), updatedAt: DateTime.parse(esportsData['updated_at']));
        header_text.value = esports.headerText;
        var _images = esports.images;
        images.value = _images.split(",");
      }
  }

  void fetchEsportsEvents() async {
    List<Event>? all_events = [];
    try {
      all_events = await RemoteServices.fetchEsportsEvents();
      events.value = all_events!;
      eventList = events.value;
    } catch (e) {
      print(e);
    }
  }

  void filterEvents(String query) {
    events.value = eventList
        .where((element) =>
        element.eventName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    print(events.length);
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
