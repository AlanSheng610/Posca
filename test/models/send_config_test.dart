import 'package:flutter_test/flutter_test.dart';
import 'package:posca/models/send_config.dart';

void main() {
  group('canReceiveAt', () {
    final sentAt = DateTime(2024, 3, 1, 12);
    final config = SendConfig(lastPublicSendAt: sentAt);

    test('is true within the receive window', () {
      final now = sentAt.add(const Duration(seconds: 30));
      expect(config.canReceiveAt(now), isTrue);
    });

    test('is false once the window has passed', () {
      expect(
        config.canReceiveAt(sentAt.add(SendConfig.receiveWindow)),
        isFalse,
      );
    });

    test('is false for a user who never sent a public postcard', () {
      expect(SendConfig.initial.canReceiveAt(DateTime.now()), isFalse);
    });
  });

  test('survives a round trip through a Firestore map', () {
    final config = SendConfig(
      lastPublicSendAt: DateTime.utc(2024, 3, 1),
      languages: const ['English'],
      minAge: 20,
      maxAge: 30,
    );

    final decoded = SendConfig.fromMap(config.toMap());

    expect(decoded.toMap(), config.toMap());
  });
}
