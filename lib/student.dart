class Student {
  final int id;
  final String name;
  final String lastName;

  const Student({required this.id, required this.name, required this.lastName});

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "lastName": lastName};
  }
}
