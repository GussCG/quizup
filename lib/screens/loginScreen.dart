import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_colors.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/mainButton.dart';
import 'package:flutter_quizapp/services/auth_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FormGroup form = FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(validators: [Validators.required]),
  });

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submit(BuildContext context) async {
    if (form.valid) {
      final email = form.control('email').value;
      final password = form.control('password').value;

      final success = await AuthService.login(email, password);

      if (success) {
        context.go('/profile');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Credenciales incorrectas')));
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
          padding: const EdgeInsets.all(16.0),
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
                            'Iniciar Sesión',
                            style: AppTextStyles.bodyTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Email
                  ReactiveTextField<String>(
                    formControlName: 'email',
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: AppColors.formBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
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
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    style: AppTextStyles.formLabelText,
                    validationMessages: {
                      ValidationMessage.required:
                          (_) => 'La contraseña es obligatoria',
                    },
                  ),
                  SizedBox(height: 36),
                  Mainbutton(
                    text: 'Iniciar',
                    onPressed: () => _submit(context),
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
