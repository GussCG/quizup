import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_colors.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.navBarIconSelected,
      unselectedItemColor: AppColors.navBarIconUnselected,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedLabelStyle: AppTextStyles.navBarIconSelectedText,
      unselectedLabelStyle: AppTextStyles.navBarIconUnselectedText,
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 20),
      items: [
        BottomNavigationBarItem(
          icon: _buildNavIcon(
            FontAwesomeIcons.house,
            isSelected: currentIndex == 0,
          ),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: _buildNavIcon(
            FontAwesomeIcons.question,
            isSelected: currentIndex == 1,
          ),
          label: 'Quizzes',
        ),
        BottomNavigationBarItem(
          icon: _buildNavIcon(
            FontAwesomeIcons.user,
            isSelected: currentIndex == 2,
          ),
          label: 'Perfil',
        ),
      ],
    );
  }
}

Widget _buildNavIcon(IconData icon, {required bool isSelected}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration:
            isSelected
                ? BoxDecoration(
                  color: AppColors.navBarIconSelected.withOpacity(0.2),
                  shape: BoxShape.circle,
                )
                : null,
        child: FaIcon(
          icon,
          color:
              isSelected
                  ? AppColors.navBarIconSelected
                  : AppColors.navBarIconUnselected,
          size: isSelected ? 20 : 18,
        ),
      ),
      const SizedBox(height: 4), // Gap entre ícono y texto
    ],
  );
}
