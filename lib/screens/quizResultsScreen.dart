import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/mainButton.dart';
import 'package:go_router/go_router.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  final String categoryDescription;
  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    this.categoryDescription = 'No description available',
  });

  String _getMessage() {
    final percent = (score / totalQuestions) * 100;
    if (percent >= 90) {
      return '¡Excelente trabajo!';
    } else if (percent >= 75) {
      return 'Buen trabajo, sigue así!';
    } else if (percent >= 50) {
      return 'Puedes mejorar, ¡inténtalo de nuevo!';
    } else {
      return 'No te desanimes, ¡practica más!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final incorrect = totalQuestions - score;

    return Scaffold(
      appBar: AppBar(
        title: Text("QuizUp", style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                categoryImage,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Text(
            //   'Resultados',
            //   style: AppTextStyles.bodyMainTitleText.copyWith(fontSize: 28),
            //   textAlign: TextAlign.center,
            // ),
            // const SizedBox(height: 8),
            Text(
              _getMessage(),
              style: AppTextStyles.bodyTitle.copyWith(
                fontSize: 24,
                color: const Color.fromARGB(255, 0, 39, 97),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Text(
              'Has completado el cuestionario de $categoryName. Echa un vistazo a tus resultados a continuación.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(
                fontSize: 17,
                color: Colors.grey.shade700,
              ),
            ),
            Divider(color: Colors.grey.shade300, thickness: 5, height: 40),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puntuación',
                    style: AppTextStyles.bodyTitle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: const Color.fromARGB(255, 100, 100, 100),
                    ),
                  ),
                  Text(
                    '$score / $totalQuestions',
                    style: AppTextStyles.bodyText.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreBar(
                  label: 'Correctas',
                  value: score,
                  total: totalQuestions,
                  color: Colors.green,
                ),
                _buildScoreBar(
                  label: 'Incorrectas',
                  value: incorrect,
                  total: totalQuestions,
                  color: Colors.red,
                ),
              ],
            ),
            const Spacer(),

            Mainbutton(
              text: 'Intentarlo Otra Vez',
              onPressed: () {
                context.go(
                  '/quiz-category/${categoryId}',
                  extra: {
                    'categoryName': categoryName,
                    'categoryImage': categoryImage,
                    'categoryDescription': categoryDescription,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar({
    required String label,
    required int value,
    required int total,
    required Color color,
  }) {
    final percent = total > 0 ? value / total : 0.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText.copyWith(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomCenter, // Alinea el progreso abajo
          children: [
            Container(
              width: 20,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 20,
              height: 100 * percent, // Escala en altura
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$value / $total',
          style: AppTextStyles.bodyText.copyWith(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
