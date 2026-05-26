class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  //Tạo đối tượng User từ Map lấy từ SQLite.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  //Chuyển đối tượng User sang Map để lưu vào SQLite.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'name': name,
      'email': email,
      'password': password,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}
