import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/mainButton.dart';
import 'package:flutter_quizapp/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _goToEditName(BuildContext context) {
    context.go('/edit-name'); // Redirige a la pantalla de edición de nombre
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final displayName = AuthService.displayName;
    final email = AuthService.currentUser?.email ?? 'No email';
    DateTime? createdAtDate = DateTime.tryParse(user?.createdAt ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text("QuizUp", style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: Center(
        child:
            user == null
                ? Text('No ha iniciado Sesión')
                : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          AssetImage('assets/default_user.png')
                              as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName ?? 'No Username',
                          style: AppTextStyles.profileNameText,
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          icon: Icon(Icons.edit, size: 22),
                          onPressed: () => _goToEditName(context),
                          tooltip: 'Editar Nombre',
                        ),
                      ],
                    ),
                    Text(
                      email,
                      style: AppTextStyles.profileEmailText.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Se unió ${createdAtDate != null ? DateFormat('dd-MM-yyyy').format(createdAtDate) : 'Fecha no disponible'}",
                      style: AppTextStyles.bodyText.copyWith(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Mainbutton(
                      onPressed: () async {
                        await AuthService.logout();
                        context.go('/'); // Redirige a la pantalla de login
                      },
                      text: 'Cerrar Sesión',
                    ),
                    Divider(
                      height: 40,
                      thickness: 5,
                      color: Colors.grey.shade400,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Text(
                      'Quizzes Realizados',
                      style: AppTextStyles.bodyTitle.copyWith(fontSize: 24),
                    ),
                  ],
                ),
      ),
    );
  }
}
