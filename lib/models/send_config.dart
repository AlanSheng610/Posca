import 'package:cloud_firestore/cloud_firestore.dart';

/// Per-user settings for sending public postcards.
///
/// The targeting fields (languages, locations, gender, age range) are stored
/// but not yet used for matching.
class SendConfig {
  const SendConfig({
    required this.lastPublicSendAt,
    this.languages = const [],
    this.locations = const [],
    this.gender = '',
    this.minAge = 18,
    this.maxAge = 100,
  });

  /// How long after sending a public postcard the user may view their inbox.
  static const receiveWindow = Duration(minutes: 1);

  /// A config for a user who has never sent a public postcard.
  static final initial = SendConfig(
    lastPublicSendAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  final DateTime lastPublicSendAt;
  final List<String> languages;
  final List<String> locations;
  final String gender;
  final int minAge;
  final int maxAge;

  /// Users unlock their inbox by sending a public postcard first.
  bool canReceiveAt(DateTime now) =>
      now.difference(lastPublicSendAt) < receiveWindow;

  Map<String, dynamic> toMap() => {
        'lastPublicSendAt': Timestamp.fromDate(lastPublicSendAt),
        'languages': languages,
        'locations': locations,
        'gender': gender,
        'minAge': minAge,
        'maxAge': maxAge,
      };

  factory SendConfig.fromMap(Map<String, dynamic> map) => SendConfig(
        lastPublicSendAt: (map['lastPublicSendAt'] as Timestamp).toDate(),
        languages: List<String>.from(map['languages'] ?? const []),
        locations: List<String>.from(map['locations'] ?? const []),
        gender: map['gender'] as String? ?? '',
        minAge: map['minAge'] as int? ?? 18,
        maxAge: map['maxAge'] as int? ?? 100,
      );
}
