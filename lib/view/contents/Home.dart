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
        : CustomScrollView(
            slivers: <Widget>[
              //sliders
              GetX<SliderController>(
                builder: (controller) {
                  return SliverToBoxAdapter(
                    child: CarouselSlider(
                      items: controller.sliders.map((slider) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  height: MediaQuery.of(context).size.width,
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
                      ),
                    ),
                  );
                },
              ),

              //event search
              SliverPadding(
                padding: EdgeInsets.all(8.0),
                sliver: SliverToBoxAdapter(
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
              SliverPadding(
                padding: EdgeInsets.all(8.0),
                sliver: SliverToBoxAdapter(
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.grey,
                            ),
                            child: DropdownButton<Category>(
                              items: categoryController.categories
                                  .map(
                                    (value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (selectdCategories) {
                                setState(() {
                                  selectedCategory = selectdCategories;
                                });
                                eventController.filterEventsByCategory(
                                  selectdCategories!.id.toString(),
                                );
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
              ),
              GetX<EventController>(
                builder: (controller) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                controller.events[index].eventName.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.offAllNamed(
                                    "/event_details",
                                    parameters: {
                                      "event_id":
                                          "${controller.events[index].id}"
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 120,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            '${Values.eventImageUrl}/${controller.events[index].eventImage}',
                                        placeholder: (context, url) =>
                                            const Center(
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
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                DateFormat('d MMM y').format(controller.events[index].eventDate),
                                                style: const TextStyle(
                                                  color: Values.primaryColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                "${controller.events[index].eventBio != null && controller.events[index].eventBio.length > 30 ? controller.events[index].eventBio.substring(0, 120) : ""}...",
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
                                                        controller
                                                            .events[index].id,
                                                      );
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
                      childCount: controller.events.length,
                    ),
                  );
                },
              ),
            ],
          );
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
