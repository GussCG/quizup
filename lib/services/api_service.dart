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

    // Solo páginas 1 a 3
    while (randomPages.length < 3) {
      randomPages.add(random.nextInt(3) + 1);
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

    allQuestions.shuffle();
    return allQuestions.take(10).toList(); // Devuelve solo 10 aleatorias
  }

  static Future<http.Response> submitQuizResult(
    Map<String, dynamic> quizResultData,
  ) async {
    final token = AuthService.token;
    if (token == null) throw Exception('No token, user not logged in');
    print('Submitting quiz result: $quizResultData');
    return http.post(
      Uri.parse('$_baseUrl/quiz/submit/result'),
      headers: _authHeaders(token),
      body: jsonEncode(quizResultData),
    );
  }

  static Future<http.Response> submitUserAnswers(
    String resultId,
    List<Map<String, dynamic>> answers,
  ) async {
    final token = AuthService.token;
    if (token == null) throw Exception('No token, user not logged in');
    return http.post(
      Uri.parse('$_baseUrl/quiz/submit/answers?result_id=$resultId'),
      headers: _authHeaders(token),
      body: jsonEncode(answers),
    );
  }

  static Future<List<dynamic>> getRankingByCategory(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/ranking/$category'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener ranking');
    }
  }

  static Future<List<dynamic>> getQuizzesByUser(String userId) async {
    final token = AuthService.token;
    if (token == null) throw Exception('No token, user not logged in');

    print('Fetching quizzes for user: $userId');

    final uri = Uri.parse(
      '$_baseUrl/quiz/me',
    ).replace(queryParameters: {'user_id': userId});

    final response = await http.get(uri, headers: _authHeaders(token));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Mapea según tu modelo si quieres
    } else {
      throw Exception('Error al obtener quizzes del usuario');
    }
  }
}
