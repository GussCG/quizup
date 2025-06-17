import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_quizapp/core/theme/app_text_styles.dart';
import 'package:flutter_quizapp/core/widgets/mainButton.dart';
import 'package:flutter_quizapp/models/Question.dart';
import 'package:flutter_quizapp/services/api_service.dart';
import 'package:go_router/go_router.dart';

class QuizQuestionScreen extends StatefulWidget {
  final String? categoryId;
  final Map<String, dynamic>? extra;
  const QuizQuestionScreen({super.key, required this.categoryId, this.extra});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;
  bool isAnswered = false;
  String? selectedAnswer;
  List<String> shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _handleSubmit(context);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuestions(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions(BuildContext context) async {
    if (widget.categoryId == null) return;
    try {
      final fetchedQuestions = await ApiService.getQuestions(
        widget.categoryId!,
      );
      setState(() {
        questions = fetchedQuestions;
        isLoading = false;
      });
      _setShuffledOptions();
      _startTimer();
    } catch (e, stackTrace) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error en _loadQuestions: $e');
      debugPrint('StackTrace: $stackTrace');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar preguntas: $e')));
    }
  }

  void _setShuffledOptions() {
    final currentQuestion = questions[currentQuestionIndex];
    shuffledOptions = [
      ...currentQuestion.incorrectAnswers,
      currentQuestion.correctAnswer,
    ];
    shuffledOptions.shuffle();
  }

  void _startTimer() {
    _controller.reset();
    _controller.forward();
  }

  void _handleSubmit(BuildContext context) {
    _controller.stop();

    final currentQuestion = questions[currentQuestionIndex];
    final correctAnswer = currentQuestion.correctAnswer;

    if (selectedAnswer == correctAnswer) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
      });
      _setShuffledOptions();
      _startTimer();
    } else {
      context.go(
        '/quiz-results',
        extra: {
          'score': score,
          'total': questions.length,
          'categoryId': widget.categoryId,
          'categoryName': widget.extra?['categoryName'] ?? 'Categoría',
          'categoryImage':
              widget.extra?['categoryImage'] ??
              'assets/category/defaultCategory.jpg',
          'categoryDescription': widget.extra?['categoryDescription'] ?? '',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("QuizUp", style: AppTextStyles.appBarTitle),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go(
                '/quiz-category/${widget.categoryId}',
                extra: {
                  'categoryName': widget.extra?['categoryName'] ?? 'Categoría',
                  'categoryImage':
                      widget.extra?['categoryImage'] ??
                      'assets/category/defaultCategory.jpg',
                  'categoryDescription':
                      widget.extra?['categoryDescription'] ??
                      'No description available',
                },
              );
            },
          ),
        ),
        body: const Center(child: Text('No hay preguntas disponibles')),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final options = shuffledOptions;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pregunta ${currentQuestionIndex + 1} de ${questions.length}',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: 1.0 - _controller.value,
                  color: Colors.blue,
                  backgroundColor: Colors.grey.shade300,
                  minHeight: 8,
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              currentQuestion.question,
              style: AppTextStyles.bodyTitle.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (currentQuestion.format == 'multiple')
              _buildOptionsGrid(options)
            else
              _buildOptionsColumn(options),
            Mainbutton(
              onPressed: () {
                if (selectedAnswer == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, selecciona una respuesta'),
                    ),
                  );
                } else {
                  setState(() {
                    isAnswered = true;
                  });
                  _handleSubmit(context);
                }
              },
              text: isAnswered ? 'Siguiente' : 'Enviar Respuesta',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(List<String> options) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
        children:
            options.map((option) {
              final isSelected = option == selectedAnswer;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAnswer = option;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color.fromARGB(255, 44, 73, 124)
                            : const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color.fromARGB(255, 44, 73, 124)
                              : const Color.fromARGB(255, 203, 203, 203),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      option,
                      style: AppTextStyles.bodyText.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildOptionsColumn(List<String> options) {
    return Expanded(
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedAnswer;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAnswer = option;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  option,
                  style: AppTextStyles.bodyText.copyWith(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
