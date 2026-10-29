import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/screens/compose/compose_args.dart';

/// Takes the photo for a new postcard. Tapping the preview of the captured
/// photo continues to the compose screen.
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as ComposeArgs;
    return Scaffold(
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photo(
          exifPreferences: ExifPreferences(saveGPSLocation: true),
        ),
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.back),
          aspectRatio: CameraAspectRatios.ratio_16_9,
        ),
        onMediaTap: (mediaCapture) {
          final path = mediaCapture.captureRequest
              .when(single: (single) => single.file?.path);
          if (path == null) return;
          Get.toNamed(Routes.compose, arguments: args.withPhoto(path));
        },
      ),
    );
  }
}
