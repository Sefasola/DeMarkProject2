import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project2/home_screen.dart';
import 'package:provider/provider.dart';
import 'loginStatus.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late String nameL;
  late String userId;
  late String level;
  final String urlMain = '192.168.1.194';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<bool> login(String username, String password) async {
    final url = 'http://${urlMain}/project/logincheck.php';
    final response = await http.post(Uri.parse(url), body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      nameL = data[0]['User_name'];
      userId = data[0]['User_ID'];
      level = data[0]['Level'];
      if (data.isNotEmpty) {
        print('Successfully logged in');
        return true;
      }
    }
    print('Failed to login');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                final bool loginSuccess = await login(
                    usernameController.text, passwordController.text);
                print(nameL);
                if (loginSuccess) {
                  Provider.of<LoginStatus>(context, listen: false)
                      .toggleLogStatus();
                  Provider.of<LoginStatus>(context, listen: false)
                      .updateUser(int.parse(userId), nameL, level);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (isLoggedIn) => HomeScreen()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Incorrect username or password'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
