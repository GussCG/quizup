import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_colors.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/mainButton.dart';
import 'package:flutter_quizapp/services/auth_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_router/go_router.dart';

class EditNameScreen extends StatelessWidget {
  EditNameScreen({super.key});

  final FormGroup form = FormGroup({
    'username': FormControl<String>(
      validators: [Validators.required, Validators.minLength(3)],
    ),
  });

  void _submit(BuildContext context) async {
    if (form.valid) {
      try {
        final username = form.control('username').value;

        final success = await AuthService.updateDisplayName(username);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nombre de usuario actualizado')),
          );
          // Redirigir al perfil o a otra pantalla
          context.go('/profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar el nombre de usuario')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } else {
      form.markAllAsTouched();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, completa el formulario correctamente'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuizUp", style: AppTextStyles.appBarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/profile'); // Redirige a la pantalla de perfil
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ReactiveForm(
            formGroup: form,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Cambiar Nombre de Usuario',
                            style: AppTextStyles.bodyTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Username
                  ReactiveTextField<String>(
                    formControlName: 'username',
                    decoration: InputDecoration(
                      hintText: 'Nuevo nombre de usuario',
                      filled: true,
                      fillColor: AppColors.formBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: AppTextStyles.formLabelText,
                    validationMessages: {
                      ValidationMessage.required:
                          (_) => 'El nombre de usuario es obligatorio',
                      ValidationMessage.minLength:
                          (_) =>
                              'El nombre de usuario debe tener al menos 3 caracteres',
                    },
                  ),

                  SizedBox(height: 36),
                  Mainbutton(
                    text: 'Editar',
                    onPressed: () {
                      _submit(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
