import 'dart:convert';
import 'package:flutter_application_1/modal.dart';
import 'package:http/http.dart' as http;


class ApiService {
  final String _baseUrl = 'https://newsapi.org/v2/everything?q=india&apiKey=32989183dd9f466b9ddb255f1aa4efed';

  Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['articles'];
      return data.map((article) => News.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
