import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/diary.dart';
import '../screens/main_page.dart';

class DeleteEntryDialog extends StatelessWidget {
  const DeleteEntryDialog({
    Key? key,
    required this.bookCollectionReference,
    required this.diary,
  }) : super(key: key);

  final CollectionReference<Object?> bookCollectionReference;
  final Diary diary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Entry ?',
        style: TextStyle(color: Colors.red),
      ),
      content: Text(
          'Are you sure you want to delete the entry ?\n once deleted the entry cannot be retrived'),
      actions: [
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
            label: Text('Cancel')),
        TextButton.icon(
            onPressed: () {
              bookCollectionReference.doc(diary.id).delete().then((value) {
                return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return MainPage();
                  },
                ), (route) => false);
                // return Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return MainPage();
                //     },
                //   ),
                // );
              });
              //Navigator.of(context).pop();
            },
            icon: Icon(Icons.delete_outline),
            label: Text('Delete'))
      ],
    );
  }
}
