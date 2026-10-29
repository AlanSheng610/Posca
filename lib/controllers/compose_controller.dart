import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/controllers/auth_controller.dart';
import 'package:posca/controllers/postcard_controller.dart';
import 'package:posca/controllers/profile_controller.dart';
import 'package:posca/data/firestore_refs.dart';
import 'package:posca/models/postcard.dart';

/// Uploads a new postcard and delivers it.
class ComposeController extends GetxController {
  final AuthController _auth = Get.find();
  final ProfileController _profiles = Get.find();
  final PostcardController _postcards = Get.find();

  Future<void> send({
    required PostcardType type,
    required String receiverUid,
    required String title,
    required String content,
    required String photoPath,
    required String thumbnailPath,
    required String country,
    required String city,
    required Color cardColor,
  }) async {
    final sender = _profiles.profile;
    final id = FirestoreRefs.postcards.doc().id;

    final urls = await Future.wait([
      _upload(FirestoreRefs.photo(id), photoPath),
      _upload(FirestoreRefs.thumbnail(id), thumbnailPath),
    ]);

    final postcard = Postcard(
      id: id,
      senderUid: sender.uid,
      senderName: _auth.user.displayName ?? sender.name,
      receiverUid: receiverUid,
      type: type,
      country: country,
      city: city,
      imageUrl: urls[0],
      thumbnailUrl: urls[1],
      title: title,
      content: content,
      createdAt: DateTime.now(),
      cardColor: cardColor.value,
      textColor: AppColors.onColor(cardColor).value,
    );
    final data = postcard.toMap();

    final batch = FirebaseFirestore.instance.batch()
      ..set(FirestoreRefs.postcards.doc(id), data)
      ..set(FirestoreRefs.sent(sender.uid).doc(id), data);
    switch (type) {
      case PostcardType.public:
        batch.set(FirestoreRefs.publicPool.doc(id), data);
      case PostcardType.reply:
        batch
          ..set(FirestoreRefs.received(receiverUid).doc(id), data)
          ..set(FirestoreRefs.inbox(receiverUid).doc(id), data);
    }
    await batch.commit();

    await _profiles.updateLocation(city: city, country: country);
    if (type == PostcardType.public) await _profiles.recordPublicSend();
    _postcards.sent.insert(0, postcard);
  }

  Future<String> _upload(Reference ref, String path) async {
    final snapshot = await ref.putFile(File(path));
    return snapshot.ref.getDownloadURL();
  }
}
