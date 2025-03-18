import 'package:flutter/material.dart';
import 'package:app/Widgets/Games/Widget_Game/IdiomsQuiz.dart';
import 'package:app/Widgets/Games/Widget_Game/QuestionQuiz.dart';
import 'package:app/Widgets/Games/Widget_Game/SpellingQuiz.dart';
import 'package:app/Widgets/Games/Widget_Game/VocabularyQuiz.dart';

class GamePage extends StatelessWidget {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Hello, User!",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: const [
                Icon(Icons.monetization_on, color: Colors.orange),
                SizedBox(width: 5),
                Text(
                  "602",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            child: Text(
              "What would you like to play today?",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
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
                    width: 140,
                    margin: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(quiz['icon'], size: 50, color: Colors.orange),
                        const SizedBox(height: 8),
                        Text(
                          quiz['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          quiz['text'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Unfinished Games",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: quizData.length,
              itemBuilder: (context, index) {
                final quiz = quizData[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(
                      quiz['icon'],
                      size: 40,
                      color: Colors.orange,
                    ),
                    title: Text(
                      quiz['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: const Text(
                      "20 Questions",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: CircularProgressIndicator(
                      value: 0.6,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
