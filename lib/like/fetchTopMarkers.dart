import 'package:http/http.dart' as http;
import 'dart:convert';

String urlMain = '10.32.0.224';
Future<List<Map<String, dynamic>>> fetchMostCommentedMarkers() async {
  final response =
      await http.post(Uri.parse('http://${urlMain}/project/getTopMarkers.php'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);

    // Create a list to store the results
    List<Map<String, dynamic>> results = [];

    // Iterate over the JSON data and add each result to the list
    for (var item in jsonData) {
      results.add(Map<String, dynamic>.from(item));
    }

    return results;
  } else {
    throw Exception('Failed to fetch most commented markers');
  }
}
