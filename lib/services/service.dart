import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_dashboard/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../model/diary.dart';

final diaryService_Instance = DiaryService();

class DiaryService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');

  Future<UserCredential> loginUser(String email, String password) async {
    UserCredential userCredentials = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredentials;
  }

  Future<void> update(MUser user, String avatar_Url, String display_name,
      BuildContext context) async {
    MUser updateUser = MUser(
        avatarUrl: avatar_Url,
        displayName: display_name,
        uid: user.uid,
        email_address: user.email_address);

    await userCollectionReference.doc(user.id).update(updateUser.toMap());

    return;
  }

  // Future<void> addUserDiary(MUser user, List<Diary>? list_of_diaries,
  //     BuildContext context) async {
  //   MUser updateUser =
  //   MUser(userDiaries: list_of_diaries ,uid: user.uid);
  //
  //   await userCollectionReference.doc(user.id).update(updateUser.toMap());
  //
  //   return;
  // }

  Future<void> createUser(String displayName, BuildContext context, String uid,
      avatarUrl, profession, emailAddress) async {
    MUser user = MUser(
      avatarUrl: avatarUrl,
      profession: profession,
      displayName: displayName,
      uid: uid,
      email_address: emailAddress,
    );

    userCollectionReference.add(user.toMap());

    return;
  }

  Future<List<Diary>> getSameDateDiaries(
      {required DateTime first, required String userId}) {
    return diaryCollectionReference
        .where('entry_time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(first).toDate())
        .where('entry_time',
            isLessThan:
                Timestamp.fromDate(first.add(Duration(days: 1))).toDate())
        .where('user_id', isEqualTo: userId)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      }).toList();
    });
  }

  getLatestDiaries(String uid) {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: true)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }

  getEarliestDiaries(String uid) {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: false)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }
}
