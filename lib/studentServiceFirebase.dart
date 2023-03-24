import 'package:data_management/student.dart';

Future<List<Student>> readStudents(dynamic db) async {
  List<Student> docs = [];

  await db.collection("students").get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
      docs.add(Student(
          id: int.parse(doc.id),
          name: doc.data()["name"],
          lastname: doc.data()["lastname"]));
    }
  });

  return docs;
}
