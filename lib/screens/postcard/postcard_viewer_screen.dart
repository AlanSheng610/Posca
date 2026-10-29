import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/models/postcard.dart';
import 'package:posca/screens/postcard/postcard_page.dart';

class PostcardViewerArgs {
  const PostcardViewerArgs(this.postcards, this.initialIndex);

  final List<Postcard> postcards;
  final int initialIndex;
}

/// Pages through a list of postcards, starting at a given one.
class PostcardViewerScreen extends StatefulWidget {
  const PostcardViewerScreen({super.key});

  @override
  State<PostcardViewerScreen> createState() => _PostcardViewerScreenState();
}

class _PostcardViewerScreenState extends State<PostcardViewerScreen> {
  final _args = Get.arguments as PostcardViewerArgs;
  late final _pageController = PageController(initialPage: _args.initialIndex);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: transparentAppBar(),
      body: PageView(
        controller: _pageController,
        allowImplicitScrolling: true,
        children: [
          for (final card in _args.postcards) PostcardPage(postcard: card),
        ],
      ),
    );
  }
}
