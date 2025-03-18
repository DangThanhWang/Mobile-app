import 'package:flutter/material.dart';

class SpellingQuiz extends StatefulWidget {
  @override
  _SpellingQuizState createState() => _SpellingQuizState();
}

class _SpellingQuizState extends State<SpellingQuiz> {
  final List<Map<String, dynamic>> questions = [
    {"hint": "___ is the capital of Vietnam.", "answer": "Hanoi"},
    {"hint": "He is a good ___ player.", "answer": "football"},
  ];

  int currentQuestionIndex = 0;
  TextEditingController answerController = TextEditingController();
  bool hasAnswered = false;
  bool isCompleted = false;

  void checkAnswer() {
    if (!hasAnswered && !isCompleted) {
      setState(() {
        hasAnswered = true;
      });

      if (answerController.text.trim().toLowerCase() ==
          questions[currentQuestionIndex]["answer"].toLowerCase()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Đúng rồi!"), backgroundColor: Colors.green),
        );

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            if (currentQuestionIndex < questions.length - 1) {
              currentQuestionIndex++;
              answerController.clear();
              hasAnswered = false;
            } else {
              isCompleted = true;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Bạn đã hoàn thành!"),
                    backgroundColor: Colors.blue),
              );
            }
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Sai rồi!"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chính tả"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Gợi ý: ${currentQuestion["hint"]}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: answerController,
                enabled: !hasAnswered && !isCompleted,
                decoration: InputDecoration(
                  hintText: "Nhập câu trả lời",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (hasAnswered || isCompleted) ? null : checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      hasAnswered || isCompleted ? Colors.grey : Colors.purple,
                ),
                child: const Text("Xác nhận"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
