import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/screens/home_nav.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Timer timer;

  @override
  void initState() {
    auth.currentUser.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'An email has been sent to ${auth.currentUser.email} please verify.'),
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    await auth.currentUser.reload();

    if (auth.currentUser.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}
