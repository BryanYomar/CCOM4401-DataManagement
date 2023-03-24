import 'package:data_management/student.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Student>> getAllStudents(dynamic database) async {
  final db = await database;
  final List<Map<String, dynamic>> studs = await db.query('Students');

  return List.generate(
      studs.length,
      (index) => Student(
          id: studs[index]["id"],
          name: studs[index]["name"],
          lastname: studs[index]["lastname"]));
}

Future<void> insertStudent(Student st, dynamic database) async {
  final db = await database;
  await db.insert(
      'Students', {"id": st.id, "name": st.name, "lastname": st.lastname},
      conflictAlgorithm: ConflictAlgorithm.replace);
}
