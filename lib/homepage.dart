// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_task/authentication.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("HOME"),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signout();
              },
              child: Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
