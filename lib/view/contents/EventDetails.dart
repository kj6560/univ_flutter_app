import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_app/controllers/eventdetailscontroller.dart';
import 'package:get/get.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EventDetails extends StatefulWidget {
  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  EventDetailsController eventDetailsController =
      Get.put(EventDetailsController());
  String? event_id = "";
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      event_id = Get.parameters['event_id'];
    });
    RemoteServices.showSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          GetBuilder<EventDetailsController>(
            assignId: true,
            builder: (logic) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        imageUrl: Values.eventImageUrl + logic.eventImage,
                        // URL of the image
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 3.0),
                        ),
                        // Placeholder widget
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error), // Error widget
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(logic.eventName)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Center(
                            child: Text(logic.eventDate,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(logic.eventLocation,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(logic.eventBio),
                  )
                ],
              );
            },
          ),
          GetBuilder<EventDetailsController>(
            assignId: true,
            builder: (logic) {
              return Container(
                color: Colors.green,
                child: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: logic.eventLiveLink,
                      // Replace with your video ID
                      flags: const YoutubePlayerFlags(
                        autoPlay: true,
                        mute: false,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.green),
              );
            },
          ),
          GetX<EventDetailsController>(
            builder: (logic) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      "Our Honurable Partners",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                  ),
                  CarouselSlider(
                      items: logic.event_partners_list.map((partner) {
                        return Builder(
                          builder: (BuildContext context) {
                            return CachedNetworkImage(
                              height: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                              imageUrl:
                                  '${Values.eventPartnerPic}/${partner.partnerLogo}',
                              // URL of the image
                              placeholder: (context, url) => const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 3.0),
                              ),
                              // Placeholder widget
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error), // Error widget
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 100,
                        aspectRatio: 1.0,
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
                        enlargeFactor: 0.0,
                        scrollDirection: Axis.horizontal,
                      )),
                ],
              );
            },
          ),
          Column(
            children: [
              // Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Align buttons at the ends
                children: [
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator() // Show progress indicator when loading
                        : ElevatedButton(
                            onPressed: () {
                              registerForEvent();
                            },
                            child: const Text('Register'),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.offNamed("/event_gallery",
                          parameters: {"event_id": event_id!});
                    },
                    child: const Text('Gallery'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Future<int?> getEventId() async {
    final prefs = await SharedPreferences.getInstance();
    int? _event_id = prefs.getInt("event_id");
    if (_event_id != 0) {
      return _event_id;
    }
  }

  void registerForEvent() async {
    setState(() {
      _isLoading = true;
    });
    var msg = await eventDetailsController.registerForEvent(event_id);
    _isLoading = eventDetailsController.showDialogToUser(msg, context);
    setState(() {
      _isLoading = false;
    });
  }
}
