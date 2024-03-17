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

class _EsportsEventDetailsState extends State<EsportsEventDetails> {
  final EsportsEventDetailsController controller =
      Get.put(EsportsEventDetailsController());

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
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
