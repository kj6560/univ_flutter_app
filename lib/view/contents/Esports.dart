import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:univ_app/controllers/categorycontroller.dart';
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

  @override
  Widget build(BuildContext context) {
    if (categoryController.categories.length > 0) {
      setState(() {
        selectedCategory = categoryController.categories[0].id;
      });
      print(selectedCategory);
    }
    return Obx(() => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
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
                        color: Colors.black12,
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
                            color: Colors.black12,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: false,
                          labelText: "Event Name",
                          contentPadding: const EdgeInsets.all(0),
                          prefixIcon: Icon(FontAwesomeIcons.searchengin)),
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
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                          });
                        },
                        child: Card(
                          color: tabColorIndex == index
                              ? tabColor
                              : Colors.white38,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  categoryController.categories[index].name,
                                  style: TextStyle(color: Colors.black),
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext ctxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  height: 300,
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      '${Values.eventImageUrl}/${controller.events[index].eventImage}',
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )),
                          ),

                        ],
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
}
