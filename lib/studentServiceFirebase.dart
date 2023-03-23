import 'package:data_management/student.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void initFirebase() async {
  print("INIT FIREBASE");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<List<Student>> readStudents(dynamic db) async {
  List<Student> docs = [];
  await db.collection("students").get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
      Student studObj = Student(
          id: int.parse(doc.id),
          name: doc.data()["name"],
          lastName: doc.data()["lastname"]);
      print(studObj.id);
      docs.add(studObj);
    }
  });
  return docs;
}
