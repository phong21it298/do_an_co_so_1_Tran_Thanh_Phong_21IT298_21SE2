import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_03/model/local/user.dart';
import 'package:app_03/model/local/search_history.dart';
import 'package:app_03/utils/hash_password.dart';

class AnimeDatabaseHelper {
  //Đối tượng AnimeDatabaseHelper !.
  static final AnimeDatabaseHelper _instance = AnimeDatabaseHelper._internal();
  factory AnimeDatabaseHelper() => _instance;

  static Database? _database;

  AnimeDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'anime_search_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        image_path TEXT,
        anime_title TEXT,
        timestamp TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');
  }

  //Đăng ký.
  Future<int> insertUser(User user) async {
    final db = await _instance.database;

    //Mã hóa password trước khi lưu.
    final hashedUser = User(
      id: user.id,
      name: user.name,
      email: user.email,
      password: hashPassword(user.password),
    );

    return await db.insert('users', hashedUser.toMap());
  }

  //Đăng nhập.
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await _instance.database;

    //Mã hóa password đã nhập trước khi so sánh trong cơ sở dữ liệu.
    final hashedPassword = hashPassword(password);

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  //Thêm lịch sử tìm kiếm.
  Future<int> insertSearchHistory(SearchHistory history) async {
    final db = await _instance.database;

    return await db.insert('search_history', history.toMap());
  }

  //Lấy toàn bộ lịch sử của một người dùng.
  Future<List<SearchHistory>> getHistoryByUserId(int userId) async {
    final db = await _instance.database;

    final List<Map<String, dynamic>> result = await db.query(
      'search_history',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );

    return result.map((map) => SearchHistory.fromMap(map)).toList();
  }

  //Xóa lịch sử tìm kiếm.
  Future<int> deleteSearchHistory(int id) async {
    final db = await _instance.database;

    return await db.delete(
      'search_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Chỉnh sửa lịch sử tìm kiếm.
  Future<int> updateSearchHistory(SearchHistory history) async {
    final db = await _instance.database;

    return await db.update(
      'search_history',
      history.toMap(),
      where: 'id = ?',
      whereArgs: [history.id],
    );
  }
}