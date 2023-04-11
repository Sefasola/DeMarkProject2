import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<MySqlConnection> _getConnection() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'your_host',
      port: 3306,
      user: 'your_username',
      password: 'your_password',
      db: 'your_database',
    ));
    return conn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
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
                          _isLoading = true;
                        });

                        final name = _nameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (name.isEmpty || email.isEmpty || password.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please fill in all fields',
                            gravity: ToastGravity.BOTTOM,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }

                        MySqlConnection conn;
                        try {
                          conn = await _getConnection();
                          await conn.query(
                            'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
                            [name, email, password],
                          );

                          Fluttertoast.showToast(
                            msg: 'Registration successful',
                            gravity: ToastGravity.BOTTOM,
                          );

                          Navigator.of(context).pop();
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: 'An error occurred while registering',
                            gravity: ToastGravity.BOTTOM,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: Text('Register'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
