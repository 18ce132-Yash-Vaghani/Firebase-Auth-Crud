// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_task/authentication.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String uid;
String uemail;

void userIdAndEmail(String id, String email) {
  uid = id;
  uemail = email;
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _form = GlobalKey<FormState>();

  String name;
  String todo;

  /*  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> getCurrentUser() async {
    
    final User user = await _auth.currentUser;
    uid = user.uid;
    final uemail = FirebaseAuth.instance.currentUser.email;
    print("Email: "+ uemail.toString());
    print(uid);
    print(uemail);
  } */

  @override
  void initState() {
    super.initState();
    //getCurrentUser();
  }

  Future<void> showInformationDialog(
      DocumentSnapshot doc, BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              TextEditingController();
          final TextEditingController _textEditingController2 =
              TextEditingController();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'name',
                          fillColor: Colors.grey[300],
                          filled: true,
                        ),
                        controller: _textEditingController,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Enter new Name";
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Todo',
                          fillColor: Colors.grey[300],
                          filled: true,
                        ),
                        controller: _textEditingController2,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Enter new Todo";
                        },
                      ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Update'),
                  onPressed: () {
                    if (_form.currentState.validate()) {
                      name = _textEditingController.text;
                      todo = _textEditingController2.text;
                      updateData(doc);
                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Card buildItem(DocumentSnapshot doc, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'name: ${doc.data()['name']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'todo: ${doc.data()['todo']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () => showInformationDialog(doc, context),
                  child: Text('Update todo',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField namefield() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      // ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter NAME';
        }
      },
      onSaved: (value) => name = value,
    );
  }

  TextFormField todofield() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'todo',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      // ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter TODO';
        }
      },
      onSaved: (value) => todo = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              context.read<AuthenticationService>().signout();
            },
            child: Text("Sign Out"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db
                .collection('CRUD')
                .doc(uid.toString())
                .collection(uid.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data.docs
                        .map((doc) => buildItem(doc, context))
                        .toList());
              } else {
                return SizedBox();
              }
            },
          ),
          Form(
            key: _formKey,
            child: new Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 10.0)),
                namefield(),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                todofield(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: id != null ? readData : null,
                child: Text('Read', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db
          .collection('CRUD')
          .doc(uid.toString())
          .collection(uid.toString())
          .add({'name': '$name', 'todo': '$todo'});
      setState(() => id = ref.id);
      print(ref.id);
    }
  }

  void readData() async {
    print(uid);
    print(id);
    DocumentSnapshot snapshot = await db
        .collection('CRUD')
        .doc(uid.toString())
        .collection(uid.toString())
        .doc(id)
        .get();
    print("name: " + snapshot.data()['name']);
    print("todo: " + snapshot.data()['todo']);
    print("collection Id: " + uid);
    print("Document Id: " + id);
    print("User Email: " + uemail);
  }

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('CRUD')
        .doc(uid.toString())
        .collection(uid.toString())
        .doc(doc.id)
        .update({'name': '$name', 'todo': '$todo'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db
        .collection('CRUD')
        .doc(uid.toString())
        .collection(uid.toString())
        .doc(doc.id)
        .delete();
    setState(() => id = null);
  }
}
