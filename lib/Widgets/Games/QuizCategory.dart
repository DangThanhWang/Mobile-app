import 'package:flutter/material.dart';
import 'package:app/Widgets/Games/Widget_Game/IdiomsQuiz.dart';
import 'package:app/Widgets/Games/Widget_Game/QuestionQuiz.dart';
import 'package:app/Widgets/Games/Widget_Game/SpellingQuiz.dart';
import 'package:app/Widgets/Games/Widget_Game/VocabularyQuiz.dart';

class QuizCategory extends StatelessWidget {
  final List<Map<String, dynamic>> quizData = [
    {
      "icon": Icons.text_fields,
      "title": "Ngữ pháp",
      "text": "Thử thách kiến thức ngữ pháp",
      "route": VocabularyQuiz(),
    },
    {
      "icon": Icons.question_answer,
      "title": "Câu hỏi",
      "text": "Trả lời các câu hỏi thú vị",
      "route": QuestionQuiz(),
    },
    {
      "icon": Icons.spellcheck,
      "title": "Chính tả",
      "text": "Thử thách chính tả tiếng Anh",
      "route": SpellingQuiz(),
    },
    {
      "icon": Icons.lightbulb,
      "title": "Idioms",
      "text": "Khám phá các thành ngữ tiếng Anh",
      "route": IdiomsQuiz(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: quizData.length,
      itemBuilder: (context, index) {
        final quiz = quizData[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => quiz['route']),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  quiz['icon'],
                  size: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  quiz['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  quiz['text'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
