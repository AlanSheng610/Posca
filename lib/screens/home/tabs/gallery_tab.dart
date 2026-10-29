import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/controllers/postcard_controller.dart';
import 'package:posca/screens/postcard/postcard_viewer_screen.dart';
import 'package:posca/widgets/network_photo.dart';

/// Grid of every postcard the user has sent or received.
class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final PostcardController postcards = Get.find();
    return ColoredBox(
      color: Colors.black87,
      child: SafeArea(
        child: Obx(() {
          final cards = postcards.history;
          if (cards.isEmpty) {
            return const Center(
              child: Text(
                'No postcards yet',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () => Get.toNamed(
                Routes.postcardViewer,
                arguments: PostcardViewerArgs(cards, index),
              ),
              child: NetworkPhoto(cards[index].thumbnailUrl),
            ),
          );
        }),
      ),
    );
  }
}
