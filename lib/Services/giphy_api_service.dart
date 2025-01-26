import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GiphyApiService {
  final http.Client client;

  GiphyApiService({http.Client? client}) : client = client ?? http.Client();

  static String get _apiKey => dotenv.env['GIPHY_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.giphy.com/v1/gifs';

  Future<Map<String, dynamic>> searchGifs(
      String query, int limit, int offset) async {
    final url =
        '$_baseUrl/search?api_key=$_apiKey&q=$query&limit=$limit&offset=$offset';

    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load gifs');
    }
  }
}
