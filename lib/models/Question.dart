class Question {
  final String id;
  final String categoryId;
  final String format;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  Question({
    required this.id,
    required this.categoryId,
    required this.format,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  List<String> get allShuffledAnswers {
    final allAnswers = [...incorrectAnswers, correctAnswer];
    allAnswers.shuffle();
    return allAnswers;
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      categoryId: json['category'] as String,
      format: json['format'] as String,
      question: json['question'] as String,
      correctAnswer: json['correctAnswers'] as String,
      incorrectAnswers: List<String>.from(
        json['incorrectAnswers'] as List<dynamic>,
      ),
    );
  }
}
