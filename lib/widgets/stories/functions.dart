import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

String urlMain = '10.32.0.224';

Future<List<dynamic>> fetchComments(int markerId) async {
  final response = await http.post(
      Uri.parse('http://${urlMain}/project/getCommentsForMarker.php'),
      body: {
        'marker_id': markerId.toString(),
      });
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to retrieve comments');
  }
}

Future<String> fetchUserName(int userId) async {
  final url = 'http://${urlMain}/project/userNameBringer.php';
  final response = await http.post(
    Uri.parse(url),
    body: {
      'userId': userId.toString(),
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['userName'];
  } else {
    throw Exception('Failed to fetch user');
  }
}

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
