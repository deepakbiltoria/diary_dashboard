import 'package:diary_dashboard/screens/login_page.dart';
import 'package:diary_dashboard/services/service.dart';
import 'package:diary_dashboard/widgets/update_userprofile_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';

class CreateProfile extends StatelessWidget {
  CreateProfile({
    Key? key,
    required this.curUser,
  }) : super(key: key);

  final MUser curUser;

  @override
  Widget build(BuildContext context) {
    print('creatperofile build');
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateUserProfileDialog(curUser: curUser);
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(curUser.avatarUrl!),
                    // backgroundColor: Colors.transparent,
                  ),
                ),
              )),
              Text(
                curUser.displayName!,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                });
              },
              icon: Icon(
                Icons.logout_outlined,
                size: 19,
                color: Colors.red,
              ))
        ],
      ),
    );
  }
}
