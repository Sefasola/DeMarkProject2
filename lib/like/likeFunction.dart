import 'dart:convert';

import 'package:http/http.dart' as http;
String urlMain = '10.32.0.196';

Future<void> sendLikeStatus(
    int userId, int commentId, bool likeStatus) async {
  final response = await http.post(
    Uri.parse('http://${urlMain}/project/sendLikeStatus.php'),
    body: {
      'comment_id': commentId.toString(),
      'user_id': userId.toString(),
      'like_status': likeStatus.toString(),
    },
  );
  if (response.statusCode == 200) {
    print('Like status updated successfully');
  } else {
    print('Failed to update like status');
  }
}
Future<void> sendLikeStatusVoid() async {
  int commentId = 17;
  int userId = 1;
  bool likeStatus = false;
  final response = await http.post(
    Uri.parse('http://${urlMain}/project/sendLikeStatus.php'),
    body: {
      'comment_id': commentId.toString(),
      'user_id': userId.toString(),
      'like_status': likeStatus.toString(),
    },
  );

  if (response.statusCode == 200) {
    print('Like status updated successfully');
  } else {
    print('Failed to update like status');
  }
}
