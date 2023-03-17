import 'package:cloud_firestore/cloud_firestore.dart';

import 'diary.dart';

class MUser {
  final String? id;
  final String? uid;
  final String? displayName;
  final String? profession;
  final String? avatarUrl;
  final String? email_address;
  //final List<Diary>? userDiaries;

  MUser({
    this.id,
    this.uid,
    this.displayName,
    this.profession,
    this.avatarUrl,
    this.email_address,
    //  this.userDiaries,
  });

  factory MUser.fromDocument(QueryDocumentSnapshot data) {
    return MUser(
        id: data.id,
        uid: data.get('uid'),
        displayName: data.get('display_name'),
        profession: data.get('profession'),
        avatarUrl: data.get('avatar_url'),
        email_address: data.get("email_address")
        //userDiaries: data.get('user_diaries')
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'display_name': displayName,
      'profession': profession,
      'avatar_url': avatarUrl,
      "email_address": email_address
    };
  }
}
