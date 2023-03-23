import 'package:data_management/student.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> insertStudent(Student student, dynamic database) async {
  // Get a reference to the database.
  final db = await database;
  await db.insert(
    'students',
    student.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateStudent(Student student, dynamic database) async {
  final db = await database;
  await db.update('students', student.toMap(),
      where: 'id = ?', whereArgs: [student.id]);
}

Future<List<Student>> getAllStudents(dynamic database) async {
  final db = await database;
  final List<Map<String, dynamic>> studs = await db.query('students');

  return List.generate(studs.length, (i) {
    return Student(
        id: studs[i]['id'],
        name: studs[i]["name"],
        lastName: studs[i]["lastname"]);
  });
}
