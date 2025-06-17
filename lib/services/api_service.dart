import 'dart:convert';
import 'dart:math';
import 'package:flutter_quizapp/config.dart';
import 'package:flutter_quizapp/models/Category.dart';
import 'package:flutter_quizapp/models/Question.dart';
import 'package:flutter_quizapp/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = API_URL;

  static Map<String, String> _authHeaders(String? token) => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  static Future<http.Response> getMe() async {
    final token = AuthService.token;
    if (token == null) throw Exception('No token, user not logged in');
    return http.get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: _authHeaders(token),
    );
  }

  static Future<List<Category>> getCategories() async {
    final endpoint = '$_baseUrl/categories';
    final response = await http.get(
      Uri.parse(endpoint),
      headers: _authHeaders(AuthService.token),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar categorías');
    }
  }

  static Future<List<Question>> getQuestions(String categoryId) async {
    final token = AuthService.token;
    final random = Random();
    final Set<int> randomPages = {};

    // Elige 3 páginas distintas aleatorias entre 1 y 10
    while (randomPages.length < 3) {
      randomPages.add(random.nextInt(10) + 1);
    }

    List<Question> allQuestions = [];

    for (int page in randomPages) {
      final uri = Uri.parse('$_baseUrl/categories/preguntas').replace(
        queryParameters: {
          'category': categoryId,
          'limit': '10',
          'page': '$page',
        },
      );

      final response = await http.get(uri, headers: _authHeaders(token));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List list = json['questions'];
        allQuestions.addAll(list.map((q) => Question.fromJson(q)));
      }
    }

    allQuestions.shuffle(); // Mezcla
    return allQuestions.take(10).toList(); // Toma 10 aleatorias
  }

  static Future<http.Response> submitQuiz(Map<String, dynamic> quizData) async {
    final token = AuthService.token;
    if (token == null) throw Exception('No token, user not logged in');
    return http.post(
      Uri.parse('$_baseUrl/quiz/submit'),
      headers: _authHeaders(token),
      body: jsonEncode(quizData),
    );
  }
}
