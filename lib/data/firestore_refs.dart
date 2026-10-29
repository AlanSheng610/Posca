import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

typedef Json = Map<String, dynamic>;

/// Single source of truth for where data lives in Firestore and Storage.
///
/// ```text
/// users/{uid}                     UserProfile
/// users/{uid}/settings/send       SendConfig
/// users/{uid}/sent/{id}           Postcard   cards this user sent
/// users/{uid}/received/{id}       Postcard   every card this user received
/// users/{uid}/inbox/{id}          Postcard   received cards not yet archived
/// postcards/{id}                  Postcard   every card ever sent
/// public/{id}                     Postcard   public cards awaiting delivery
/// ```
abstract final class FirestoreRefs {
  static FirebaseFirestore get _db => FirebaseFirestore.instance;

  static CollectionReference<Json> get postcards => _db.collection('postcards');
  static CollectionReference<Json> get publicPool => _db.collection('public');

  static DocumentReference<Json> user(String uid) =>
      _db.collection('users').doc(uid);

  static DocumentReference<Json> sendConfig(String uid) =>
      user(uid).collection('settings').doc('send');

  static CollectionReference<Json> sent(String uid) =>
      user(uid).collection('sent');

  static CollectionReference<Json> received(String uid) =>
      user(uid).collection('received');

  static CollectionReference<Json> inbox(String uid) =>
      user(uid).collection('inbox');

  static Reference photo(String postcardId) =>
      FirebaseStorage.instance.ref('photos/$postcardId.jpg');

  static Reference thumbnail(String postcardId) =>
      FirebaseStorage.instance.ref('thumbnails/$postcardId.jpg');
}
