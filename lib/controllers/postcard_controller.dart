import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:posca/controllers/profile_controller.dart';
import 'package:posca/data/firestore_refs.dart';
import 'package:posca/models/postcard.dart';
import 'package:posca/models/user_profile.dart';

/// Loads the signed-in user's postcards and the people they've heard from.
class PostcardController extends GetxController {
  final ProfileController _profiles = Get.find();

  final inbox = <Postcard>[].obs;
  final received = <Postcard>[].obs;
  final sent = <Postcard>[].obs;

  /// Everyone who has sent this user a postcard.
  final friends = <UserProfile>[].obs;

  /// Every card the user sent or received, newest first.
  List<Postcard> get history => [...received, ...sent]
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> loadAll(String uid) async {
    final results = await Future.wait([
      _fetch(FirestoreRefs.inbox(uid)),
      _fetch(FirestoreRefs.received(uid)),
      _fetch(FirestoreRefs.sent(uid)),
    ]);
    inbox.assignAll(results[0]);
    received.assignAll(results[1]);
    sent.assignAll(results[2]);
    await _loadFriends(uid);
  }

  Future<void> refreshInbox(String uid) async {
    inbox.assignAll(await _fetch(FirestoreRefs.inbox(uid)));
  }

  Future<void> _loadFriends(String uid) async {
    final senders = {
      for (final card in received)
        if (card.senderUid != uid) card.senderUid: card.senderName,
    };
    final profiles = await Future.wait(
      senders.entries.map((sender) async {
        final profile = await _profiles.fetchProfile(sender.key);
        return profile ?? UserProfile(uid: sender.key, name: sender.value);
      }),
    );
    friends.assignAll(profiles);
  }

  Future<List<Postcard>> _fetch(CollectionReference<Json> collection) async {
    final snapshot =
        await collection.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => Postcard.fromMap(doc.data())).toList();
  }

  void clear() {
    inbox.clear();
    received.clear();
    sent.clear();
    friends.clear();
  }
}
