import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_dashboard/model/user.dart';
import 'package:diary_dashboard/screens/main_page.dart';
import 'package:diary_dashboard/services/service.dart';
import 'package:diary_dashboard/widgets/input_decorator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccountForm extends StatelessWidget {
  final TextEditingController _emailTextController;

  final TextEditingController _passwordTextController;
  final GlobalKey<FormState>? _globalKey;
  const CreateAccountForm(
      {Key? key,
      required TextEditingController emailTextController,
      required TextEditingController passwordTextController,
      GlobalKey<FormState>? formKey})
      : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        _globalKey = formKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              "Please enter a valid email and password that is atleast 6 charactors long"),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? " Please Enter a Email" : null;
              },
              controller: _emailTextController,
              decoration:
                  buildInputDecoration(hint: 'john@me.com', label: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? " Please Enter a Password" : null;
              },
              controller: _passwordTextController,
              obscureText: true,
              decoration: buildInputDecoration(hint: '  ', label: 'Passoword'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              if (_globalKey!.currentState!.validate()) {
                //paul@me.com [paul,me.com]
                String email = _emailTextController.text;
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: _passwordTextController.text)
                    .then((value) {
                  //create our ow user
                  /*
                      avatar
                      displayname
                      uid
                      */
                  if (value.user != null) {
                    String uid = value.user!.uid;
                    DiaryService()
                        .createUser(email.toString().split('@')[0], context,
                            uid, 'https://i.pravatar.cc/300', 'labour', email)
                        .then((value) {
                      DiaryService()
                          .loginUser(email, _passwordTextController.text)
                          .then((value) {
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage()));
                      });
                    });
                  }
                });
              }
            },
            child: Text('Create account'),
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                backgroundColor: Colors.green,
                primary: Colors.white,
                textStyle: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
