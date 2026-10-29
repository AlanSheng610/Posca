import 'package:cloud_firestore/cloud_firestore.dart';

/// How a postcard was sent.
enum PostcardType {
  /// Sent to the public pool, to be delivered to a stranger.
  public,

  /// A reply to a postcard the user received.
  reply,
}

class Postcard {
  const Postcard({
    required this.id,
    required this.senderUid,
    required this.senderName,
    required this.receiverUid,
    required this.type,
    required this.country,
    required this.city,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.cardColor,
    required this.textColor,
  });

  final String id;
  final String senderUid;
  final String senderName;

  /// Empty for [PostcardType.public] cards until they are delivered.
  final String receiverUid;
  final PostcardType type;

  /// Where the photo was taken.
  final String country;
  final String city;

  /// Full-size photo.
  final String imageUrl;

  /// Cropped 3:2 photo shown on the postcard itself.
  final String thumbnailUrl;

  final String title;
  final String content;
  final DateTime createdAt;

  /// ARGB colors, derived from the photo's dominant color.
  final int cardColor;
  final int textColor;

  Map<String, dynamic> toMap() => {
        'id': id,
        'senderUid': senderUid,
        'senderName': senderName,
        'receiverUid': receiverUid,
        'type': type.name,
        'country': country,
        'city': city,
        'imageUrl': imageUrl,
        'thumbnailUrl': thumbnailUrl,
        'title': title,
        'content': content,
        'createdAt': Timestamp.fromDate(createdAt),
        'cardColor': cardColor,
        'textColor': textColor,
      };

  factory Postcard.fromMap(Map<String, dynamic> map) => Postcard(
        id: map['id'] as String,
        senderUid: map['senderUid'] as String,
        senderName: map['senderName'] as String? ?? '',
        receiverUid: map['receiverUid'] as String? ?? '',
        type:
            PostcardType.values.asNameMap()[map['type']] ?? PostcardType.public,
        country: map['country'] as String? ?? '',
        city: map['city'] as String? ?? '',
        imageUrl: map['imageUrl'] as String? ?? '',
        thumbnailUrl: map['thumbnailUrl'] as String? ?? '',
        title: map['title'] as String? ?? '',
        content: map['content'] as String? ?? '',
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        cardColor: map['cardColor'] as int,
        textColor: map['textColor'] as int,
      );
}
