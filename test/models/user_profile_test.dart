import 'package:flutter_test/flutter_test.dart';
import 'package:posca/models/user_profile.dart';

void main() {
  test('fills in defaults for missing fields', () {
    final profile = UserProfile.fromMap('uid1', {'name': 'Alice'});

    expect(profile.uid, 'uid1');
    expect(profile.name, 'Alice');
    expect(profile.bio, isEmpty);
    expect(profile.spokenLanguages, isEmpty);
    expect(profile.interests, isEmpty);
  });

  test('survives a round trip through a Firestore map', () {
    const profile = UserProfile(
      uid: 'uid1',
      name: 'Alice',
      spokenLanguages: ['English', 'Japanese'],
      interests: ['Hiking'],
      city: 'Taipei',
      country: 'Taiwan',
    );

    final decoded = UserProfile.fromMap('uid1', profile.toMap());

    expect(decoded.toMap(), profile.toMap());
  });

  test('copyWith keeps unchanged fields', () {
    const profile = UserProfile(uid: 'uid1', name: 'Alice', bio: 'Hi');

    final updated = profile.copyWith(name: 'Alicia');

    expect(updated.name, 'Alicia');
    expect(updated.bio, 'Hi');
    expect(updated.uid, 'uid1');
  });

  group('location', () {
    test('joins city and country', () {
      const profile = UserProfile(
        uid: 'u',
        name: 'n',
        city: 'Taipei',
        country: 'Taiwan',
      );
      expect(profile.location, 'Taipei, Taiwan');
    });

    test('omits missing parts', () {
      const profile = UserProfile(uid: 'u', name: 'n', country: 'Taiwan');
      expect(profile.location, 'Taiwan');
    });
  });
}
