import 'dart:convert';

import 'package:http/http.dart' as http;

String urlMain = '192.168.1.194';

Future<void> sendLikeStatus(int userId, int commentId, int likeStatus) async {
  final response = await http.post(
    Uri.parse('http://${urlMain}/project/sendLikeStatus.php'),
    body: {
      'comment_id': commentId.toString(),
      'user_id': userId.toString(),
      'like_situation': likeStatus.toString(),
    },
  );
  if (response.statusCode == 200) {
    print('Like status updated successfully');
  } else {
    print('Failed to update like status');
  }
}

Future<void> sendLikeStatusVoid() async {
  int userId = 2;
  int commentId = 16;
  int likeStatusInt = 0;
  final response = await http.post(
    Uri.parse('http://${urlMain}/project/sendLikeStatus.php'),
    body: {
      'comment_id': commentId.toString(),
      'user_id': userId.toString(),
      'like_situation': likeStatusInt.toString(),
    },
  );
  if (response.statusCode == 200) {
    print('Like status updated successfully');
  } else {
    print('Failed to update like status');
  }
}

Future<bool> fetchLikeSituation(int userId, int commentId) async {
  final response = await http.post(
    Uri.parse('http://${urlMain}/project/getLikeInfo.php'),
    body: {
      'comment_id': commentId.toString(),
      'user_id': userId.toString(),
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print(response.body);
    final likeSituation = data['like_situation'];

    if (likeSituation == '1') {
      return true;
    }
    if (likeSituation == '0') {
      return false;
    }
  }
  return false;
}

Future<int> fetchLikeCount(String commentId) async {
  final response = await http.post(
    Uri.parse('http://${urlMain}/project/likeCount.php'),
    body: {'comment_id': commentId},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final likeCount = data['like_count'];

    if (likeCount != null) {
      return int.parse(likeCount.toString());
    }
  }

  return 0;
}

Future<List<Map<String, dynamic>>> fetchLikedUsers(String commentId) async {
  final response = await http.post(
    Uri.parse('http://${urlMain}/project/fetchLikedUsers.php'),
    body: {'comment_id': commentId},
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    final List<Map<String, dynamic>> likedUsers = [];

    for (var user in jsonData) {
      likedUsers.add({
        'level': user['level'],
        'user_id': user['user_id'],
        'user_name': user['user_name'],
      });
    }
    print(response.body);
    return likedUsers;
  } else {
    throw Exception('Failed to fetch liked users');
  }
}
