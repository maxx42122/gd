class UserProfile {
  final String uid;
  final String name;
  final int age;
  final String gender;
  final List<String> medicalHistory;
  final List<String> allergies;
  final DateTime? createdAt;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.age,
    required this.gender,
    this.medicalHistory = const [],
    this.allergies = const [],
    this.createdAt,
  });

  factory UserProfile.empty(String uid) => UserProfile(
        uid: uid,
        name: '',
        age: 0,
        gender: '',
      );

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        age: (map['age'] ?? 0) as int,
        gender: map['gender'] ?? '',
        medicalHistory: List<String>.from(map['medicalHistory'] ?? []),
        allergies: List<String>.from(map['allergies'] ?? []),
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'age': age,
        'gender': gender,
        'medicalHistory': medicalHistory,
        'allergies': allergies,
      };

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    List<String>? medicalHistory,
    List<String>? allergies,
  }) =>
      UserProfile(
        uid: uid,
        name: name ?? this.name,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        medicalHistory: medicalHistory ?? this.medicalHistory,
        allergies: allergies ?? this.allergies,
        createdAt: createdAt,
      );

  bool get isComplete => name.isNotEmpty && age > 0 && gender.isNotEmpty;
}
