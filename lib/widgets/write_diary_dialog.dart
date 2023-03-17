import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_dashboard/model/diary.dart';
import 'package:diary_dashboard/services/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker_web/image_picker_web.dart';

import '../util/utils.dart';

class WriteDiaryDialog extends StatefulWidget {
  DateTime selectedDate;

  WriteDiaryDialog({Key? key, required this.selectedDate}) : super(key: key);
  @override
  State<WriteDiaryDialog> createState() => _WriteDiaryDialogState();
}

class _WriteDiaryDialogState extends State<WriteDiaryDialog> {
  final _descriptionTextController = TextEditingController();
  final _titleTextController = TextEditingController();
  var buttonText = 'done';
  CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');
  User? currUser = FirebaseAuth.instance.currentUser;

  // html.File? _cloudFile;

  var _fileBytes;
  Image? _imageWidget;
  String? currDiaryID;

  @override
  Widget build(BuildContext context) {
    Size mdiaQuerysize = MediaQuery.of(context).size;
    return AlertDialog(
      elevation: 5,
      content: Container(
        width: mdiaQuerysize.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Discard'),
                    style: TextButton.styleFrom(primary: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      firebase_storage.FirebaseStorage fs =
                          firebase_storage.FirebaseStorage.instance;
                      final dateTime = DateTime.now();
                      final path = "$dateTime";

                      final isfieldEmpty = _titleTextController.text.isEmpty &&
                          _descriptionTextController.text.isEmpty;
                      print("isfieldEmpty $isfieldEmpty");

                      if (!isfieldEmpty) {
                        diaryCollectionReference
                            .add(Diary(
                          user_id: currUser!.uid,
                          title: _titleTextController.text,
                          author: currUser!.displayName,
                          entry: _descriptionTextController.text,
                          entryTime: Timestamp.fromDate(widget.selectedDate),
                        ).toMap())
                            .then((value) {
                          // setState(
                          //   () {
                          //     currDiaryID = value.id;
                          //   },
                          // );

                          currDiaryID = value.id;
                          return null;
                        });

                        // DiaryService().addUserDiary(mUser, list_of_diaries, context);
                      }

                      if (_fileBytes != null) {
                        firebase_storage.SettableMetadata? metaData =
                            firebase_storage.SettableMetadata(
                                contentType: 'image/jpeg',
                                customMetadata: {'picked-file-path': path});
                        Future.delayed(Duration(milliseconds: 1500)).then(
                          (value) => fs
                              .ref()
                              .child(
                                  'images/$path${FirebaseAuth.instance.currentUser!.uid}')
                              .putData(_fileBytes, metaData)
                              .then((e) {
                            return e.ref.getDownloadURL().then((value) {
                              diaryCollectionReference
                                  .doc(currDiaryID)
                                  .update({'photo_list': value.toString()});
                            });
                          }),
                        );
                      }

                      setState(() {
                        buttonText = 'saving..';
                      });
                      Future.delayed(Duration(milliseconds: 2500)).then(
                        (value) {
                          //  Navigator.of(context).pop();
                          //  here this will return widget.selectedDate value to the Caller page or you can say that page from where the WriteDiaryDialog was invoked
                          // and we will receive that value using await and  than we can use that as er our need
                          // note :- we have given a name "responseSelectedValue"  to this 'widget.selectedDate' value we are popping he dialog with
                          // you can find the use of this response in the caller page  by the name "responseSelectedValue"
                          Navigator.pop(context, widget.selectedDate);
                        },
                      );
                    },
                    child: Text(buttonText),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        side: BorderSide(color: Colors.green, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    height: mdiaQuerysize.height,
                    color: Colors.white,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await getMultipleImageInfos();
                          },
                          icon: Icon(Icons.image_rounded),
                          splashRadius: 20,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(widget.seletedDate.toString().split(' ').first),
                        Text(kFormatDate(widget.selectedDate)),
                        SizedBox(
                          width: mdiaQuerysize.width * 0.5,
                          child: Form(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: mdiaQuerysize.height * 0.8 / 2,
                                  child: Container(
                                    width: 700,
                                    color: Colors.green,
                                    child: _imageWidget,
                                  ),
                                ),
                                TextFormField(
                                  controller: _titleTextController,
                                  decoration:
                                      InputDecoration(hintText: 'title'),
                                ),
                                TextFormField(
                                  maxLines: null,
                                  controller: _descriptionTextController,
                                  decoration: InputDecoration(
                                      hintText:
                                          'write your description hereee'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    // String mimeType = mime(Path.basename(mediaData.fileName));
    // html.File mediaFile =
    // new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    // if (mediaFile != null) {

    setState(() {
      //     _cloudFile = mediaFile;
      _fileBytes = mediaData!.data;

      // print("file bytes info ${_fileBytes.toString()}");

      _imageWidget = Image.memory(mediaData.data!);
    });

    // }
  }
}
