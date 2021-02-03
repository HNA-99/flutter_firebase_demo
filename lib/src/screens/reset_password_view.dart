import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
  final auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Send Request'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      auth.sendPasswordResetEmail(email: _email);
                      Navigator.of(context).pop();
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
