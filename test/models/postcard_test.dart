import 'package:flutter_test/flutter_test.dart';
import 'package:posca/models/postcard.dart';

void main() {
  final postcard = Postcard(
    id: 'abc',
    senderUid: 'alice',
    senderName: 'Alice',
    receiverUid: 'bob',
    type: PostcardType.reply,
    country: 'Taiwan',
    city: 'Taipei',
    imageUrl: 'https://example.com/photo.jpg',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    title: 'Hello',
    content: 'Greetings from Taipei',
    createdAt: DateTime.utc(2024, 3, 1, 12),
    cardColor: 0xFF336699,
    textColor: 0xFFFFFFFF,
  );

  test('survives a round trip through a Firestore map', () {
    final decoded = Postcard.fromMap(postcard.toMap());

    expect(decoded.toMap(), postcard.toMap());
    expect(decoded.type, PostcardType.reply);
    expect(decoded.createdAt.isAtSameMomentAs(postcard.createdAt), isTrue);
  });

  test('stores its type by name', () {
    expect(postcard.toMap()['type'], 'reply');
  });

  test('falls back to public for an unknown type', () {
    final map = postcard.toMap()..['type'] = 'carrier-pigeon';
    expect(Postcard.fromMap(map).type, PostcardType.public);
  });
}
