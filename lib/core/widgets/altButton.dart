import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_colors.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';

class AltButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AltButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: AppColors.buttonAltBackground,
        minimumSize: Size(358, 50),
      ),
      onPressed: onPressed,
      child: Text(text, style: AppTextStyles.buttonText as TextStyle?),
    );
  }
}
