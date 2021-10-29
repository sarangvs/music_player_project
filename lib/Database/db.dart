class User {
  int? id;
  String name;
  int num;
  String location;
  User({
    this.id,
    required this.name,
    required this.num,
    required this.location,
  });

  User.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        num = res['num'],
        location = res['location'];
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'num': num,
      'location': location,
    };
  }
}