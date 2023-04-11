import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project2/loginagain/user.dart';

class DatabaseHelper {
  static final _host = 'localhost';
  static final _port = 3306;
  static final _user = 'your_username';
  static final _password = 'your_password';
  static final _db = 'your_database';

  static Future<MySqlConnection> _getConnection() async {
    return await MySqlConnection.connect(ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      password: _password,
      db: _db,
    ));
  }

  static Future<User?> getUserByEmailAndPassword(
      String email, String password) async {
    final conn = await _getConnection();
    final results = await conn.query(
        'SELECT * FROM users WHERE email = ? AND password = ?',
        [email, _hashPassword(password)]);
    await conn.close();

    if (results.isNotEmpty) {
      final row = results.first;
      return User(
        id: row['id'],
        name: row['name'],
        email: row['email'],
        password: row['password'],
      );
    }

    return null;
  }

  static Future<void> addUser(User user) async {
    final conn = await _getConnection();
    await conn.query(
        'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
        [user.name, user.email, _hashPassword(user.password)]);
    await conn.close();
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
