import 'package:flutter/material.dart';
import 'package:app/Database/mongoDB.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';
import 'package:app/Definitons/global.dart';
import 'package:app/Widgets/Games/Widget_Game/IdiomsQuiz.dart';
import 'package:app/Widgets/Games/Widget_Game/QuestionQuiz.dart';
import 'package:app/Widgets/Games/Widget_Game/SpellingQuiz.dart';
import 'package:app/Widgets/Games/Widget_Game/VocabularyQuiz.dart';
import 'package:app/Widgets/Games/LeaderboardPage.dart';
import 'package:app/Widgets/Games/ProgressPage.dart';

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
  static List<int> userScores = [0, 0, 0, 0, 0];
}

class _GamePageState extends State<GamePage> {
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
      GamePage.userScores = scores;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setTotalScore(scores[4]);
  }

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
    final userName = context.watch<UserProvider>().userName;
    final totalScore = context.watch<UserProvider>().totalScore;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Hello, $userName!",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.sports_score, color: Colors.orange),
                const SizedBox(width: 5),
                Text(
                  "$totalScore",
                  style: const TextStyle(
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
              "Hôm nay bạn muốn chơi gì?",
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
                        Icon(
                          quiz['icon'],
                          size: 50,
                          color: quiz['title'] == "Ngữ pháp"
                              ? Colors.orange
                              : quiz['title'] == "Câu hỏi"
                                  ? Colors.blue
                                  : quiz['title'] == "Chính tả"
                                      ? Colors.green
                                      : quiz['title'] == "Idioms"
                                          ? Colors.purple
                                          : Colors.orange,
                        ),
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
                            color: Colors.orange,
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
              "Theo dõi tiến trình của bạn",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.timeline,
                        size: 40, color: Colors.blue),
                    title: const Text(
                      "Tiến độ học tập",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      "Tiến độ hoàn thành mỗi bài tập của bạn",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.orange),
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProgressPage()),
                      );
                    },
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.leaderboard,
                        size: 40, color: Colors.green),
                    title: const Text(
                      "Bảng xếp hạng",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: const Text(
                      "Xem thứ hạng của bạn so với mọi người",
                      style: TextStyle(fontSize: 14, color: Colors.orange),
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaderboardPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
