import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/services/api_service.dart';
import 'package:flutter_quizapp/models/Category.dart';
import 'package:go_router/go_router.dart';

class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Category>>(
        future: ApiService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data ?? [];
          if (categories.isEmpty) {
            return const Center(child: Text('No categories available'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                expandedHeight: 50,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "QuizUp",
                  style: AppTextStyles.appBarTitle.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Text('Categorías', style: AppTextStyles.bodyTitle),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        context.go(
                          '/quiz-category/${category.id}',
                          extra: {
                            'categoryName': category.name,
                            'categoryImage': category.imagePath,
                            'categoryDescription': category.description,
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          // Imagen de fondo
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(category.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Degradado inferior
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(12),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          // Texto encima
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: Text(
                              category.name,
                              style: AppTextStyles.categoriaTitleText.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: categories.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 2,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
