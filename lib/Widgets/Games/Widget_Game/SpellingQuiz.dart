import 'package:app/helpers/QuizManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';
import 'package:app/Widgets/Games/GamePage.dart';
import 'package:app/Definitons/global.dart';

class SpellingQuiz extends StatefulWidget {
  @override
  _SpellingQuizState createState() => _SpellingQuizState();
}

class _SpellingQuizState extends State<SpellingQuiz>
    with SingleTickerProviderStateMixin {
  late QuizManager quizManager;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "\"Con mèo\" trong tiếng Anh là:",
      "answer": "cat",
      "options": ["cat", "cta", "kat", "caat"]
    },
    {
      "question": "\"Quyển sách\" trong tiếng Anh là:",
      "answer": "book",
      "options": ["book", "bok", "boook", "bokk"]
    },
    {
      "question": "\"Cái bàn\" trong tiếng Anh là:",
      "answer": "table",
      "options": ["table", "tabel", "tabble", "taable"]
    },
    {
      "question": "\"Cái ghế\" trong tiếng Anh là:",
      "answer": "chair",
      "options": ["chair", "chiar", "chari", "chaire"]
    },
    {
      "question": "\"Quả táo\" trong tiếng Anh là:",
      "answer": "apple",
      "options": ["apple", "aple", "appel", "applle"]
    },
    {
      "question": "\"Cái bút\" trong tiếng Anh là:",
      "answer": "pen",
      "options": ["pen", "pan", "peen", "penn"]
    },
    {
      "question": "\"Cửa sổ\" trong tiếng Anh là:",
      "answer": "window",
      "options": ["window", "windown", "windo", "wiindow"]
    },
    {
      "question": "\"Cái đồng hồ\" trong tiếng Anh là:",
      "answer": "clock",
      "options": ["clock", "clok", "clcok", "clokc"]
    },
    {
      "question": "\"Giáo viên\" trong tiếng Anh là:",
      "answer": "teacher",
      "options": ["teacher", "techer", "teachar", "teatcher"]
    },
    {
      "question": "\"Học sinh\" trong tiếng Anh là:",
      "answer": "student",
      "options": ["student", "studnet", "studen", "studdent"]
    },
    {
      "question": "\"Xe đạp\" trong tiếng Anh là:",
      "answer": "bicycle",
      "options": ["bicycle", "bycicle", "bicyle", "bicycel"]
    },
    {
      "question": "\"Cái điện thoại\" trong tiếng Anh là:",
      "answer": "phone",
      "options": ["phone", "fone", "phonne", "phome"]
    },
    {
      "question": "\"Quả chuối\" trong tiếng Anh là:",
      "answer": "banana",
      "options": ["banana", "bananna", "banan", "bannana"]
    },
    {
      "question": "\"Cái tủ lạnh\" trong tiếng Anh là:",
      "answer": "fridge",
      "options": ["fridge", "frige", "frigde", "fridgge"]
    },
    {
      "question": "\"Cái giường\" trong tiếng Anh là:",
      "answer": "bed",
      "options": ["bed", "beed", "bad", "bedd"]
    },
  ];

  @override
  void initState() {
    super.initState();
    quizManager = QuizManager(context: context, questions: questions);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setHighScore(GamePage.userScores[3]);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateToNextQuestion() {
    _animationController.reset();
    _animationController.forward();
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
              Color(0xFF8E24AA),
              Color(0xFF7B1FA2),
              Color(0xFF6A1B9A),
              Color(0xFF4A148C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                          "Chính tả",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${(progress * 100).toInt()}%",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.orange),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildScoreCard(
                        "Điểm hiện tại",
                        "${quizManager.correctAnswers * 10}",
                        Icons.star,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildScoreCard(
                        "Kỷ lục",
                        "${userProvider.highScore}",
                        Icons.emoji_events,
                        Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "Câu hỏi",
                                        style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      currentQuestion["question"],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 2.5,
                                  ),
                                  itemCount: currentQuestion["options"].length,
                                  itemBuilder: (context, index) {
                                    final option =
                                        currentQuestion["options"][index];
                                    final isDisabled =
                                        quizManager.hasAnswered ||
                                            quizManager.isCompleted;

                                    return _buildOptionButton(
                                      option,
                                      isDisabled,
                                      () {
                                        setState(() {
                                          quizManager.checkAnswer(
                                            option,
                                            () {
                                              setState(() {});
                                              _animateToNextQuestion();
                                            },
                                            3,
                                            globalUserId!,
                                          );
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(
      String title, String score, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score,
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

  Widget _buildOptionButton(
      String option, bool isDisabled, VoidCallback onPressed) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: isDisabled
                  ? LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade400],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFBA68C8),
                        Color(0xFF9C27B0),
                        Color(0xFF8E24AA),
                      ],
                    ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDisabled ? Colors.grey.shade600 : Colors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
