import 'package:app/helpers/QuizManager.dart';
import 'package:flutter/material.dart';
import 'package:app/Database/mongoDB.dart';

class QuestionQuiz extends StatefulWidget {
  @override
  _QuestionQuizState createState() => _QuestionQuizState();
}

class _QuestionQuizState extends State<QuestionQuiz> {
  late QuizManager quizManager;

  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    quizManager = QuizManager(context: context, questions: questions);
    fetchQuiz();
  }

  Future<void> fetchQuiz() async {
    try {
      final data = await MongoDBDatabase.getQuizData('questions');
      setState(() {
        questions = data;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi khi lấy dữ liệu: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[quizManager.currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Câu hỏi"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Câu hỏi ${quizManager.currentQuestionIndex + 1}/${questions.length}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                currentQuestion["question"],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Column(
                children: currentQuestion["options"].map<Widget>((option) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 200,
                    child: ElevatedButton(
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
                        backgroundColor:
                            quizManager.hasAnswered || quizManager.isCompleted
                                ? Colors.grey
                                : const Color.fromARGB(164, 92, 150, 250),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(option, style: const TextStyle(fontSize: 16)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
