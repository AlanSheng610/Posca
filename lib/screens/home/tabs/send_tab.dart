import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/models/postcard.dart';
import 'package:posca/screens/compose/compose_args.dart';
import 'package:posca/widgets/swipe_up.dart';

/// Sample postcards shown behind the "swipe up" prompt.
const _samples = [
  (
    image: 'assets/beijing.jpg',
    country: 'China',
    city: 'Beijing',
    date: '2023/2/16'
  ),
  (
    image: 'assets/honolulu.jpg',
    country: 'Hawaii',
    city: 'Honolulu',
    date: '2024/1/18'
  ),
  (
    image: 'assets/bhutan.jpg',
    country: 'Bhutan',
    city: 'Himalayas',
    date: '2020/7/9'
  ),
];

/// Invites the user to swipe up and send a public postcard.
class SendTab extends StatelessWidget {
  const SendTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SwipeUp(
      onSwipe: () => Get.toNamed(
        Routes.camera,
        arguments: const ComposeArgs(type: PostcardType.public),
      ),
      body: const _SampleCarousel(),
      child: Column(
        children: [
          Text(
            'Swipe Up',
            style: textTheme.headlineMedium!.copyWith(color: Colors.white),
          ),
          Text(
            'to create a postcard',
            style: textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _SampleCarousel extends StatelessWidget {
  const _SampleCarousel();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return CarouselSlider(
      options: CarouselOptions(
        height: size.height,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
      ),
      items: [
        for (final sample in _samples)
          Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(sample.image, fit: BoxFit.cover),
              Padding(
                padding: EdgeInsets.fromLTRB(30, size.height * 0.15, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${sample.country},\n${sample.city}.',
                      style: textTheme.headlineMedium!.copyWith(
                        fontSize: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 89,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.chip,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Text(
                        sample.date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
