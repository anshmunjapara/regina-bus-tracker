import 'dart:convert';
import 'package:http/http.dart' as http;

class JokeService {
  static Future<String?> fetchJokeType() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:3000/random"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["jokeType"] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
