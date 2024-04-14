import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String email;
  final String uid;
  final String username;
  final String? profileImageUrl;
  final String? bio;

  UserData(
      {required this.email,
      required this.uid,
      required this.username,
      this.profileImageUrl,
      this.bio,
      });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'username': username,
        'profileImageUrl': profileImageUrl,
        'bio': bio,
      };

  static UserData fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
      email: snapshot['email'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      profileImageUrl: snapshot['profileImageUrl'],
      bio: snapshot['bio'],
    );
  }
}
