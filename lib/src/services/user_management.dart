import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/screens/home_nav.dart';
import 'package:flutter_firebase_demo/src/screens/profile_view.dart';
import 'package:flutter_firebase_demo/src/screens/welcome_view.dart';

class UserManagement {
  User user = FirebaseAuth.instance.currentUser;

  Widget handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return WelcomeScreen();
        });
  }

  authorizeAccess(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data.data()['role'] == 'Admin') {
                    return ProfileScreen();
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text('Not Authorized')),
                        Center(
                          child: SizedBox(
                            height: 45,
                            width: 120,
                            child: RaisedButton(
                              color: Colors.pink[700],
                              child: Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () {
                                signOut();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
