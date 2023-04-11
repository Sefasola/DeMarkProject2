import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class deneme extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.194/login/login2.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Data Example'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text(item['username']),
                  subtitle: Text(item['level']),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
