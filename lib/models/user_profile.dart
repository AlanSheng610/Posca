class UserProfile {
  const UserProfile({
    required this.uid,
    required this.name,
    this.avatar = '',
    this.bio = '',
    this.gender = '',
    this.birthdate = '',
    this.spokenLanguages = const [],
    this.interests = const [],
    this.city = '',
    this.country = '',
  });

  final String uid;
  final String name;

  /// Fluttermoji avatar, encoded as a JSON string of its attributes.
  final String avatar;
  final String bio;
  final String gender;

  /// Formatted as `yyyy/M/d`.
  final String birthdate;
  final List<String> spokenLanguages;
  final List<String> interests;

  /// Location of the last postcard this user sent.
  final String city;
  final String country;

  String get location =>
      [city, country].where((part) => part.isNotEmpty).join(', ');

  UserProfile copyWith({
    String? name,
    String? avatar,
    String? bio,
    String? gender,
    String? birthdate,
    List<String>? spokenLanguages,
    List<String>? interests,
    String? city,
    String? country,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      interests: interests ?? this.interests,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'avatar': avatar,
        'bio': bio,
        'gender': gender,
        'birthdate': birthdate,
        'spokenLanguages': spokenLanguages,
        'interests': interests,
        'city': city,
        'country': country,
      };

  /// Missing fields fall back to defaults, so partially written profiles
  /// still load.
  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      name: map['name'] as String? ?? '',
      avatar: map['avatar'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      birthdate: map['birthdate'] as String? ?? '',
      spokenLanguages: List<String>.from(map['spokenLanguages'] ?? const []),
      interests: List<String>.from(map['interests'] ?? const []),
      city: map['city'] as String? ?? '',
      country: map['country'] as String? ?? '',
    );
  }
}
