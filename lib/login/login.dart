import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project2/home_screen.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String urlMain = '192.168.0.19';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoggedIn = false;

  Future<List<Map<String, dynamic>>> login(
      String username, String password) async {
    final url = 'http://${urlMain}/project/logincheck.php';
    final response = await http.post(Uri.parse(url), body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print("successfully logged in");
      isLoggedIn = true;
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                var result = await login(
                    usernameController.text, passwordController.text);
                if (isLoggedIn == true) {
                  Navigator.of(context).pop(isLoggedIn);
                } else {
                  print("failed");
                }
                //Map<String, dynamic> firstElement = result[0];
                //String existedName = firstElement['User_name'];
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
