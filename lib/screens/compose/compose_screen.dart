import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/controllers/compose_controller.dart';
import 'package:posca/screens/compose/compose_args.dart';

/// Crop the photo, write the message and send the postcard.
class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final ComposeController _compose = Get.find();
  final _args = Get.arguments as ComposeArgs;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  CroppedFile? _croppedFile;
  Color _cardColor = Colors.white;

  String get _photoPath => _args.photoPath!;

  @override
  void initState() {
    super.initState();
    _pickCardColor();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Uses the photo's dominant color for the written side of the card.
  Future<void> _pickCardColor() async {
    final palette =
        await PaletteGenerator.fromImageProvider(FileImage(File(_photoPath)));
    final dominant = palette.dominantColor?.color;
    if (dominant != null && mounted) setState(() => _cardColor = dominant);
  }

  Future<void> _cropImage() async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: _photoPath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop your postcard',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop your postcard',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          rotateButtonsHidden: true,
        ),
      ],
    );
    if (cropped != null) setState(() => _croppedFile = cropped);
  }

  Future<void> _send() async {
    Get.dialog(
      const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Sending...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    try {
      final place = await _currentPlace();
      await _compose.send(
        type: _args.type,
        receiverUid: _args.receiverUid,
        title: _titleController.text,
        content: _contentController.text,
        photoPath: _photoPath,
        thumbnailPath: _croppedFile!.path,
        country: place.country ?? '',
        city: _cityName(place),
        cardColor: _cardColor,
      );
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.back(); // Close the progress dialog.
      Get.defaultDialog(title: 'Sending failed', content: Text(e.toString()));
    }
  }

  Future<Placemark> _currentPlace() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is needed to stamp your postcard.');
    }
    final position = await Geolocator.getCurrentPosition();
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: 'en',
    );
    return placemarks.first;
  }

  /// "Taipei City" -> "Taipei", "Hualien County" -> "Hualien".
  String _cityName(Placemark place) =>
      (place.subAdministrativeArea ?? place.locality ?? '')
          .replaceAll(RegExp(r'\s*(City|County)\s*'), '')
          .trim();

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF212020);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 150),
        child: _croppedFile == null ? _buildCropPrompt() : _buildEditor(),
      ),
    );
  }

  Widget _buildCropPrompt() {
    final width = Get.width * 0.9;
    return InkWell(
      onTap: _cropImage,
      child: Container(
        height: width * 2 / 3,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              color: Theme.of(context).highlightColor,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Crop your photo for the postcard first',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditor() {
    return Column(
      children: [
        InkWell(
          onTap: _cropImage,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.file(File(_croppedFile!.path)),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: Get.width * 0.9,
          height: Get.height * 0.35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFC6BEBA),
          ),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Caption your postcard',
                  labelStyle:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  inputFormatters: [LengthLimitingTextInputFormatter(150)],
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    hintText: "Write down what you're thinking",
                    labelStyle: TextStyle(fontSize: 15),
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OutlinedButton.icon(
                  onPressed: _send,
                  icon: const Icon(Icons.send),
                  label: const Text('Send'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    side: const BorderSide(width: 2, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
