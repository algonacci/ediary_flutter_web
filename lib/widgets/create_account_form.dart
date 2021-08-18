import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ediary_flutter_web/model/user.dart';
import 'package:ediary_flutter_web/screens/main_page.dart';
import 'package:ediary_flutter_web/services/service.dart';
import 'package:ediary_flutter_web/widgets/input_decorator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
    Key? key,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
    GlobalKey<FormState>? formKey,
  })  : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        _globalKey = formKey,
        super(key: key);

  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;
  final GlobalKey<FormState>? _globalKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Please enter a valid email and password that is at least 6 characters'),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? 'Please enter an email' : null;
              },
              controller: _emailTextController,
              decoration: buildInputDecoration('Email', 'hi@me.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? 'Please enter a Password' : null;
              },
              obscureText: true,
              controller: _passwordTextController,
              decoration: buildInputDecoration('Password', ''),
            ),
          ),
          SizedBox(height: 15),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.green,
              textStyle: TextStyle(
                fontSize: 18,
              ),
            ),
            onPressed: () {
              if (_globalKey!.currentState!.validate()) {
                // hi@me.com [hi, me.com]
                String email = _emailTextController.text;

                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: _passwordTextController.text)
                    .then(
                  (value) {
                    if (value.user != null) {
                      String uid = value.user!.uid;
                      DiaryService()
                          .createUser(email.split('@')[0], context, uid)
                          .then(
                        (value) {
                          DiaryService()
                              .loginUser(email, _passwordTextController.text)
                              .then((value) {
                            return Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(),
                              ),
                            );
                          });
                        },
                      );
                    }
                  },
                );
              }
            },
            child: Text('Create Account'),
          ),
        ],
      ),
    );
  }
}
