import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:univ_app/controllers/esportsEventdetailscontroller.dart';
import 'package:univ_app/controllers/esportscontroller.dart';

import '../../controllers/esportscategorycontroller.dart';
import '../../utility/values.dart';

class EsportsEventDetails extends StatefulWidget {
  final String profilePicture;
  final String user_name;

  EsportsEventDetails(
      {super.key, required this.profilePicture, required this.user_name});

  @override
  State<EsportsEventDetails> createState() => _EsportsEventDetailsState();
}

class _EsportsEventDetailsState extends State<EsportsEventDetails>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;
  final EsportsEventDetailsController controller =
      Get.put(EsportsEventDetailsController());
  late TabController _tabController;
  final List<Tab> myTabs = [
    const Tab(text: 'Tab 1'),
    const Tab(text: 'Tab 2'),
    const Tab(text: 'Tab 3'),
  ];

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            children: [
              CachedNetworkImage(
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
                imageUrl: '${Values.eventImageUrl}/${controller.eventImage}',
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Positioned(
                top: 25,
                left: 8,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: IconButton(
                    onPressed: () {
                      Get.offNamed("/esports");
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.eventName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Event Date",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(controller.eventDate,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Registration Status",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              controller.registrationAvailable == 1
                                  ? "Registration Open"
                                  : "Registration Closed",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14))
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: _tabSection(context),
          ),
        )
      ],
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
                labelColor: Values.primaryColor,
                indicatorColor: Values.primaryColor,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "Description",
                  ),
                  Tab(text: "Details"),
                  Tab(text: "Registration"),
                ]),
          ),
          Container(
            //Add this to give height
            height: 400,
            child: TabBarView(children: [
              Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: Text(
                      controller.eventBio,
                      style: TextStyle(color: Colors.white,fontSize: 16),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Event Location",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.eventLocation,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.black,
                child: Row(
                  children: [
                    _isLoading
                        ? const CircularProgressIndicator() // Show progress indicator when loading
                        : ElevatedButton(
                      onPressed: () {
                        registerForEvent();
                      },
                      child: const Text('Register'),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
  void registerForEvent() async {
    setState(() {
      _isLoading = true;
    });
    var msg = await controller.registerForEvent(controller.eventId);
    _isLoading = controller.showDialogToUser(msg, context);
    setState(() {
      _isLoading = false;
    });
  }
}
