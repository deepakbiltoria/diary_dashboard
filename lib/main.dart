import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_dashboard/screens/get_startedpage.dart';
import 'package:diary_dashboard/screens/login_page.dart';
import 'package:diary_dashboard/screens/main_page.dart';
import 'package:diary_dashboard/screens/page_not_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/diary.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDhuDq205BhKtXhWtWtr6Yy8JOrObY0aTc",
        appId: "1:751428050019:web:8a8078fd775046bc7cec56",
        messagingSenderId: "751428050019",
        projectId: "my-diary-2818c",
        storageBucket: "my-diary-2818c.appspot.com"),
  );
  // https://console.firebase.google.com/project/my-diary-2818c/storage/my-diary-2818c.appspot.com/files

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  final userDiaryDataStream = FirebaseFirestore.instance
      .collection('diaries')
      .snapshots()
      .map((diaries) {
    return diaries.docs.map((diary) {
      return Diary.fromDocument(diary);
    }).toList();
  });

  @override
  Widget build(BuildContext context) {
    // print(' userDiaryDataStream ${userDiaryDataStream.runtimeType}');
    // Future.delayed(
    //     Duration(milliseconds: 3000),
    //     () async =>
    //         print(' userDiaryDataStream ${await userDiaryDataStream.first}'));

    return MultiProvider(
      providers: [
        StreamProvider(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null),
        StreamProvider<List<Diary>>(
            create: (context) => userDiaryDataStream, initialData: [])
        // or
        /*
         StreamProvider<List<Diary>>.value( value: userDiaryDataStream, initialData: [])
        */
        //both works
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return RouteController(settingsName: settings.name);
          });
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return PageNotFound();
          });
        },
        // home: LoginPage(),
        // home: GettingStartedPage(),
        //home: GetInfo(),
        //home: const MainPage(title: 'Diary Panel'),
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  final String? settingsName;

  RouteController({super.key, required this.settingsName});
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User?>(context) != null;
    final signedInGotoMain = userSignedIn && settingsName == '/main';
    final signedInGotoLogin = userSignedIn && settingsName == '/login';
    final notSignedInGotoMain = !userSignedIn && settingsName == '/main';
    print(settingsName);
    if (settingsName == '/') {
      return GettingStartedPage();
    } else if (signedInGotoMain || signedInGotoLogin) {
      return MainPage();
    } else if (settingsName == '/main' || notSignedInGotoMain) {
      return LoginPage();
    } else if (settingsName == '/login' || notSignedInGotoMain) {
      return LoginPage();
    } else {
      return PageNotFound();
    }
  }
}

// class GetInfo extends StatelessWidget {
//   GetInfo({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('snapshot has error');
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Text('Loading');
//             }
//             return ListView(
//               children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                 return ListTile(
//                   title: Text(document.get('display_name')),
//                   subtitle: Text(document.get('profession')),
//                 );
//               }).toList(),
//             );
//           }),
//     );
//   }
// }
