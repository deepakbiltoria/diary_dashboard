// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:diary_dashboard/screens/main_page.dart';
// import 'package:diary_dashboard/widgets/write_diary_dialog.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../model/diary.dart';
// import '../services/service.dart';
// import '../util/utils.dart';
// import 'delete_entry_dialog.dart';
// import 'inner_list_card.dart';
//
// class DiaryListView extends StatefulWidget {
//   DiaryListView(
//       {Key? key,
//       required this.currUser,
//       required this.selectedDate,
//       required List<Diary> listOfDiaries})
//       : listOfDiaries = listOfDiaries,
//         super(key: key);
//   final List<Diary> listOfDiaries;
//   final User? currUser;
//   final DateTime selectedDate;
//
//   @override
//   State<DiaryListView> createState() => _DiaryListViewState();
// }
//
// class _DiaryListViewState extends State<DiaryListView> {
//   DateTime? responseSelectedValue2 = null;
//
//   final CollectionReference bookCollectionReference =
//       FirebaseFirestore.instance.collection('diaries');
//   Color dynamicColor = Colors.red;
//
//   var userDiaryFilteredEntriesList;
//
//   late List<Diary> _listOfDiaries;
//   DateTime? _selectedDate;
//   randomFunc(User? logedinUser, DateTime selectedDate) {
//     if (responseSelectedValue2 != null) {
//       dynamicColor = Colors.blue;
//       setState(() {
//         print('change color setstate');
//       });
//     }
//     _listOfDiaries.clear();
//     _selectedDate = responseSelectedValue2!;
//
//     userDiaryFilteredEntriesList = DiaryService().getSameDateDiaries(
//         first: Timestamp.fromDate(responseSelectedValue2!).toDate(),
//         userId: logedinUser!.uid);
//     userDiaryFilteredEntriesList.then((value) {
//       for (var item in value) {
//         _listOfDiaries.add(item);
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     _listOfDiaries = widget.listOfDiaries;
//     _selectedDate = widget.selectedDate;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuerySize = MediaQuery.of(context).size;
//
//     return Column(
//       children: [
//         Container(
//           color: dynamicColor,
//           height: 10,
//         ),
//         Expanded(
//           child: SizedBox(
//             width: mediaQuerySize.width * 0.4,
//             child: (_listOfDiaries.isNotEmpty)
//                 ? ListView.builder(
//                     itemCount: _listOfDiaries.length,
//                     itemBuilder: (context, index) {
//                       final Diary diary = _listOfDiaries[index];
//                       return Card(
//                         elevation: 4,
//                         child: InnerListCard(
//                           selectedDate: widget.selectedDate,
//                           bookCollectionReference: bookCollectionReference,
//                           diary: diary,
//                         ),
//                       );
//                     },
//                   )
//                 : ListView.builder(
//                     itemCount: 1,
//                     itemBuilder: (context, index) {
//                       // final Diary diary = _listOfDiaries[index];
//                       return Card(
//                           elevation: 4,
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 width: mediaQuerySize.width * 0.30,
//                                 height: mediaQuerySize.height * 0.20,
//                                 child: Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         'SafeGuard Your memory on ${kFormatDate(widget.selectedDate)}',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyText2,
//                                       ),
//                                       TextButton.icon(
//                                           // onPressed: () {
//                                           //   showDialog(
//                                           //       context: context,
//                                           //       builder: (context) {
//                                           //         return WriteDiaryDialog(
//                                           //             selectedDate:
//                                           //                 widget.selectedDate);
//                                           //       });
//                                           // },
//                                           onPressed: () async {
//                                             responseSelectedValue2 =
//                                                 await showDialog(
//                                                     context: context,
//                                                     builder: (context) {
//                                                       return WriteDiaryDialog(
//                                                           selectedDate: widget
//                                                               .selectedDate);
//                                                     });
//                                             setState(() {
//                                               randomFunc(widget.currUser,
//                                                   responseSelectedValue2!);
//                                               print('onpressed setstsate');
//                                             });
//                                             print(
//                                                 'list of lib ${widget.listOfDiaries}');
//                                             print(
//                                                 'this is responseSelectedValue2 === $responseSelectedValue2');
//
//                                             print(
//                                                 'this is responseSelectedValue2 runtype === ${responseSelectedValue2.runtimeType}');
//                                           },
//                                           icon: Icon(Icons.lock_outline_sharp),
//                                           label: Text('Click to Add an Entry'))
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ));
//                     },
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:diary_dashboard/screens/main_page.dart';
import 'package:diary_dashboard/widgets/write_diary_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/diary.dart';
import '../util/utils.dart';
import 'delete_entry_dialog.dart';
import 'inner_list_card.dart';

class DiaryListView extends StatelessWidget {
  DiaryListView(
      {Key? key,
      required this.currUser,
      required this.selectedDate,
      required List<Diary> listOfDiaries})
      : _listOfDiaries = listOfDiaries,
        super(key: key);
  final List<Diary> _listOfDiaries;
  final User? currUser;
  final DateTime selectedDate;
  final CollectionReference bookCollectionReference =
      FirebaseFirestore.instance.collection('diaries');

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);

    var _diaryList = this._listOfDiaries;
    var filteredDiaryList = _diaryList.where((element) {
      return (element.user_id == _user!.uid);
    }).toList();
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: (filteredDiaryList.isNotEmpty)
                ? ListView.builder(
                    itemCount: filteredDiaryList.length,
                    itemBuilder: (context, index) {
                      final Diary diary = filteredDiaryList[index];
                      return DelayedDisplay(
                        delay: Duration(milliseconds: 1),
                        fadeIn: true,
                        child: Card(
                          elevation: 4,
                          child: InnerListCard(
                            selectedDate: selectedDate,
                            bookCollectionReference: bookCollectionReference,
                            diary: diary,
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      // final Diary diary = _listOfDiaries[index];
                      return Card(
                          elevation: 4,
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.30,
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SafeGuard Your memory on ${kFormatDate(selectedDate)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      TextButton.icon(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return WriteDiaryDialog(
                                                      selectedDate:
                                                          selectedDate);
                                                });
                                          },
                                          icon: Icon(Icons.lock_outline_sharp),
                                          label: Text('Click to Add an Entry'))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ));
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
