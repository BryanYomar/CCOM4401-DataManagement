import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_management/studentService.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'student.dart';
import 'studentServiceFirebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de CCOM 4401',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'App de CCOM 4401'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Student> students = [];
  dynamic database;

  @override
  void initState() {
    super.initState();
  }

  getStudents() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'ccom4401.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, lastname TEXT)',
        );
      },
      version: 1,
    );
    var studs = await getAllStudents(database);
    students = studs;
    return students;
  }

  void _addStudent() async {
    // Add a student
    insertStudent(
        const Student(id: 3, name: "John", lastName: "Astor"), database);

    // Update the view
    setState(() {
      getStudents();
    });
  }

  void _updateStudent() async {
    // Update a student
    updateStudent(
        const Student(id: 1, name: "Aleph", lastName: "Perez"), database);

    setState(() {
      getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic fbDB = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> _studentStream =
        FirebaseFirestore.instance.collection("students").snapshots();
    Future<dynamic> getStudentsFB() async {
      dynamic studs = await readStudents(fbDB);
      print(studs[0].name);
      students = studs;
      return studs;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
            child: StreamBuilder<QuerySnapshot>(
          stream: _studentStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name']),
                      subtitle: Text(data['lastname']),
                    );
                  })
                  .toList()
                  .cast(),
            );
          },
        )
            // FUTURE BUILDER: LOCAL DATA
            //     child: FutureBuilder(
            //   future: getStudents(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData &&
            //         snapshot.connectionState == ConnectionState.done) {
            //       return ListView.builder(
            //           itemCount: students.length,
            //           itemBuilder: (context, i) {
            //             return Padding(
            //               padding: EdgeInsets.all(15.0),
            //               child: Text(
            //                 '${students[i].name} ${students[i].lastName}',
            //                 style: TextStyle(color: Colors.black, fontSize: 32.0),
            //               ),
            //             );
            //           });
            //     }

            //     return const CircularProgressIndicator();
            //   },
            // )
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudent,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
