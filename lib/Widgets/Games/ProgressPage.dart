import 'package:flutter/material.dart';
import 'package:app/Database/mongoDB.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';
import 'package:app/Definitons/global.dart';

class ProgressPage extends StatefulWidget {
  @override
  State<ProgressPage> createState() => _ProgressPage();
  static List<int> userScores = [0, 0, 0, 0, 0];
}

class _ProgressPage extends State<ProgressPage> {
  List<int> userScores = [0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    fetchUserScores();
  }

  Future<void> fetchUserScores() async {
    List<int> scores = [];
    for (int i = 0; i < 5; i++) {
      int score = await MongoDBDatabase.getUserScore(globalUserId!, index: i);
      scores.add(score);
    }
    setState(() {
      userScores = scores;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setTotalScore(scores[4]);
  }

  @override
  Widget build(BuildContext context) {
    final quizTitles = [
      "Ngữ pháp",
      "Câu hỏi",
      "Chính tả",
      "Idioms",
    ];
    final quizIcons = [
      Icons.text_fields,
      Icons.question_answer,
      Icons.spellcheck,
      Icons.lightbulb,
    ];
    final quizColors = [
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.purple,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tiến độ học tập"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(
                quizIcons[index],
                size: 40,
                color: quizColors[index],
              ),
              title: Text(
                quizTitles[index],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: userScores[index] == 150
                  ? const Text(
                      "Bạn đã hoàn thành xuất sắc phần này!",
                      style: TextStyle(fontSize: 14, color: Colors.orange),
                    )
                  : Text(
                      quizTitles[index] == "Ngữ pháp"
                          ? "Hãy luyện tập thêm ngữ pháp để đạt điểm tối đa!"
                          : quizTitles[index] == "Câu hỏi"
                              ? "Cố gắng trả lời đúng nhiều câu hỏi hơn nhé!"
                              : quizTitles[index] == "Chính tả"
                                  ? "Luyện tập chính tả để cải thiện điểm số!"
                                  : "Khám phá thêm nhiều idioms để nâng cao trình độ!",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.orange),
                    ),
              trailing: Text(
                "${userScores[index] ~/ 10}/15",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
