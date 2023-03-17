import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_dashboard/model/user.dart';
import 'package:diary_dashboard/services/service.dart';
import 'package:diary_dashboard/widgets/create_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../model/diary.dart';
import '../util/utils.dart';
import '../widgets/diary_list_view.dart';
import '../widgets/write_diary_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, String? title}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropDownText;

  User? logedinUser = FirebaseAuth.instance.currentUser;

  DateTime selectedDate = DateTime.now();
  var userDiaryFilteredEntriesList;

  //List<Diary> _listOfDiaries = [];

  @override
  Widget build(BuildContext context) {
    final mdiaQuerysize = MediaQuery.of(context).size;
    print('build of mainage');
    var _user = Provider.of<User?>(context);
    var _listOfDiaries = Provider.of<List<Diary>>(context);

    var latestFilteredDiariesStream;
    var earliestFilteredDiariesStream;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 60,
        elevation: 4,
        title: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "MY",
                      style: TextStyle(
                          fontSize: 35, color: Colors.blueGrey.shade400)),
                  TextSpan(
                      text: "diary",
                      style:
                          TextStyle(fontSize: 35, color: Colors.green.shade400))
                ]),
              )
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: DropdownButton(
                    items: <String>["Latest", "Earliest"].map((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.grey),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      if (value == 'Latest') {
                        setState(() {
                          _dropDownText = value.toString();
                        });
                        _listOfDiaries.clear();
                        latestFilteredDiariesStream =
                            DiaryService().getLatestDiaries(_user!.uid);
                        latestFilteredDiariesStream.then((value) {
                          print('latest value type ${value.runtimeType}');
                          for (var item in value) {
                            setState(() {
                              _listOfDiaries.add(item);
                            });
                          }
                        });
                      } else if (value == 'Earliest') {
                        setState(() {
                          _dropDownText = value.toString();
                        });
                        _listOfDiaries.clear();
                        earliestFilteredDiariesStream =
                            DiaryService().getEarliestDiaries(_user!.uid);
                        earliestFilteredDiariesStream.then((value) {
                          for (var item in value) {
                            setState(() {
                              _listOfDiaries.add(item);
                            });
                          }
                        });
                      }
                    },
                    hint: (_dropDownText == null)
                        ? Text('select')
                        : Text(_dropDownText!),
                    value: _dropDownText,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data!.size != 0) {
                      final userListStream = snapshot.data!.docs.map(
                        (doc) {
                          return MUser.fromDocument(doc);
                        },
                      ).where((muser) {
                        return (muser.uid == logedinUser!.uid);
                      }).toList();

                      MUser curUser = userListStream.first;

                      return CreateProfile(curUser: curUser);
                    } else if (snapshot.hasError) {
                      return Container(
                        width: 40,
                        color: Colors.green,
                        child: Text(
                          'some error occured ${snapshot.error.toString()}',
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    } else {
                      return Container(
                        width: 30,
                        height: 30,
                        color: Colors.blue,
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              //  height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                  right: BorderSide(width: 0.4, color: Colors.blueGrey),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: SfDateRangePicker(
                        onSelectionChanged: (dateRangePickerSelection) {
                      print(dateRangePickerSelection.value.toString());
                      setState(() {
                        selectedDate = dateRangePickerSelection.value;

                        _listOfDiaries.clear();

                        userDiaryFilteredEntriesList = DiaryService()
                            .getSameDateDiaries(
                                first:
                                    Timestamp.fromDate(selectedDate).toDate(),
                                userId: logedinUser!.uid);
                        userDiaryFilteredEntriesList.then((value) {
                          for (var item in value) {
                            setState(() {
                              _listOfDiaries.add(item);
                            });
                          }
                        });
                      });
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: Card(
                      elevation: 4,
                      child: TextButton.icon(
                          onPressed: () {
                            final responseSelectedValue = showDialog(
                                context: context,
                                builder: (context) {
                                  return WriteDiaryDialog(
                                    selectedDate: selectedDate,
                                  );
                                });

                            print(
                                'this is responseSelectedValue === $responseSelectedValue');
                          },
                          icon: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.greenAccent,
                          ),
                          label: Container(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Write New',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: (_listOfDiaries == null)
                  ? Center(
                      child: Text('the diary list is null'),
                    )
                  : DiaryListView(
                      listOfDiaries: _listOfDiaries,
                      selectedDate: selectedDate,
                      currUser: logedinUser,
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return WriteDiaryDialog(selectedDate: selectedDate);
              });
        },
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
    );
  }
}
