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
  late final SharedPreferences prefs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initPrefs();
    fetchEsportsEvents();
    fetchEsportsData();
  }

  void fetchEsportsData() async {
    var response = await RemoteServices.fetchEsportsData();
    if (response != null) {
      var esportsData = jsonDecode(response);
      Esports esports = Esports(
          id: esportsData['id'],
          headerText: esportsData['header_text'],
          images: esportsData['images'],
          status: esportsData['status'],
          createdAt: DateTime.parse(esportsData['created_at']),
          updatedAt: DateTime.parse(esportsData['updated_at']));
      header_text.value = esports.headerText;
      var _images = esports.images;
      images.value = _images.split(",");
    }
  }

  void fetchEsportsEvents() async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    List<Event>? all_events = [];
    try {
      var total_count = await Sqflite.firstIntValue(await dbclient!
          .rawQuery('SELECT COUNT(*) FROM events where events.parent_id=33'));
      var hasInternet = await RemoteServices.hasInternet();
      if (hasInternet) {
        all_events = await RemoteServices.fetchEsportsEvents();
        if (all_events != null && total_count != all_events.length) {
          for (var event in all_events) {
            Values.cacheFile("${Values.eventImageUrl}/${event.eventImage}");
            var isInDb = await Sqflite.firstIntValue(await dbclient!.rawQuery(
                'SELECT COUNT(*) FROM events where events.id=${event.id}'));
            if (isInDb == 0) {
              await dbclient!.insert('events', event.toJson());
            }
          }
          eventList = all_events;
        }
      } else {
        List<Map<String, dynamic>> maps = await dbclient!
            .rawQuery('SELECT * FROM events where events.parent_id=33');
        maps.forEach((element) {
          Event ev = Event.fromMap(element);
          all_events?.add(ev);
        });
        eventList = all_events!;
      }
      events.value = all_events!;
      eventList = events.value;
    } catch (e) {
      print(e);
    }
  }



  void applyFilters() {
    var filter_name = prefs.getString("esports_filter_name");
    var filter_category = prefs.getInt("esports_filter_category_id");
    var filter_registration_available = prefs.getInt("esports_filter_registration_available");
    print(filter_registration_available ==0 ?"reg_available_is_zero":"reg_available_is_one");
    if(filter_name!.length >2){
      events.value = eventList
          .where((element) =>
          element.eventName!.toLowerCase().contains(filter_name.toLowerCase()))
          .toList();
    }
    if (filter_category != 0) {
      events.value = eventList
          .where((element) => element.eventCategory == filter_category)
          .toList();
    }

    if(filter_registration_available == 1){
      events.value = eventList
          .where((element) => element.eventRegistrationAvailable == 1)
          .toList();
    }
  }

  void resetFilters() {
    prefs.setString("esports_filter_name","");
    prefs.setInt("esports_filter_category_id",0);
    prefs.setInt("esports_filter_registration_available",0);
    events.value = eventList;
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

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}
