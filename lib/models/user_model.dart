import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;

  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? bio;
  final String? address;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.bio,
    this.address,
    required this.createdAt,
    this.lastLoginAt,
  });

  /// ✅ FIRESTORE → MAP (SAVE USER)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  /// ✅ FIRESTORE → MODEL (READ USER)
  /// fromMap er kaz hocche Map theke UserModel e convert kora
  factory UserModel.fromMap(Map<String, dynamic> map) {
    print(map["uid"]);
    print(map["email"]);

    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      bio: map['bio'],
      address: map['address'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: map['lastLoginAt'] != null
          ? (map['lastLoginAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// ✅ COPY WITH (UPDATE SUPPORT)
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bio,
    String? address,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// ✅ FULL NAME HELPER
  String get fullName => '$firstName $lastName';
}
