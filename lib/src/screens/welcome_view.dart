import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/screens/login_view.dart';
import 'package:flutter_firebase_demo/src/screens/signUp_view.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter firebase demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 45,
                  width: 110,
                  child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text('Sign Up'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                      }),
                ),
                SizedBox(
                  height: 45,
                  width: 110,
                  child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text('Login'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
