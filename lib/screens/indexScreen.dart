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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'QuizUp',
              style: AppTextStyles.bodyMainTitleText as TextStyle?,
            ),
            SizedBox(height: 42),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ), // o EdgeInsets.all()
              child: Text(
                "Prueba tus conocimientos y diviértete desafiando a tus amigos en una variedad emocionante de quizzes. Aprende y diviértete.",
                style: AppTextStyles.bodyText,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 54),
            if (user != null) ...[
              Mainbutton(
                text: 'Ver Quizzes',
                onPressed: () {
                  context.go('/quizzes'); // Redirige a la pantalla de quizzes
                },
              ),
            ] else ...[
              Mainbutton(
                text: "Iniciar Sesión",
                onPressed: () => {context.go('/login')},
              ),
              SizedBox(height: 12),
              AltButton(
                text: "Registrarse",
                onPressed: () => {context.go('/signup')},
              ),
            ],
          ],
        ),
      ),
    );
  }
}
