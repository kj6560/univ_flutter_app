import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/eventgallerycontroller.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';

class EventGallery extends StatefulWidget {
  @override
  State<EventGallery> createState() => _EventGalleryState();
}

class _EventGalleryState extends State<EventGallery>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Tab 1'),
    Tab(text: 'Tab 2'),
    Tab(text: 'Tab 3'),
  ];
  EventGalleryController eventGalleryController =
      Get.put(EventGalleryController());

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
    RemoteServices.showSnackBar(context);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<EventGalleryController>(builder: (logic) {
      return CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                    imageUrl: Values.eventImageUrl + logic.eventImage.string,
                    // URL of the image
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 3.0),
                    ),
                    // Placeholder widget
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error), // Error widget
                  )),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Expanded(
                child: Container(
                  color: Colors.grey,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(logic.eventName.string),
                        IconButton(onPressed: () {}, icon: Icon(Icons.share))
                      ]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        logic.eventDate.string,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(logic.eventLocation.string,
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                color: Colors.grey,
                height: 60,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Gallery",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      color: Colors.red,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: EdgeInsets.all(1),
                              content: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 400, maxHeight: 400),
                                child: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  // Adjust the fit based on your requirement
                                  imageUrl: Values.eventGallery +
                                      logic.event_files_list[index].image,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            context: context,
                          );
                        },
                        child: CachedNetworkImage(
                          height: 150,
                          fit: BoxFit.cover,
                          imageUrl: Values.eventGallery +
                              logic.event_files_list[index].image,
                          // URL of the image
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 3.0),
                          ),
                          // Placeholder widget
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error), // Error widget
                        ),
                      ),
                    ));
              },
              childCount: logic.event_files_list.length,
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 8.0),
          )
        ],
      );
    });
  }
}
