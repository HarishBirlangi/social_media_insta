import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String id;
  final String profileName;
  final String userName;
  final String url;
  final String email;
  final String bio;

  UserDetails({
    required this.id,
    required this.profileName,
    required this.userName,
    required this.url,
    required this.email,
    required this.bio,
  });
  factory UserDetails.fromDocument(DocumentSnapshot doc) {
    return UserDetails(
      id: doc.id,
      profileName: doc['profileName'],
      userName: doc['userName'],
      url: doc['url'],
      email: doc['email'],
      bio: doc['bio'],
    );
  }
}
