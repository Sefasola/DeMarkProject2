import 'dart:convert';

import 'package:http/http.dart' as http;

Future<bool> toggleLike(int userId, int commentId) async {
  String urlMain = '192.168.1.194';
  final response = await http.post(
    Uri.parse('http://${urlMain}/project/postLike.php'),
    body: {
      'user_id': userId,
      'comment_id': commentId,
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final status = responseData['status'];
    final message = responseData['message'];

    if (status == 'success') {
      print(message);
      return true; // Like/unlike operation successful
    } else {
      print('Error: $message');
      return false; // Like/unlike operation failed
    }
  } else {
    print('HTTP request failed with status: ${response.statusCode}');
    return false; // HTTP request failed
  }
}
