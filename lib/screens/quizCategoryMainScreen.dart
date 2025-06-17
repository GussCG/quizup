import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/startQuizButton.dart';
import 'package:go_router/go_router.dart';

class QuizCategoryMainScreen extends StatelessWidget {
  final String? categoryId;
  final String? categoryName;
  final String? categoryImage;
  final String? categoryDescription;

  const QuizCategoryMainScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.categoryDescription = 'No description available',
  });

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    final name = extra?['categoryName'] ?? categoryName ?? 'Unknown Category';
    final image =
        extra?['categoryImage'] ??
        categoryImage ??
        'assets/category/defaultCategory.jpg';
    final description =
        extra?['categoryDescription'] ??
        categoryDescription ??
        'No description available';

    final List<Map<String, dynamic>> topRanking = [
      {'name': 'User1', 'score': 100},
      {'name': 'User2', 'score': 90},
      {'name': 'User3', 'score': 80},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("QuizUp", style: AppTextStyles.appBarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/quizzes');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text('$name', style: AppTextStyles.bodyTitle),
            Text(
              '$description',
              style: AppTextStyles.bodyText,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300, thickness: 5),
            Text('Top Rankings', style: AppTextStyles.bodyTitle),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: topRanking.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final rank = index + 1;
                  final item = topRanking[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        '$rank',
                        style: AppTextStyles.rankingNumberText,
                      ),
                    ),
                    title: Text(
                      item['name'],
                      style: AppTextStyles.rankingNameText,
                    ),
                    trailing: Text(
                      '${item['score']} pts',
                      style: AppTextStyles.bodyText,
                    ),
                  );
                },
              ),
            ),
            Center(
              child: SizedBox(
                width: 350,
                child: StartQuizButton(
                  text: 'Empezar Quiz',
                  onPressed: () {
                    context.go(
                      '/quiz-question/${Uri.encodeComponent(categoryId ?? '')}',
                      extra: {
                        'categoryName': name,
                        'categoryImage': image,
                        'categoryDescription': description,
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
