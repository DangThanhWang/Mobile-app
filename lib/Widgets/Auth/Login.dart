import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red,
        child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: Text("Login")));
  }
}
