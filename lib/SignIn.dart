// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_task/authentication.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LogIn/SignUp"),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
            ),
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim());
            },
            child: Text("Sign In"),
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            onPressed: () {
              context.read<AuthenticationService>().signUp(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim());
            },
            child: Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}
