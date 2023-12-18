import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:univ_app/controllers/categorycontroller.dart';
import 'package:univ_app/controllers/slidercontroller.dart';
import 'package:univ_app/models/category.dart';
import 'package:univ_app/utility/values.dart';
import 'package:univ_app/controllers/eventcontroller.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SliderController sliderController = Get.put(SliderController());
  EventController eventController = Get.put(EventController());
  CategoryController categoryController = Get.put(CategoryController());
  TextEditingController editingController = TextEditingController();
  Category? selectedCategory;
  var _isLoading = false;
  final cache = DefaultCacheManager();

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: Colors.transparent,
            child: const Center(
                child:
                    CircularProgressIndicator())) // Show progress indicator when loading
        : SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                GetX<SliderController>(builder: (controller) {
                  return CarouselSlider(
                      items: controller.sliders.map((slider) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              // child: Image.network(
                              //   '${Values.sliderImageUrl}/${slider.image}',
                              //   fit: BoxFit.fill,
                              // )
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  height: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      '${Values.sliderImageUrl}/${slider.image}',
                                  // URL of the image
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3.0),
                                  ),
                                  // Placeholder widget
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error), // Error widget
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 200,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 1000),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.2,
                        scrollDirection: Axis.horizontal,
                      ));
                }),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: editingController,
                    decoration: const InputDecoration(
                        labelText: "Events",
                        hintText: "Search Events",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)))),
                    onChanged: (value) {
                      eventController
                          .filterEvents(editingController.text.toString());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "CATEGORIES",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Obx(() {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.grey,
                            ),
                            child: DropdownButton<Category>(
                              items: categoryController.categories // <- Here
                                  .map(
                                    (value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (selectdCategories) {
                                setState(
                                  () {
                                    selectedCategory = selectdCategories;
                                  },
                                );
                                eventController.filterEventsByCategory(
                                    selectdCategories!.id.toString());
                              },
                              value: selectedCategory,
                              hint: const Text(
                                'Select Categories',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                GetX<EventController>(builder: (controller) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: controller.events.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                              onTap: () {
                                Get.offAllNamed("/event_details", parameters: {
                                  "event_id": "${controller.events[index].id}"
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                      height: 100,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            '${Values.eventImageUrl}/${controller.events[index].eventImage}',
                                        // URL of the image
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 3.0),
                                        ),
                                        // Placeholder widget
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                                Icons.error), // Error widget
                                      )),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                                "${DateFormat('d MMM y').format(controller.events[index].eventDate)}",
                                            style: TextStyle(color: Values.primaryColor,fontSize: 15,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                                "${controller.events[index].eventBio?.substring(0, 120)}..."),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 130,right: 8),
                                            child: Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    registerForEvent(controller
                                                        .events[index].id);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text('Register'),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 5.0, bottom: 5.0),
                            child: Container(
                              color: Colors.grey,
                              child: const SizedBox(
                                    height: 1,
                                  ),
                            ),
                          )),
                    ),
                  );
                }),
              ],
            ),
          ));
  }

  void registerForEvent(var event_id) async {
    setState(() {
      _isLoading = true;
    });
    var msg = await eventController.registerForEvent(event_id);
    _isLoading = eventController.showDialogToUser(msg, context);
    setState(() {
      _isLoading = false;
    });
  }
}
