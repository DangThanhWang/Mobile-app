import 'package:app/helpers/QuizManager.dart';
import 'package:flutter/material.dart';

class VocabularyQuiz extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _VocabularyQuizState createState() => _VocabularyQuizState();
}

class _VocabularyQuizState extends State<VocabularyQuiz> {
  late QuizManager quizManager;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "She ___ going to the market.",
      "options": ["is", "are", "was", "were"],
      "answer": "is"
    },
    {
      "question": "They ___ playing soccer.",
      "options": ["is", "are", "was", "were"],
      "answer": "are"
    },
    {
      "question": "I ___ very happy yesterday.",
      "options": ["am", "is", "was", "are"],
      "answer": "was"
    },
  ];

  @override
  void initState() {
    super.initState();
    quizManager = QuizManager(context: context, questions: questions);
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[quizManager.currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Ngữ pháp"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Câu hỏi ${quizManager.currentQuestionIndex + 1}/${questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion["question"],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: currentQuestion["options"].map<Widget>((option) {
                return ElevatedButton(
                  onPressed: (quizManager.hasAnswered ||
                          quizManager.isCompleted ||
                          quizManager.isRetrying)
                      ? null
                      : () {
                          setState(() {
                            quizManager.checkAnswer(option, () {
                              setState(() {});
                            });
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor:
                        quizManager.hasAnswered || quizManager.isCompleted
                            ? Colors.grey
                            : Colors.orangeAccent,
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
