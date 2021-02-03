import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/screens/home_nav.dart';
import 'package:flutter_firebase_demo/src/screens/verified.dart';
import 'package:flutter_firebase_demo/src/services/crud.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _email, _password;
  String _role;
  int group;

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  //User user = FirebaseAuth.instance.currentUser;

  FirebaseFirestore db = FirebaseFirestore.instance;

  CrudMethods crudObj = new CrudMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[700],
        title: Text('Sign up'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill in your email";
                  }

                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill in your password";
                  }

                  if (value.length < 8) {
                    return "Password has to be over 7 characters";
                  }

                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Role:'),
                  Radio(
                    value: 1,
                    groupValue: group,
                    onChanged: (value) {
                      _role = 'Admin';
                      setState(() {
                        group = value;
                      });
                    },
                  ),
                  Text('Admin'),
                  Radio(
                    value: 2,
                    groupValue: group,
                    onChanged: (value) {
                      _role = 'Normal';
                      setState(() {
                        group = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('Normal'),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 45,
                    width: 150,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text('Sign Up'),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        onPressed: () {
                          final bool isValid = EmailValidator.validate(_email);

                          if (_formKey.currentState.validate() &&
                              isValid == true) {
                            auth
                                .createUserWithEmailAndPassword(
                                    email: _email.trim(), password: _password)
                                .then((value) {
                              Map<String, dynamic> userData = {
                                'Email': this._email,
                                'Password': this._password,
                                'role': this._role,
                                'Uid': auth.currentUser.uid
                              };

                              crudObj
                                  .addUsers(userData, auth.currentUser.uid)
                                  .catchError((e) {
                                print(e);
                              });

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Please enter Email with the correct format",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
