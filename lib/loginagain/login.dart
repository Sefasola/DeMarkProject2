import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  /*Future<MySqlConnection> _getConnection() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      password: 'k2t57ry3c',
      db: 'your_database',
    ));
    return conn;
  }*/

  Future<List> _login() async {
    final response = await http
        .post(Uri.parse("http://192.168.1.194/login/login.php"), body: {
      "username": _emailController.text,
      "password": _passwordController.text
    });
    var datauser = json.decode(response.body);
    if (datauser[0]['level'] == "admin") {
      print(datauser);
    }
    throw Exception('BarException');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _login();
                          _isLoading = true;
                        });

                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please fill in all fields',
                            gravity: ToastGravity.BOTTOM,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }

                        /*MySqlConnection conn;
                        try {
                          conn = await _getConnection();
                          final results = await conn.query(
                            'SELECT * FROM users WHERE email = ? AND password = ?',
                            [email, password],
                          );

                          if (results.length == 0) {
                            Fluttertoast.showToast(
                              msg: 'Invalid email or password',
                              gravity: ToastGravity.BOTTOM,
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          }

                          // Login successful
                          Navigator.of(context).pushNamed('/home');
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: 'An error occurred while logging in',
                            gravity: ToastGravity.BOTTOM,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        }*/
                      },
                      child: Text('Login'),
                    ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
