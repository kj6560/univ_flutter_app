import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/esportscontroller.dart';

import '../../controllers/esportscategorycontroller.dart';
import '../../utility/values.dart';

class Esports extends StatefulWidget {
  final String profilePicture;
  final String user_name;

  Esports({super.key, required this.profilePicture, required this.user_name});

  @override
  State<Esports> createState() => _EsportsState();
}

class _EsportsState extends State<Esports> {
  final EsportsController controller = Get.put(EsportsController());
  final EsportsCategoryController categoryController =
      Get.put(EsportsCategoryController());
  TextEditingController searchController = TextEditingController();
  var tabColor = Values.primaryColor;
  var tabColorIndex = 0;
  var selectedCategory = 0;
  late final SharedPreferences prefs;

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (categoryController.categories.length > 0) {
      setState(() {
        selectedCategory = categoryController.categories[0].id;
      });
    }
    return Obx(() => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      obscureText: false,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          disabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                              color: Colors.white38,
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                              color: Colors.white38,
                              width: 1,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                              color: Colors.white38,
                              width: 1,
                            ),
                          ),
                          hintText: "Enter Event Name",
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: false,
                          labelText: "Event Name",
                          contentPadding: const EdgeInsets.all(0),
                          prefixIcon: const Icon(FontAwesomeIcons.searchengin)),
                      onChanged: (value) {
                        if (value.length > 2) {
                          prefs.setString("esports_filter_name", value);
                          controller.applyFilters();
                        } else {
                          prefs.setString("esports_filter_name", "");
                          controller.applyFilters();
                        }
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.offAllNamed("/user_profile");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 25,
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      backgroundImage: CachedNetworkImageProvider(
                        '${Values.profilePic}${widget.profilePicture}',
                      ),
                    ),
                  ),
                )
              ],
            )),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  height: 50.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryController.categories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            tabColor = Values.primaryColor;
                            tabColorIndex = index;
                            selectedCategory =
                                categoryController.categories[index].id;
                            prefs.setInt("esports_filter_category_id",
                                categoryController.categories[index].id);
                          });
                          controller.applyFilters();
                        },
                        child: Card(
                          color:
                              tabColorIndex == index ? tabColor : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  categoryController.categories[index].name,
                                  style: const TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 2.0, 10.0, 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Esports Events",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showFilterModal(context);
                        },
                        icon: const Icon(
                          Icons.filter_list_rounded,
                          size: 20,
                        ),
                        // Icon you want to display
                        label: const Text(
                          'Filter',
                          style: TextStyle(fontSize: 18),
                        ), // Text you want to display alongside the icon
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext ctxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed("/esports_event_details", parameters: {
                          "event_id": "${controller.events[index].id}"
                        });
                      },
                      child: Container(
                        color: Colors.black12,
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          height: 300,
                                          width:
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
                                        )),
                                  ),
                                  Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Values.primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              DateFormat('d MMM y').format(
                                                  controller
                                                      .events[index].eventDate),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Expanded(
                                    child: Text(
                                      controller.events[index].eventName,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Event Location",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      // or set a specific width
                                      child: Text(
                                        controller.events[index].eventLocation,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: controller.events.length,
              ),
            )
          ],
        ));
  }

  void showFilterModal(BuildContext context) {
    if(prefs.getInt(
        "esports_filter_registration_available") == null){
      prefs.setInt(
          "esports_filter_registration_available", 0);
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return FractionallySizedBox(
          heightFactor: 0.3,
          child: Column(children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: const SizedBox(
                        height: 5,
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text("Filters: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: InkWell(
                    onTap: () {
                      controller.resetFilters();
                    },
                    child: Text("Reset All Filters",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        var reg_available_filter =
                            prefs.getInt("esports_filter_registration_available");
                        if (reg_available_filter == 0) {
                          prefs.setInt(
                              "esports_filter_registration_available", 1);
                        } else {
                          prefs.setInt(
                              "esports_filter_registration_available", 0);
                        }
                        controller.applyFilters();
                      },
                      child: Text(
                        "Registration Availability",
                        style: TextStyle(fontSize: 16),
                      )),
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}
