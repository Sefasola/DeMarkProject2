import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './login/loginProvider.dart';
import 'home_screen.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginStatus(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
