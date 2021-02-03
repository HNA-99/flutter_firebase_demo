import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/screens/home_nav.dart';
import 'package:flutter_firebase_demo/src/screens/reset_password_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text('Login'),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        onPressed: () {
                          final bool isValid = EmailValidator.validate(_email);

                          if (_formKey.currentState.validate() &&
                              isValid == true) {
                            auth
                                .signInWithEmailAndPassword(
                                    email: _email, password: _password)
                                .then((value) => {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()))
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResetScreen()));
                    },
                    child: Text('Forgot Password?'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
