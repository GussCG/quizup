import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_colors.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/mainButton.dart';
import 'package:flutter_quizapp/services/auth_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FormGroup form = FormGroup(
    {
      'username': FormControl<String>(
        validators: [Validators.required, Validators.minLength(3)],
      ),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
      'confirmPassword': FormControl<String>(validators: [Validators.required]),
    },
    validators: [Validators.mustMatch('password', 'confirmPassword')],
  );

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _submit(BuildContext context) async {
    if (form.valid) {
      try {
        final username = form.control('username').value;
        final email = form.control('email').value;
        final password = form.control('password').value;

        final success = await AuthService.register(email, password, username);

        if (success) {
          context.go('/login');
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al registrarse')));
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
            context.go('/'); // Redirige a la pantalla de inicio
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
                            'Registrarse',
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
                      hintText: 'Nombre de usuario',
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
                  SizedBox(height: 16),

                  // Email
                  ReactiveTextField<String>(
                    formControlName: 'email',
                    decoration: InputDecoration(
                      hintText: 'Email',
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
                          (_) => 'El email es obligatorio',
                      ValidationMessage.email: (_) => 'El email no es válido',
                    },
                  ),
                  SizedBox(height: 16),

                  // Password
                  ReactiveTextField<String>(
                    formControlName: 'password',
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    style: AppTextStyles.formLabelText,
                    validationMessages: {
                      ValidationMessage.required:
                          (_) => 'La contraseña es obligatoria',
                      ValidationMessage.minLength:
                          (_) =>
                              'La contraseña debe tener al menos 6 caracteres',
                    },
                  ),
                  SizedBox(height: 16),

                  // Confirm Password
                  ReactiveTextField<String>(
                    formControlName: 'confirmPassword',
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirmar contraseña',
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
                      ),
                    ),
                    style: AppTextStyles.formLabelText,
                    validationMessages: {
                      ValidationMessage.required:
                          (_) => 'La confirmación de contraseña es obligatoria',
                      ValidationMessage.mustMatch:
                          (_) => 'Las contraseñas no coinciden',
                    },
                  ),

                  SizedBox(height: 36),
                  Mainbutton(
                    text: 'Registrarse',
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
