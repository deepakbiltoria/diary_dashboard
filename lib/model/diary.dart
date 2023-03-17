import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String? id;
  final String? user_id;
  final String? title;
  final String? author;
  final Timestamp? entryTime;
  final String? photoUrls;
  final String? entry;

  Diary(
      {this.id,
      this.user_id,
      this.title,
      this.author,
      this.entryTime,
      this.photoUrls,
      this.entry});

  factory Diary.fromDocument(QueryDocumentSnapshot data) {
    return Diary(
        id: data.id,
        user_id: data.get('user_id'),
        title: data.get('title'),
        author: data.get('author'),
        entryTime: data.get('entry_time'),
        photoUrls: data.get('photo_list'),
        entry: data.get('entry'));
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": user_id,
      "title": title,
      "author": author,
      "entry_time": entryTime,
      "photo_list": photoUrls,
      "entry": entry
    };
  }
}
