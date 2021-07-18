// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_task/authentication.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp/SignIn Firebase Authentication"),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
            style: TextStyle(
              fontSize: 20.0,
              height: 2.0,
            ),
          ),

          Padding(padding: EdgeInsets.all(10)),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Password",
            ),
            style: TextStyle(
              fontSize: 20.0,
              height: 2.0,
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
              /* passwordController.text.isEmpty
                  ? _validate = true
                  : _validate = false; */
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

  /* String validatePassword(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return null;
  } */
}
