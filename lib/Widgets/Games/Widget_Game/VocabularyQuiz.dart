import 'package:app/helpers/QuizManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';
import 'package:app/Widgets/Games/GamePage.dart';
import 'package:app/Definitons/global.dart';

class VocabularyQuiz extends StatefulWidget {
  @override
  _VocabularyQuizState createState() => _VocabularyQuizState();
}

class _VocabularyQuizState extends State<VocabularyQuiz>
    with TickerProviderStateMixin {
  late QuizManager quizManager;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _progressController;

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
    {
      "question": "He ___ a doctor.",
      "options": ["am", "is", "are", "were"],
      "answer": "is"
    },
    {
      "question": "We ___ to school every day.",
      "options": ["go", "goes", "went", "gone"],
      "answer": "go"
    },
    {
      "question": "My mother ___ cooking dinner now.",
      "options": ["is", "are", "was", "were"],
      "answer": "is"
    },
    {
      "question": "They ___ their homework last night.",
      "options": ["do", "did", "done", "does"],
      "answer": "did"
    },
    {
      "question": "The cat ___ under the table.",
      "options": ["is", "are", "was", "were"],
      "answer": "is"
    },
    {
      "question": "She ___ English very well.",
      "options": ["speak", "speaks", "spoke", "spoken"],
      "answer": "speaks"
    },
    {
      "question": "We ___ a movie tomorrow.",
      "options": ["watch", "watched", "will watch", "watches"],
      "answer": "will watch"
    },
    {
      "question": "He ___ to music every morning.",
      "options": ["listen", "listens", "listened", "listening"],
      "answer": "listens"
    },
    {
      "question": "I ___ breakfast at 7 a.m.",
      "options": ["have", "has", "had", "having"],
      "answer": "have"
    },
    {
      "question": "They ___ in Hanoi last year.",
      "options": ["live", "lives", "lived", "living"],
      "answer": "lived"
    },
    {
      "question": "My friends ___ football on Sundays.",
      "options": ["play", "plays", "played", "playing"],
      "answer": "play"
    },
    {
      "question": "She ___ her homework yet.",
      "options": [
        "hasn't finished",
        "haven't finished",
        "didn't finish",
        "doesn't finish"
      ],
      "answer": "hasn't finished"
    },
  ];

  @override
  void initState() {
    super.initState();
    quizManager = QuizManager(context: context, questions: questions);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setHighScore(GamePage.userScores[0]);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[quizManager.currentQuestionIndex];
    final userProvider = Provider.of<UserProvider>(context);
    final progress = (quizManager.currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Ngữ pháp",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreCard(
                      "Điểm hiện tại",
                      "${quizManager.correctAnswers * 10}",
                      Colors.orange,
                      Icons.star,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _buildScoreCard(
                      "Kỷ lục",
                      "${userProvider.highScore}",
                      Colors.blue,
                      Icons.emoji_events,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Câu hỏi ${quizManager.currentQuestionIndex + 1}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "${questions.length}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade50,
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          currentQuestion["question"],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 2.5,
                          ),
                          itemCount: currentQuestion["options"].length,
                          itemBuilder: (context, index) {
                            final option = currentQuestion["options"][index];
                            return _buildOptionButton(option);
                          },
                        ),
                      ),
                    ],
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
      String title, String score, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String option) {
    bool isDisabled = quizManager.hasAnswered || quizManager.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
                setState(() {
                  quizManager.checkAnswer(
                    option,
                    () {
                      setState(() {});
                    },
                    0,
                    globalUserId!,
                  );
                });
              },
        style: ElevatedButton.styleFrom(
          elevation: isDisabled ? 0 : 5,
          backgroundColor: isDisabled ? Colors.grey.shade300 : Colors.white,
          foregroundColor:
              isDisabled ? Colors.grey.shade600 : Colors.orange.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: isDisabled
                  ? Colors.grey.shade400
                  : Colors.orange.withOpacity(0.5),
              width: 2,
            ),
          ),
          shadowColor: Colors.orange.withOpacity(0.3),
        ),
        child: FittedBox(
          child: Text(
            option,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDisabled ? Colors.grey.shade600 : Colors.orange.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
