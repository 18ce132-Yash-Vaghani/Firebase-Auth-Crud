// @dart=2.9
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_task/SignIn.dart';
import 'package:flutter_task/authentication.dart';
import 'package:flutter_task/homepage.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().onAuthStateChanged,
            initialData: null),
      ],
      child: MaterialApp(
        title: "Flutter_Task",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String uid;
    String uemail;
    final firebaseUser = context.watch<User>();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // ignore: unnecessary_null_comparison
    if (firebaseUser != null) {
    final User user = _auth.currentUser;
    uid = user.uid;
    final uemail = FirebaseAuth.instance.currentUser.email;
    print("Email: "+ uemail.toString());
    print(uid);
    print(uemail);
    userIdAndEmail(uid.toString(), uemail.toString());

    return HomePage();
    }
    return SignInPage();
  }
}
