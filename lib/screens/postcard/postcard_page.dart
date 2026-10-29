import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/controllers/auth_controller.dart';
import 'package:posca/models/postcard.dart';
import 'package:posca/screens/compose/compose_args.dart';
import 'package:posca/widgets/network_photo.dart';
import 'package:posca/widgets/postcard_face.dart';

/// Full-screen postcard: the photo with its location, and the written side
/// below. Tapping the written side opens the details sheet.
class PostcardPage extends StatelessWidget {
  const PostcardPage({super.key, required this.postcard});

  final Postcard postcard;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final longName = postcard.country.length > 7 || postcard.city.length > 7;

    return Stack(
      fit: StackFit.expand,
      children: [
        NetworkPhoto(postcard.imageUrl),
        Positioned(
          top: size.height * 0.15,
          left: 30,
          right: 30,
          child: Text(
            '${postcard.country},\n${postcard.city}.',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: longName ? 40 : 60,
                  color: Colors.white,
                ),
          ),
        ),
        Positioned(
          top: size.height * 0.6,
          left: size.width * 0.1,
          child: GestureDetector(
            onTap: () => _showDetails(context),
            child: PostcardFace(
              postcard: postcard,
              width: size.width * 0.8,
              height: size.height * 0.25,
            ),
          ),
        ),
      ],
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PostcardDetailsSheet(postcard: postcard),
    );
  }
}

class _PostcardDetailsSheet extends StatelessWidget {
  const _PostcardDetailsSheet({required this.postcard});

  final Postcard postcard;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final inkColor = AppColors.onColor(Color(postcard.cardColor));
    final isMine = postcard.senderUid == Get.find<AuthController>().user.uid;

    return Container(
      height: size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            '${postcard.country}, ${postcard.city}.',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              width: size.width * 0.9,
              height: size.width * 0.6,
              child: NetworkPhoto(postcard.thumbnailUrl),
            ),
          ),
          const SizedBox(height: 20),
          PostcardFace(
            postcard: postcard,
            width: size.width * 0.9,
            height: size.width * 0.6,
            footer: Row(
              children: [
                const CircleAvatar(radius: 20, backgroundColor: Colors.white),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postcard.senderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: inkColor,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMd().add_jm().format(postcard.createdAt),
                      style: TextStyle(fontSize: 12, color: inkColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (!isMine)
            OutlinedButton.icon(
              icon: const Icon(Icons.edit, color: Colors.black),
              label: const Text(
                'Reply',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                side: const BorderSide(width: 2, color: Colors.grey),
              ),
              onPressed: () => Get.toNamed(
                Routes.camera,
                arguments: ComposeArgs(
                  type: PostcardType.reply,
                  receiverUid: postcard.senderUid,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
