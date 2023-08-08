import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String userName;
  final String url;
  final String email;
  final String bio;

  User({
    required this.id,
    required this.profileName,
    required this.userName,
    required this.url,
    required this.email,
    required this.bio,
  });
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      profileName: doc['displayName'],
      userName: doc['userName'],
      url: doc['photoUrl'],
      email: doc['email'],
      bio: doc['bio'],
    );
  }
}
