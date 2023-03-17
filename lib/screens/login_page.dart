import 'package:diary_dashboard/widgets/create_account_form.dart';
import 'package:diary_dashboard/widgets/login_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController =
      TextEditingController(text: 'beebs@mo.com');

  final TextEditingController _passwordTextController =
      TextEditingController(text: '123456');

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool isCreatedAccountClicked = false;

  // @override
  // void initState() {
  //   FirebaseAuth.instance
  //       .signInWithEmailAndPassword(
  //           email: _emailTextController.text,
  //           password: _passwordTextController.text)
  //       .then((value) {
  //     return Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return MainPage();
  //     }));
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Container(
                color: Color(0xFFB9C2D1),
              )),
          Text(
            "SignIn",
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: isCreatedAccountClicked
                    ? CreateAccountForm(
                        emailTextController: _emailTextController,
                        passwordTextController: _passwordTextController,
                        formKey: _globalKey,
                      )
                    : LoginForm(
                        emailTextController: _emailTextController,
                        passwordTextController: _passwordTextController,
                        formKey: _globalKey,
                      ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    // isCreatedAccountClicked == true ? false : true;
                    if (!isCreatedAccountClicked) {
                      isCreatedAccountClicked = true;
                    } else {
                      isCreatedAccountClicked = false;
                    }
                  });
                  print(isCreatedAccountClicked);
                },
                icon: Icon(Icons.portrait_rounded),
                label: Text(
                  isCreatedAccountClicked
                      ? "Already have an account ?"
                      : "Create Account",
                ),
                style: TextButton.styleFrom(
                  textStyle:
                      TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
          Expanded(
              flex: 2,
              child: Container(
                color: Color(0xFFB9C2D1),
              )),
        ],
      ),
    );
  }
}
