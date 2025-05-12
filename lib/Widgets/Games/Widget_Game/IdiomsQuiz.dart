import 'package:flutter/material.dart';
import 'package:app/Database/mongoDB.dart';

class IdiomsQuiz extends StatefulWidget {
  @override
  _IdiomsQuizState createState() => _IdiomsQuizState();
}

class _IdiomsQuizState extends State<IdiomsQuiz> {
  List<Map<String, dynamic>> idioms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  Future<void> fetchQuiz() async {
    try {
      final data = await MongoDBDatabase.getQuizData('idioms');
      setState(() {
        idioms = data;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi khi lấy dữ liệu: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  int currentIndex = 0;
  bool hasAnswered = false;
  bool isCompleted = false;

  void checkAnswer(String selectedOption) {
    if (!hasAnswered && !isCompleted) {
      setState(() {
        hasAnswered = true;
      });

      if (selectedOption == idioms[currentIndex]["answer"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Đúng rồi!"), backgroundColor: Colors.green),
        );
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            if (currentIndex < idioms.length - 1) {
              currentIndex++;
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
    final currentIdiom = idioms[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Idioms"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Thành ngữ: ${currentIdiom["question"]}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 10,
              children: currentIdiom["options"].map<Widget>((option) {
                return ElevatedButton(
                  onPressed: (hasAnswered || isCompleted)
                      ? null
                      : () {
                          checkAnswer(option);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasAnswered || isCompleted
                        ? Colors.grey
                        : Colors.tealAccent,
                  ),
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
