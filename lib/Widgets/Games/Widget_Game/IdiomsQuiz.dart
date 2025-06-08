import 'package:app/helpers/QuizManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';
import 'package:app/Widgets/Games/GamePage.dart';
import 'package:app/Definitons/global.dart';

class IdiomsQuiz extends StatefulWidget {
  @override
  _IdiomsQuizState createState() => _IdiomsQuizState();
}

class _IdiomsQuizState extends State<IdiomsQuiz> with TickerProviderStateMixin {
  late QuizManager quizManager;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> idioms = [
    {
      "question": "\"Break the ice\" nghĩa là:",
      "options": ["Làm vỡ băng", "Cảm thấy lạnh", "Bắt đầu cuộc trò chuyện"],
      "answer": "Bắt đầu cuộc trò chuyện"
    },
    {
      "question": "\"Piece of cake\" nghĩa là:",
      "options": ["Việc khó khăn", "Điều dễ dàng", "Một phần của bánh"],
      "answer": "Điều dễ dàng"
    },
    {
      "question": "\"Let the cat out of the bag\" nghĩa là:",
      "options": ["Thả mèo ra ngoài", "Mua một con mèo", "Tiết lộ bí mật"],
      "answer": "Tiết lộ bí mật"
    },
    {
      "question": "\"Hit the books\" nghĩa là:",
      "options": ["Viết sách", "Đánh vào sách", "Học bài chăm chỉ"],
      "answer": "Học bài chăm chỉ"
    },
    {
      "question": "\"Under the weather\" nghĩa là:",
      "options": ["Dưới thời tiết", "Dự báo thời tiết", "Cảm thấy không khỏe"],
      "answer": "Cảm thấy không khỏe"
    },
    {
      "question": "\"Cost an arm and a leg\" nghĩa là:",
      "options": ["Bị thương", "Rẻ tiền", "Rất đắt"],
      "answer": "Rất đắt"
    },
    {
      "question": "\"Once in a blue moon\" nghĩa là:",
      "options": ["Thường xuyên", "Mỗi khi trăng xanh", "Hiếm khi"],
      "answer": "Hiếm khi"
    },
    {
      "question": "\"Burn the midnight oil\" nghĩa là:",
      "options": [
        "Nấu ăn khuya",
        "Đốt dầu nửa đêm",
        "Thức khuya làm việc/học bài"
      ],
      "answer": "Thức khuya làm việc/học bài"
    },
    {
      "question": "\"The ball is in your court\" nghĩa là:",
      "options": [
        "Bạn ở trong sân bóng",
        "Chơi bóng",
        "Đến lượt bạn quyết định"
      ],
      "answer": "Đến lượt bạn quyết định"
    },
    {
      "question": "\"Kill two birds with one stone\" nghĩa là:",
      "options": ["Bắn đá", "Giết hai con chim", "Một công đôi việc"],
      "answer": "Một công đôi việc"
    },
    {
      "question": "\"When pigs fly\" nghĩa là:",
      "options": ["Chăn nuôi lợn", "Lợn biết bay", "Điều không thể xảy ra"],
      "answer": "Điều không thể xảy ra"
    },
    {
      "question": "\"Break a leg\" nghĩa là:",
      "options": ["Chạy nhanh", "Gãy chân", "Chúc may mắn"],
      "answer": "Chúc may mắn"
    },
    {
      "question": "\"Pull someone's leg\" nghĩa là:",
      "options": ["Kéo chân ai đó", "Giúp đỡ ai đó", "Trêu chọc ai đó"],
      "answer": "Trêu chọc ai đó"
    },
    {
      "question": "\"Sit on the fence\" nghĩa là:",
      "options": [
        "Ngồi trên hàng rào",
        "Xem xét kỹ lưỡng",
        "Trung lập, không quyết định"
      ],
      "answer": "Trung lập, không quyết định"
    },
    {
      "question": "\"Hit the sack\" nghĩa là:",
      "options": ["Làm việc chăm chỉ", "Đánh vào bao tải", "Đi ngủ"],
      "answer": "Đi ngủ"
    },
  ];

  @override
  void initState() {
    super.initState();
    quizManager = QuizManager(context: context, questions: idioms);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setHighScore(GamePage.userScores[2]);

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
    final currentIdiom = idioms[quizManager.currentQuestionIndex];
    final userProvider = Provider.of<UserProvider>(context);
    final progress = (quizManager.currentQuestionIndex + 1) / idioms.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
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
                          "🎯 Idioms Quiz",
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
                          "Câu ${quizManager.currentQuestionIndex + 1}/${idioms.length}",
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
                        Icons.star,
                        Colors.amber,
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
                                      const Color(0xFF667eea).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  currentIdiom["question"],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              const SizedBox(height: 30),
                              ...currentIdiom["options"]
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
                                                2,
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
                                              : const Color(0xFF667eea),
                                      elevation: (quizManager.hasAnswered ||
                                              quizManager.isCompleted)
                                          ? 0
                                          : 4,
                                      shadowColor: const Color(0xFF667eea)
                                          .withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: (quizManager.hasAnswered ||
                                                  quizManager.isCompleted)
                                              ? Colors.grey.withOpacity(0.3)
                                              : const Color(0xFF667eea)
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
                                                : const Color(0xFF667eea)
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
                                                    : const Color(0xFF667eea),
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
