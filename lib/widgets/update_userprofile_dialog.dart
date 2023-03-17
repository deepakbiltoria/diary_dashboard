import 'package:diary_dashboard/model/user.dart';
import 'package:diary_dashboard/services/service.dart';
import 'package:flutter/material.dart';

class UpdateUserProfileDialog extends StatefulWidget {
  const UpdateUserProfileDialog({
    Key? key,
    required this.curUser,
  }) : super(key: key);

  final MUser curUser;

  @override
  State<UpdateUserProfileDialog> createState() =>
      _UpdateUserProfileDialogState();
}

class _UpdateUserProfileDialogState extends State<UpdateUserProfileDialog> {
  late TextEditingController _displayNameTextController;

  late TextEditingController _avatarUrlTextController;
  @override
  void initState() {
    _displayNameTextController =
        TextEditingController(text: widget.curUser.displayName);
    _avatarUrlTextController =
        TextEditingController(text: widget.curUser.avatarUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('userdetails Build');
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Editing ${widget.curUser.displayName}",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Form(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _avatarUrlTextController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        TextFormField(controller: _displayNameTextController),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        diaryService_Instance.update(
                            widget.curUser,
                            _avatarUrlTextController.text,
                            _displayNameTextController.text,
                            context);

                        Future.delayed(
                          Duration(milliseconds: 200),
                        ).then((value) {
                          return Navigator.of(context).pop();
                        });
                        // setState(() {});
                        // this cassacading of .pop method will pop two consecutive screen
                        // Navigator.of(context)
                        //   ..pop()
                        //   ..pop();
                      },
                      child: Text("Update"),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          side: BorderSide(color: Colors.green, width: 1)),
                    ),
                  )
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
