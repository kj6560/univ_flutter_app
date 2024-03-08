import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:univ_app/controllers/eventcontroller.dart';

import '../../utility/values.dart';

class EventsList extends StatelessWidget {
  EventsList({super.key});

  EventController eventController = Get.put(EventController());
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: editingController,
              decoration: const InputDecoration(
                labelText: "Events",
                hintText: "Search Events",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              onChanged: (value) {
                  eventController
                      .filterEvents(editingController.text.toString());
              },
            ),
          ),
        ),
        Obx(() => SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext ctxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          eventController.events[index].eventName.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        InkWell(
                          onTap: () {
                            Get.offAllNamed(
                              "/event_details",
                              parameters: {
                                "event_id":
                                    "${eventController.events[index].id}"
                              },
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 4,
                                child: CachedNetworkImage(
                                  height: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      '${Values.eventImageUrl}/${eventController.events[index].eventImage}',
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          DateFormat('d MMM y').format(
                                              eventController
                                                  .events[index].eventDate),
                                          style: const TextStyle(
                                            color: Values.primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          "${eventController.events[index].eventBio != null && eventController.events[index].eventBio.length > 30 ? eventController.events[index].eventBio.substring(0, 120) : ""}...",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 130,
                                          right: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                registerForEvent(
                                                    eventController
                                                        .events[index].id,
                                                    context);
                                              },
                                              child: Row(
                                                children: [
                                                  Text('Register'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  );
                },
                childCount: eventController.events.length,
              ),
            ))
      ],
    );
  }

  void registerForEvent(var event_id, var context) async {
    var msg = await eventController.registerForEvent(event_id);
    eventController.showDialogToUser(msg, context);
  }
}
