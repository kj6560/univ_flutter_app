import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:univ_app/models/EventFile.dart';
import 'package:univ_app/models/EventPartner.dart';
import 'package:univ_app/models/event.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/DBHelper.dart';
import 'package:univ_app/utility/values.dart';

class EventGalleryController extends GetxController {
  RxInt eventId = 0.obs;
  RxString eventName = "".obs;
  RxString eventImage = "".obs;
  RxString eventDate = "".obs;
  RxString eventLocation = "".obs;
  RxString eventBio = "".obs;
  var event_files_list = List<EventFile>.empty().obs;
  var event_partners_list = List<EventPartner>.empty().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchEvent();
    fetchEventFiles();
  }

  void fetchEvent() async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    String? event_id = Get.parameters['event_id'];
    Event eventDetail;
    var db_data =
    await dbclient!.rawQuery('SELECT * FROM events where id=${event_id!}');
    var ev_data = db_data.first;
    eventDetail = Event.fromMap(ev_data);
    eventName.value = eventDetail.eventName;
    eventImage.value = eventDetail.eventImage;
    eventDate.value = DateFormat('d MMM y').format(eventDetail.eventDate);
    eventLocation.value = eventDetail.eventLocation;
    eventBio.value = eventDetail.eventBio;
    eventId.value = eventDetail.id;
  }

  void fetchEventFiles() async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    String? event_id = Get.parameters['event_id'];
    List<EventFile> event_files = [];
    try {
      var total_count = await Sqflite.firstIntValue(
          await dbclient!.rawQuery('SELECT COUNT(*) FROM event_gallery'));

      var hasInternet = await RemoteServices.hasInternet();
      if (hasInternet) {

        event_files = await RemoteServices.fetchEventFiles(event_id);

        if (event_files != null && total_count != event_files.length) {

          for (var files_list in event_files) {
            Values.cacheFile(Values.eventGallery + files_list.image);
            await dbclient!.insert('event_gallery', files_list.toJson());
          }
        }
      }else{
        List<Map<String, dynamic>> maps = await dbclient!.query('event_gallery');
        maps.forEach((element) {
          EventFile ev = EventFile.fromMap(element);
          event_files?.add(ev);
        });
      }
      event_files_list.value = event_files;
    } catch (e) {}
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
