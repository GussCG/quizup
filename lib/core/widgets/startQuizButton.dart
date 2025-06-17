import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';

class StartQuizButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const StartQuizButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color.fromARGB(255, 60, 80, 128),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Text(text, style: AppTextStyles.startButtonText),
    );
  }
}
