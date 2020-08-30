import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(MyApp());
  await Firebase.initializeApp();
  // FirebaseFirestore.instance
  //     .collection("messages")
  //     .doc()
  //     .set({"text": "kkkkk", "from": "extrinha", "read": false});
  FirebaseFirestore.instance.collection("messages").snapshots().listen((event) {
    event.docs.forEach((element) {
      print(element.data());
    });
  });

  print("Inseri o bagulho");
  // Firestore.instance
  //     .collection("col")
  //     .document("doc")
  //     .setData({"text": "daniel"});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
    );
  }
}
