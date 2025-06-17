import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/startQuizButton.dart';
import 'package:flutter_quizapp/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class QuizCategoryMainScreen extends StatefulWidget {
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
  State<QuizCategoryMainScreen> createState() => _QuizCategoryMainScreenState();
}

class _QuizCategoryMainScreenState extends State<QuizCategoryMainScreen> {
  List<dynamic> _topRanking = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopRanking();
  }

  Future<void> _fetchTopRanking() async {
    try {
      final ranking = await ApiService.getRankingByCategory(widget.categoryId!);
      setState(() {
        _topRanking = ranking;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    final name =
        extra?['categoryName'] ?? widget.categoryName ?? 'Unknown Category';
    final image =
        extra?['categoryImage'] ??
        widget.categoryImage ??
        'assets/category/defaultCategory.jpg';
    final description =
        extra?['categoryDescription'] ??
        widget.categoryDescription ??
        'No description available';

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
            Expanded(
              child: ListView(
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
                  Text(name, style: AppTextStyles.bodyTitle),
                  Text(
                    description,
                    style: AppTextStyles.bodyText,
                    textAlign: TextAlign.left,
                    maxLines: null,
                  ),
                  const SizedBox(height: 8),
                  Divider(color: Colors.grey.shade300, thickness: 5),
                  Text('Top Rankings', style: AppTextStyles.bodyTitle),
                  const SizedBox(height: 8),

                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_topRanking.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'Nada por aquí aún. Sé el primero en jugar y liderar el ranking.',
                        style: AppTextStyles.bodyText,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _topRanking.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final rank = index + 1;
                        final item = _topRanking[index];

                        Color getMedalColor(int rank) {
                          switch (rank) {
                            case 1:
                              return Color.fromARGB(
                                255,
                                255,
                                217,
                                0,
                              ); // Oro (Gold)
                            case 2:
                              return Color.fromARGB(
                                255,
                                189,
                                189,
                                189,
                              ); // Plata (Silver)
                            case 3:
                              return Color.fromARGB(
                                255,
                                187,
                                124,
                                62,
                              ); // Bronce (Bronze)
                            default:
                              return Colors.white; // Los demás blanco
                          }
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color:
                                Colors
                                    .grey
                                    .shade100, // Fondo claro, puedes cambiar el color
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Esquinas redondeadas
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 0,
                          ), // Separación entre tiles
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: getMedalColor(rank),
                              child: Text(
                                '$rank',
                                style: AppTextStyles.rankingNumberText,
                              ),
                            ),
                            title: Text(
                              item['user_name'] ?? 'Anónimo',
                              style: AppTextStyles.rankingNameText.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            subtitle:
                                item['answered_at'] != null
                                    ? Text(
                                      '${timeago.format(DateTime.parse(item['answered_at']))}',
                                      style: AppTextStyles.bodyText.copyWith(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                            trailing: Text(
                              '${item['score'] * 10} pts',
                              style: AppTextStyles.bodyText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Botón fijo abajo, siempre visible
            Center(
              child: SizedBox(
                width: 350,
                child: StartQuizButton(
                  text: 'Empezar Quiz',
                  onPressed: () {
                    context.go(
                      '/quiz-question/${Uri.encodeComponent(widget.categoryId ?? '')}',
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
            const SizedBox(height: 16), // un poco de espacio debajo del botón
          ],
        ),
      ),
    );
  }
}
