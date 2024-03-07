import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:univ_app/controllers/categorycontroller.dart';
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

  Home({super.key, required this.profilePicture});

  SliderController sliderController = Get.put(SliderController());
  EventController eventController = Get.put(EventController());
  CategoryController categoryController = Get.put(CategoryController());
  PageController _pageController = PageController();

  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 45,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 180,
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
                                  Get.offAllNamed("/user_profile");
                                },
                                child: CircleAvatar(
                                  radius: 35,
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
                          const Row(
                            children: [
                              Expanded(
                                  child: Text(
                                "Hi Keshav Jha!",
                                style: TextStyle(fontSize: 22),
                              )),
                            ],
                          ),
                          const Row(
                            children: [
                              Expanded(
                                  child:
                                      Text("Its currently 10.4 °C in Delhi")),
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
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            // Optional: add border radius
                            child: CachedNetworkImage(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
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
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 1.0,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text("${categoryController.categories[index].name}")),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "Our Events",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            ),
            SliverList(

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
                                "event_id": "${eventController.events[index].id}"
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
                                                    eventController.events[index].id,
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
            ),
          ],
        ));
  }

  void registerForEvent(var event_id, var context) async {
    var msg = await eventController.registerForEvent(event_id);
    eventController.showDialogToUser(msg, context);
  }
}
