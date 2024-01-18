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

class EventDetailsController extends GetxController {
  int eventId = 0;
  String eventName = "";
  String eventImage = "";
  String eventDate = "";
  String eventLocation = "";
  String eventBio = "";
  String eventLiveLink = "";
  var event_partners_list = List<EventPartner>.empty().obs;
  var event_files_list = List<EventFile>.empty().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchEventPartners();
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
    eventName = eventDetail.eventName;
    eventImage = eventDetail.eventImage;
    eventDate = DateFormat('d MMM y').format(eventDetail.eventDate);
    eventLocation = eventDetail.eventLocation;
    eventBio = eventDetail.eventBio;
    eventId = eventDetail.id;
    eventLiveLink = eventDetail.eventLiveLink;
    update();
  }

  void fetchEventPartners() async {
    final conn = DBHelper.instance;
    var dbclient = await conn.db;
    List<EventPartner> event_partners = [];
    String? event_id = Get.parameters['event_id'];
    var db_data = await dbclient!
        .rawQuery('SELECT * FROM event_partners where event_id=${event_id!}');

    if (await RemoteServices.hasInternet()) {
      event_partners = await RemoteServices.fetchEventPartners(event_id);
      event_partners_list.value = event_partners;
      if (event_partners != null &&
          db_data.length != event_partners.length) {
        for (var event_partner in event_partners_list.value) {
          Values.cacheFile(
              "${Values.eventPartnerPic}/${event_partner.partnerLogo}");
          await dbclient!.insert('event_partners', event_partner.toJson());
        }
      }
    } else {
      for (var row in db_data) {
        event_partners.add(EventPartner.fromMap(row));
      }
      event_partners_list.value = event_partners;
    }

  }

  void fetchEventFiles() async {
    String? event_id = Get.parameters['event_id'];
    var event_files = await RemoteServices.fetchEventFiles(event_id);
    if (event_files != null) {
      event_files_list.value = event_files;
      for (var files_list in event_files_list.value) {
        Values.cacheFile(Values.eventGallery + files_list.image);
      }
    }
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
