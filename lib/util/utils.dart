import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../model/diary.dart';
import '../services/service.dart';

String kFormatDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String kFormatDateFromTimeStamp(Timestamp? timestamp) {
  return DateFormat.yMMMd().add_EEEE().format(timestamp!.toDate());
}

String kFormatDateFromTimeStampHour(Timestamp? timestamp) {
  return DateFormat.jm().format(timestamp!.toDate());
}

List<Diary> fillListOfDiaries(
    {required DateTime selectedDate,
    required User? logedinUser,
    required BuildContext context}) {
  List<Diary> _listOfDiaries = [];
  var userDiaryFilteredEntriesList = DiaryService().getSameDateDiaries(
      first: Timestamp.fromDate(selectedDate).toDate(),
      userId: logedinUser!.uid);

  userDiaryFilteredEntriesList.then((value) {
    for (var item in value) {
      _listOfDiaries.add(item);
    }
  });
  return _listOfDiaries;
}
