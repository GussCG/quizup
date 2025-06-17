import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_colors.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedItemColor: AppColors.navBarIconSelected,
      unselectedItemColor: AppColors.navBarIconUnselected,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedLabelStyle: AppTextStyles.navBarIconSelectedText,
      unselectedLabelStyle: AppTextStyles.navBarIconUnselectedText,
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 20),
      items: [
        BottomNavigationBarItem(
          icon: _buildAnimatedNavItem(
            FontAwesomeIcons.house,
            'Inicio',
            isSelected: widget.currentIndex == 0,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildAnimatedNavItem(
            FontAwesomeIcons.question,
            'Quizzes',
            isSelected: widget.currentIndex == 1,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildAnimatedNavItem(
            FontAwesomeIcons.user,
            'Perfil',
            isSelected: widget.currentIndex == 2,
          ),
          label: '',
        ),
      ],
    );
  }

  Widget _buildAnimatedNavItem(
    IconData icon,
    String label, {
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: isSelected ? 16 : 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppColors.navBarIconSelected.withOpacity(0.2)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: FaIcon(
              icon,
              key: ValueKey(icon),
              color:
                  isSelected
                      ? AppColors.navBarIconSelected
                      : AppColors.navBarIconUnselected,
              size: isSelected ? 20 : 18,
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState:
                isSelected
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.navBarIconSelectedText,
                child: Text(label),
              ),
            ),
            secondChild: const SizedBox(width: 0),
          ),
        ],
      ),
    );
  }
}
