import 'package:diary_dashboard/screens/main_page.dart';
import 'package:diary_dashboard/widgets/input_decorator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController _emailTextController;

  final TextEditingController _passwordTextController;
  final GlobalKey<FormState>? _globalKey;
  const LoginForm(
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
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return MainPage();
                  }));
                });
              }
            },
            child: Text('SignIn'),
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
