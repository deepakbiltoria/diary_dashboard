import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_dashboard/widgets/update_entry_dialog.dart';
import 'package:flutter/material.dart';

import '../model/diary.dart';
import '../util/utils.dart';
import 'delete_entry_dialog.dart';

class InnerListCard extends StatelessWidget {
  InnerListCard(
      {Key? key,
      required this.bookCollectionReference,
      required this.diary,
      required this.selectedDate})
      : super(key: key);
  final DateTime selectedDate;
  CollectionReference bookCollectionReference;
  Diary diary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kFormatDateFromTimeStamp(diary.entryTime).toString(),
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteEntryDialog(
                              bookCollectionReference: bookCollectionReference,
                              diary: diary);
                        });
                  },
                  icon: Icon(Icons.delete_forever),
                  label: Text(' '),
                ),
              ],
            ),
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "• ${kFormatDateFromTimeStampHour(diary.entryTime)}",
                    style: TextStyle(color: Colors.green),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.more_horiz),
                    label: Text(' '),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 150,
              //   width: 200,
              //   child: Container(
              //     color: Colors.green,
              //   ),
              // ),
              //
              (diary.photoUrls == null)
                  ? Image.network(
                      'https://picsum.photos/400/200',
                      height: 600,
                      width: 600,
                    )
                  : Image.network(
                      diary.photoUrls!,
                      height: 400,
                      width: 500,
                    ),

              Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            diary.title!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            diary.entry!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            children: [
                              Text(
                                kFormatDateFromTimeStamp(diary.entryTime)
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return UpdateEntryDialog(
                                              bookCollectionReference:
                                                  bookCollectionReference,
                                              widget: this,
                                              diary: diary,
                                              selectedDate: selectedDate);
                                        });
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DeleteEntryDialog(
                                            bookCollectionReference:
                                                bookCollectionReference,
                                            diary: diary);
                                      });
                                },
                                icon: Icon(Icons.delete_forever),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    content: ListTile(
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                kFormatDateFromTimeStampHour(diary.entryTime)
                                    .toString(),
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Image.network(diary.photoUrls ??
                                'https://picsum.photos/400/200'),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        diary.title ?? ' ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        diary.entry ?? ' ',
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'))
                    ],
                  );
                });
          },
        ),
      ],
    );
  }
}
