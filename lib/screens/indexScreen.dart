import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/mainButton.dart';
import 'package:flutter_quizapp/core/widgets/altButton.dart';
import 'package:flutter_quizapp/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Center(
          // Centrado vertical y horizontal
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: SingleChildScrollView(
              // Scroll solo si realmente se necesita
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', width: 270),
                  const SizedBox(height: 42),
                  Text(
                    "Prueba tus conocimientos y diviértete desafiando a tus amigos en una variedad emocionante de quizzes. Aprende y diviértete.",
                    style: AppTextStyles.bodyText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 54),
                  if (user != null) ...[
                    Mainbutton(
                      text: 'Ver Quizzes',
                      onPressed: () {
                        context.go('/quizzes');
                      },
                    ),
                  ] else ...[
                    Mainbutton(
                      text: "Iniciar Sesión",
                      onPressed: () => context.go('/login'),
                    ),
                    const SizedBox(height: 12),
                    AltButton(
                      text: "Registrarse",
                      onPressed: () => context.go('/signup'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
