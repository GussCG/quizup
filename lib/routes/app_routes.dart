import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/widgets/BottomNavBar.dart';
import 'package:flutter_quizapp/screens/editNameScreen.dart';
import 'package:flutter_quizapp/screens/profileScreen.dart';
import 'package:flutter_quizapp/screens/indexScreen.dart';
import 'package:flutter_quizapp/screens/quizCategoryMainScreen.dart';
import 'package:flutter_quizapp/screens/quizQuestionScreen.dart';
import 'package:flutter_quizapp/screens/quizResultsScreen.dart';
import 'package:flutter_quizapp/screens/quizzesScreen.dart';
import 'package:flutter_quizapp/screens/loginScreen.dart';
import 'package:flutter_quizapp/screens/signUpScreen.dart';
import 'package:flutter_quizapp/services/auth_service.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = AuthService.isLoggedIn;
    final unauthenticatedRoutes = ['/login', '/signup'];
    final protectedRoutes = [
      '/quiz-question/:categoryId',
      '/profile',
      '/edit-name',
    ];

    if (!isLoggedIn &&
        protectedRoutes.any((path) => state.fullPath!.startsWith(path))) {
      return '/login';
    }

    if (isLoggedIn && unauthenticatedRoutes.contains(state.fullPath)) {
      return '/'; // ya logueado, no tiene sentido ir a login
    }

    return null;
  },
  routes: [
    // Rutas fuera del BottomNavigationBar
    GoRoute(
      path: '/quiz-question/:categoryId',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId'];
        final extra = state.extra as Map<String, dynamic>?;

        return QuizQuestionScreen(categoryId: categoryId, extra: extra);
      },
    ),
    GoRoute(
      path: '/quiz-results',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return QuizResultScreen(
          score: extra['score'] ?? 0,
          totalQuestions: extra['total'] ?? 0,
          categoryId: extra['categoryId'] ?? '',
          categoryName: extra['categoryName'] ?? 'Categoría',
          categoryImage:
              extra['categoryImage'] ?? 'assets/category/defaultCategory.jpg',
          categoryDescription:
              extra['categoryDescription'] ?? 'No description available',
        );
      },
    ),
    GoRoute(
      path: '/quiz-category/:categoryId',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId'];
        return QuizCategoryMainScreen(categoryId: categoryId);
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        // Determina el índice actual según la ruta
        int currentIndex = switch (state.fullPath) {
          '/' => 0,
          '/quizzes' => 1,
          '/profile' => 2,
          _ => 0,
        };

        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            onTap: (i) {
              final destinations = ['/', '/quizzes', '/profile'];
              context.go(destinations[i]); // ← navegación declarativa
            },
          ),
        );
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => IndexScreen()),
        GoRoute(path: '/quizzes', builder: (context, state) => QuizzesScreen()),
        GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),

        GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
        GoRoute(path: '/signup', builder: (context, state) => SignUpScreen()),
        GoRoute(
          path: '/edit-name',
          builder: (context, state) => EditNameScreen(),
        ),
      ],
    ),
  ],
);
