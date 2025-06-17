import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/mainButton.dart';
import 'package:flutter_quizapp/services/api_service.dart';
import 'package:flutter_quizapp/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_quizapp/models/Category.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<dynamic> _userQuizzes = [];
  bool _isLoading = true;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _getCategories(); // Cargar categorías primero
    await _fetchUserQuizzes(); // Luego los quizzes
  }

  Future<void> _fetchUserQuizzes() async {
    try {
      final quizzes = await ApiService.getQuizzesByUser(
        AuthService.currentUser?.id ?? '',
      );
      setState(() {
        _userQuizzes = quizzes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los quizzes: $e')),
      );
    }
  }

  Future<void> _getCategories() async {
    try {
      final categories = await ApiService.getCategories();
      print('Categorías obtenidas: $categories');
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las categorías: $e')),
      );
    }
  }

  void _goToEditName() {
    context.go('/edit-name'); // Redirige a la pantalla de edición de nombre
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final displayName = AuthService.displayName;
    final email = user?.email ?? 'No email';
    DateTime? createdAtDate = DateTime.tryParse(user?.createdAt ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text("QuizUp", style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body:
          user == null
              ? Center(child: Text('No ha iniciado Sesión'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          AssetImage('assets/default_user.png')
                              as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName ?? 'No Username',
                          style: AppTextStyles.profileNameText,
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 22),
                          onPressed: _goToEditName,
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
                    const SizedBox(height: 20),
                    Mainbutton(
                      onPressed: () async {
                        await AuthService.logout();
                        context.go('/'); // Redirige a la pantalla de login
                      },
                      text: 'Cerrar Sesión',
                    ),
                    const Divider(
                      height: 40,
                      thickness: 5,
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Text(
                      'Quizzes Realizados',
                      style: AppTextStyles.bodyTitle.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),

                    // Aquí mostramos la lista de quizzes o un loader
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _userQuizzes.isEmpty
                        ? const Expanded(
                          child: Center(
                            child: Text(
                              'No has realizado ningún quiz aún.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                        : Expanded(
                          child: ListView.builder(
                            itemCount: _userQuizzes.length,
                            itemBuilder: (context, index) {
                              final quiz = _userQuizzes[index];
                              final createdAt =
                                  quiz['created_at'] != null
                                      ? DateTime.parse(quiz['created_at'])
                                      : null;

                              // Busca la categoría que corresponde al quiz (suponiendo que el campo es category_id)
                              final categoryId = quiz['categoria'];
                              final category = _categories.firstWhere(
                                (cat) =>
                                    cat.id.toString().trim().toLowerCase() ==
                                    categoryId.toString().trim().toLowerCase(),
                                orElse:
                                    () => Category(
                                      id: 'unknown',
                                      name: 'Desconocida',
                                      imagePath:
                                          'assets/category/defaultCategory.jpg',
                                      description: 'Sin descripción',
                                    ),
                              );

                              final categoryImage =
                                  category.imagePath.isNotEmpty
                                      ? category.imagePath
                                      : 'assets/default_category.png';
                              final categoryName = category.name;

                              return Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        categoryImage,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            categoryName,
                                            style: AppTextStyles.bodyTitle
                                                .copyWith(fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          if (createdAt != null)
                                            Text(
                                              '${DateFormat('dd-MM-yyyy').format(createdAt)} · ${timeago.format(createdAt)}',
                                              style: AppTextStyles.bodyText
                                                  .copyWith(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade600,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${quiz['score'] ?? 0} / ${quiz['total_questions'] ?? 0}',
                                      style: AppTextStyles.bodyText.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  ],
                ),
              ),
    );
  }
}
