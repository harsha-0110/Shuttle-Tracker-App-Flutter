import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shuttle_tracker/models/shuttle_model.dart';

class ShuttleApi {
  static const baseUrl = 'Backend-Server-URL';

  static Future<List<Shuttle>> fetchShuttleData() async {
    final response = await http.get(Uri.parse('$baseUrl/shuttle'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Shuttle> shuttles =
          jsonData.map((data) => Shuttle.fromJson(data)).toList();
      return shuttles;
    } else {
      throw Exception('Failed to load shuttle data');
    }
  }
}
