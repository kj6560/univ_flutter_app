import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:univ_app/controllers/categorycontroller.dart';
import 'package:univ_app/controllers/esportscontroller.dart';
import 'package:univ_app/controllers/homcontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatelessWidget {
  final String profilePicture;
  final double temp;
  final String city;
  final String user_name;

  Home(
      {super.key,
      required this.profilePicture,
      required this.temp,
      required this.city,
      required this.user_name});

  SliderController sliderController = Get.put(SliderController());
  EventController eventController = Get.put(EventController());
  EsportsController esportsController = Get.put(EsportsController());
  CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    Values.cacheFile('${Values.categoryIconUrl}1707303677_1705052653_esports.png');
    Values.cacheFile('${Values.categoryIconUrl}1704826939_football-16.png');
    return Obx(() => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed("/user_profile");
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  backgroundImage: CachedNetworkImageProvider(
                                    '${Values.profilePic}$profilePicture',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications,
                                  color: Values.primaryColor,
                                ),
                                onPressed: () {},
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Hi ${user_name}',
                                style: const TextStyle(fontSize: 22),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      "Its currently ${temp != 0.0 ? temp : 'NA'} °C in ${city != '' ? city : 'Your City'}")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CarouselSlider(
                items: sliderController.sliders.map((slider) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          // Optional: add border radius
                          child: CachedNetworkImage(
                            height: 260,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                            imageUrl:
                                '${Values.sliderImageUrl}/${slider.image}',
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enlargeFactor: 0.1,
                  viewportFraction: 1.0,
                  height: 260,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Values.primaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "CATEGORIES",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed("/all_events");
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Values.primaryColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                            height: 200,
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          height: 150,
                                          fit: BoxFit.fill,
                                          imageUrl:
                                          '${Values.categoryIconUrl}1704826939_football-16.png',
                                          placeholder: (context, url) =>
                                          const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3.0,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            "SPORTS",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed("/esports");
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Values.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            height: 200,
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          height: 150,
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              '${Values.categoryIconUrl}1707303677_1705052653_esports.png',
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3.0,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            "ESPORTS",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Values.primaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "SPORTS EVENTS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed("/all_events");
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext ctxt, int index) {
                  if (index <= 1)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            eventController.events[index].eventName
                                .toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(
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
                                                child: const Row(
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
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    );
                  else if (index == 2)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed("/all_events");
                          },
                          child: const Text("All Events")),
                    );
                  else
                    return const SizedBox(
                      height: 1,
                    );
                },
                childCount: eventController.events.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Values.primaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "ESPORTS EVENTS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed("/esports");
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext ctxt, int index) {
                  if (index <= 1)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            esportsController.events[index].eventName
                                .toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                "/esports_event_details",
                                parameters: {
                                  "event_id":
                                      "${esportsController.events[index].id}"
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
                                        '${Values.eventImageUrl}/${esportsController.events[index].eventImage}',
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
                                                esportsController
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
                                            "${esportsController.events[index].eventBio != null && esportsController.events[index].eventBio.length > 30 ? esportsController.events[index].eventBio.substring(0, 120) : ""}...",
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
                                                      esportsController
                                                          .events[index].id,
                                                      context);
                                                },
                                                child: const Row(
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
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    );
                  else
                    return const SizedBox(
                      height: 1,
                    );
                },
                childCount: esportsController.events.length,
              ),
            )
          ],
        ));
  }

  void registerForEvent(var event_id, var context) async {
    var msg = await eventController.registerForEvent(event_id);
    eventController.showDialogToUser(msg, context);
  }
}
