import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_dashboard/model/diary.dart';
import 'package:diary_dashboard/services/service.dart';
import 'package:diary_dashboard/widgets/delete_entry_dialog.dart';
import 'package:diary_dashboard/widgets/inner_list_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker_web/image_picker_web.dart';

import '../util/utils.dart';

class UpdateEntryDialog extends StatefulWidget {
  final DateTime selectedDate;
  CollectionReference bookCollectionReference;
  InnerListCard widget;
  Diary diary;

  UpdateEntryDialog(
      {Key? key,
      required this.selectedDate,
      required this.bookCollectionReference,
      required this.diary,
      required this.widget})
      : super(key: key);
  @override
  State<UpdateEntryDialog> createState() => _UpdateEntryDialogState();
}

class _UpdateEntryDialogState extends State<UpdateEntryDialog> {
  late TextEditingController _descriptionTextController;
  late TextEditingController _titleTextController;
  var buttonText = 'done';
  CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');
  User? currUser = FirebaseAuth.instance.currentUser;

  // html.File? _cloudFile;

  var _fileBytes;
  Image? _imageWidget;
  String? currDiaryID;
  @override
  void initState() {
    _descriptionTextController =
        TextEditingController(text: widget.diary.entry);
    _titleTextController = TextEditingController(text: widget.diary.title);

    // TODO: implement initState
    super.initState();
  }

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
                      // print("_imageWidget");
                      //
                      // print(_imageWidget);
                      // print('''(widget.diary.photoUrls == null ||
                      //     widget.diary.photoUrls!.isEmpty)''');
                      //
                      // print((widget.diary.photoUrls == null ||
                      //     widget.diary.photoUrls!.isEmpty));
                      // print("widget.diary.photoUrls");
                      // print(widget.diary.photoUrls);
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

                      final _fieldNotEmpty =
                          _titleTextController.text.isNotEmpty &&
                              _descriptionTextController.text.isNotEmpty;
                      print("isfieldEmpty $_fieldNotEmpty");
                      // now we will check if the entry fields are changed (updated) or not and if their is any change in values of field
                      // we will update the diary.

                      final diaryTitleChanged =
                          widget.diary.title != _titleTextController.text;
                      final diaryDescriptionChanged =
                          widget.diary.entry != _descriptionTextController.text;
                      final diaryImageChanged = _fileBytes != null;

                      final diaryUpdate = diaryTitleChanged ||
                          diaryDescriptionChanged ||
                          diaryImageChanged;

                      if (_fieldNotEmpty && diaryUpdate) {
                        diaryCollectionReference
                            .doc(widget.diary.id)
                            .update(Diary(
                              user_id: currUser!.uid,
                              title: _titleTextController.text,
                              author: currUser!.displayName,
                              entry: _descriptionTextController.text,
                              photoUrls: (widget.diary.photoUrls != null)
                                  ? widget.diary.photoUrls.toString()
                                  : null,
                              entryTime: Timestamp.fromDate(
                                //widget.widget.selectedDate;
                                DateTime.now(),
                              ),
                            ).toMap());

                        currDiaryID = widget.diary.id;
                        //
                        //     .then((value) {
                        //   // setState(
                        //   //   () {
                        //   //     currDiaryID = value.id;
                        //   //   },
                        //   // );
                        //
                        //   currDiaryID = value ;
                        //   return null;
                        // });

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
                              .child('images/$path${currUser!.uid}')
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
                        (value) => Navigator.of(context).pop(),
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
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            //  Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (context) => DeleteEntryDialog(
                                    bookCollectionReference:
                                        widget.bookCollectionReference,
                                    diary: widget.diary));
                          },
                          icon: Icon(Icons.delete_outline),
                          splashRadius: 20,
                        ),
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
                        Text(kFormatDateFromTimeStamp(widget.diary.entryTime)),
                        SizedBox(
                          width: mdiaQuerysize.width * 0.5,
                          child: Form(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: mdiaQuerysize.height * 0.8 / 2,
                                  child: Container(
                                    width: 700,
                                    // color: Colors.green,
                                    child: _imageWidget ??
                                        ((widget.diary.photoUrls == null ||
                                                widget.diary.photoUrls!.isEmpty)
                                            ? Image.network(
                                                'https://picsum.photos/400/200')
                                            : Image.network(
                                                widget.diary.photoUrls!)),
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
