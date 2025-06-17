import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  final SupabaseClient _client = Supabase.instance.client;

  AuthService._internal();

  /// Login con email y contraseña
  static Future<bool> login(String email, String password) async {
    try {
      final response = await _instance._client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.session != null;
    } on AuthException catch (e) {
      print('Login failed: ${e.message}');
      return false;
    }
  }

  /// Registro de nuevo usuario
  static Future<bool> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      final response = await _instance._client.auth.signUp(
        email: email,
        password: password,
        data: {
          'display_name': username, // Nombre de usuario por defecto
        },
      );
      return response.user != null;
    } on AuthException catch (e) {
      print('Register failed: ${e.message}');
      return false;
    }
  }

  /// Obtener el token actual
  static String? get token =>
      _instance._client.auth.currentSession?.accessToken;

  /// Saber si hay un usuario autenticado
  static bool get isLoggedIn => _instance._client.auth.currentSession != null;

  /// Cerrar sesión
  static Future<void> logout() async {
    await _instance._client.auth.signOut();
  }

  /// Obtener el usuario actual
  static User? get currentUser => _instance._client.auth.currentUser;

  /// Obtener el Display Name del usuario actual
  static String? get displayName => currentUser?.userMetadata?['display_name'];

  /// Obtener el email del usuario actual
  static String? get email => currentUser?.email;

  /// Actualizar el nombre de usuario
  static Future<bool> updateDisplayName(String newName) async {
    try {
      final response = await _instance._client.auth.updateUser(
        UserAttributes(data: {'display_name': newName}),
      );
      return response.user != null;
    } on AuthException catch (e) {
      print('Update display name failed: ${e.message}');
      return false;
    }
  }
}
