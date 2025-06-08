import 'package:app/helpers/QuizManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';
import 'package:app/Widgets/Games/GamePage.dart';
import 'package:app/Definitons/global.dart';

class QuestionQuiz extends StatefulWidget {
  @override
  _QuestionQuizState createState() => _QuestionQuizState();
}

class _QuestionQuizState extends State<QuestionQuiz>
    with TickerProviderStateMixin {
  late QuizManager quizManager;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "Từ nào sau đây là danh từ?",
      "options": ["run", "quickly", "happiness", "blue"],
      "answer": "happiness",
    },
    {
      "question": "Từ nào là động từ?",
      "options": ["cat", "eat", "beautiful", "slow"],
      "answer": "eat",
    },
    {
      "question": "Từ trái nghĩa với 'hot' là gì?",
      "options": ["cold", "warm", "cool", "heat"],
      "answer": "cold",
    },
    {
      "question": "Chọn giới từ đúng: I am interested ___ music.",
      "options": ["in", "on", "at", "to"],
      "answer": "in",
    },
    {
      "question": "Từ nào là tính từ?",
      "options": ["happy", "happily", "happiness", "happier"],
      "answer": "happy",
    },
    {
      "question": "Từ nào là trạng từ?",
      "options": ["quick", "quickly", "quicker", "quickness"],
      "answer": "quickly",
    },
    {
      "question": "Từ đồng nghĩa với 'big' là gì?",
      "options": ["large", "small", "tiny", "short"],
      "answer": "large",
    },
    {
      "question": "Chọn đáp án đúng: She ___ to school every day.",
      "options": ["go", "goes", "going", "gone"],
      "answer": "goes",
    },
    {
      "question": "Từ nào là đại từ?",
      "options": ["he", "run", "blue", "quick"],
      "answer": "he",
    },
    {
      "question": "Từ nào là số nhiều?",
      "options": ["child", "children", "man", "woman"],
      "answer": "children",
    },
    {
      "question": "Từ nào là giới từ?",
      "options": ["under", "run", "happy", "cat"],
      "answer": "under",
    },
    {
      "question": "Từ nào là động từ bất quy tắc?",
      "options": ["walked", "played", "went", "opened"],
      "answer": "went",
    },
    {
      "question": "Từ nào là danh từ chỉ nơi chốn?",
      "options": ["school", "run", "quick", "blue"],
      "answer": "school",
    },
    {
      "question": "Từ nào là tính từ chỉ màu sắc?",
      "options": ["blue", "run", "quickly", "cat"],
      "answer": "blue",
    },
    {
      "question": "Từ nào là trạng từ chỉ tần suất?",
      "options": ["always", "cat", "run", "blue"],
      "answer": "always",
    },
  ];

  @override
  void initState() {
    super.initState();
    quizManager = QuizManager(context: context, questions: questions);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setHighScore(GamePage.userScores[1]);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[quizManager.currentQuestionIndex];
    final userProvider = Provider.of<UserProvider>(context);
    final progress = (quizManager.currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1e3c72),
              Color(0xFF2a5298),
              Color(0xFF3498db),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "📚 Câu hỏi Ngữ pháp",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Câu ${quizManager.currentQuestionIndex + 1}/${questions.length}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${(progress * 100).toInt()}%",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildScoreCard(
                        "Điểm hiện tại",
                        "${quizManager.correctAnswers * 10}",
                        Icons.school,
                        Colors.lightBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildScoreCard(
                        "Kỷ lục",
                        "${userProvider.highScore}",
                        Icons.emoji_events,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF3498db).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  currentQuestion["question"],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              const SizedBox(height: 30),
                              ...currentQuestion["options"]
                                  .asMap()
                                  .entries
                                  .map<Widget>((entry) {
                                int index = entry.key;
                                String option = entry.value;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: (quizManager.hasAnswered ||
                                            quizManager.isCompleted)
                                        ? null
                                        : () {
                                            setState(() {
                                              quizManager.checkAnswer(
                                                option,
                                                () {
                                                  setState(() {});
                                                },
                                                1,
                                                globalUserId!,
                                              );
                                            });
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          (quizManager.hasAnswered ||
                                                  quizManager.isCompleted)
                                              ? Colors.grey.withOpacity(0.3)
                                              : Colors.white,
                                      foregroundColor:
                                          (quizManager.hasAnswered ||
                                                  quizManager.isCompleted)
                                              ? Colors.grey
                                              : const Color(0xFF3498db),
                                      elevation: (quizManager.hasAnswered ||
                                              quizManager.isCompleted)
                                          ? 0
                                          : 4,
                                      shadowColor: const Color(0xFF3498db)
                                          .withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: (quizManager.hasAnswered ||
                                                  quizManager.isCompleted)
                                              ? Colors.grey.withOpacity(0.3)
                                              : const Color(0xFF3498db)
                                                  .withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: (quizManager.hasAnswered ||
                                                    quizManager.isCompleted)
                                                ? Colors.grey.withOpacity(0.3)
                                                : const Color(0xFF3498db)
                                                    .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              String.fromCharCode(
                                                  65 + index),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: (quizManager
                                                            .hasAnswered ||
                                                        quizManager.isCompleted)
                                                    ? Colors.grey
                                                    : const Color(0xFF3498db),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
