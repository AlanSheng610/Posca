import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/controllers/auth_controller.dart';
import 'package:posca/controllers/postcard_controller.dart';
import 'package:posca/screens/postcard/postcard_page.dart';

/// Swipeable full-screen view of newly received postcards.
class InboxTab extends StatefulWidget {
  const InboxTab({super.key});

  @override
  State<InboxTab> createState() => _InboxTabState();
}

class _InboxTabState extends State<InboxTab> {
  final PostcardController _postcards = Get.find();

  @override
  void initState() {
    super.initState();
    _postcards.refreshInbox(Get.find<AuthController>().user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Obx(() {
      if (_postcards.inbox.isEmpty) {
        return const Center(
          child: Text(
            'No new postcards yet',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      return CarouselSlider(
        items: [
          for (final card in _postcards.inbox) PostcardPage(postcard: card),
        ],
        options: CarouselOptions(
          height: height,
          viewportFraction: 1,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
        ),
      );
    });
  }
}
