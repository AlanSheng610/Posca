import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/controllers/postcard_controller.dart';
import 'package:posca/models/postcard.dart';
import 'package:posca/widgets/network_photo.dart';
import 'package:posca/widgets/postcard_face.dart';
import 'package:posca/widgets/transformable.dart';

/// A board where the user can move, zoom and flip their latest postcard.
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostcardController postcards = Get.find();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: transparentAppBar(),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: size.height * 0.15),
          Container(
            height: size.height * 0.8,
            width: size.width * 0.9,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(221, 138, 138, 138),
            ),
            child: postcards.sent.isEmpty
                ? const Center(
                    child: Text(
                      'Send your first postcard to start a collection',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Transformable(
                    initialOffset: Offset(size.width * 0.05, size.height * 0.1),
                    initialScale: 0.7,
                    minScale: 0.5,
                    maxTranslationX: size.height * 0.9,
                    maxTranslationY: 500,
                    child: FlipCard(postcard: postcards.sent.first),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Double-tap to flip between the written side and the photo.
class FlipCard extends StatefulWidget {
  const FlipCard({super.key, required this.postcard});

  final Postcard postcard;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _showFront = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.8;
    final height = size.height * 0.25;

    return GestureDetector(
      onDoubleTap: () => setState(() => _showFront = !_showFront),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: _flipTransition,
        layoutBuilder: (current, previous) =>
            Stack(children: [current!, ...previous]),
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease.flipped,
        child: _showFront
            ? PostcardFace(
                key: const ValueKey(true),
                postcard: widget.postcard,
                width: width,
                height: height,
              )
            : ClipRRect(
                key: const ValueKey(false),
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: NetworkPhoto(widget.postcard.thumbnailUrl),
                ),
              ),
      ),
    );
  }

  Widget _flipTransition(Widget child, Animation<double> animation) {
    final rotation = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotation,
      child: child,
      builder: (context, child) {
        final isIncoming = ValueKey(_showFront) == child!.key;
        // The outgoing side stops at 90° so it never shows its back.
        final angle =
            isIncoming ? rotation.value : min(rotation.value, pi * 0.5);
        return Transform(
          transform: Matrix4.rotationY(angle),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
