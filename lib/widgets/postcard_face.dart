import 'package:flutter/material.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/models/postcard.dart';

/// The written side of a postcard: title and message on the left,
/// a stamp on the right, in the color picked from the photo.
class PostcardFace extends StatelessWidget {
  const PostcardFace({
    super.key,
    required this.postcard,
    required this.width,
    required this.height,
    this.footer,
  });

  final Postcard postcard;
  final double width;
  final double height;

  /// Shown under the message, e.g. sender details.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardColor = Color(postcard.cardColor);
    final inkColor = AppColors.onColor(cardColor);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postcard.title,
                    style: textTheme.titleMedium!.copyWith(color: inkColor),
                  ),
                  const Spacer(),
                  Text(
                    postcard.content,
                    style: textTheme.bodySmall!.copyWith(color: inkColor),
                  ),
                  if (footer != null) ...[
                    const SizedBox(height: 15),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 30,
            thickness: 3,
            color: inkColor,
            indent: 30,
            endIndent: 30,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                height: 70,
                width: 40,
                decoration: BoxDecoration(border: Border.all(color: inkColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
