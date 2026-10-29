import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermoji.dart';

/// Renders a Fluttermoji avatar from its encoded attribute string.
class Avatar extends StatelessWidget {
  const Avatar(this.encoded, {super.key, this.size = 45});

  final String encoded;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: SvgPicture.string(
          FluttermojiFunctions().decodeFluttermojifromString(encoded),
        ),
      ),
    );
  }
}
