import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/services/user_management.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Login App',
      theme: ThemeData(
          accentColor: Colors.lightBlueAccent, primarySwatch: Colors.blue),
      home: UserManagement().handleAuth(),
    );
  }
}
