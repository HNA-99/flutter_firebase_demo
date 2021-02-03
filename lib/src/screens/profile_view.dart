import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/services/user_management.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserManagement userObj = new UserManagement();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.pink[700],
        automaticallyImplyLeading: false,
      ),
      body: Center(
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
                borderRadius: BorderRadius.all(Radius.circular(10))),
            onPressed: () {
              userObj.signOut();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
