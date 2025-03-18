import 'package:flutter/material.dart';

class QuizManager {
  int currentQuestionIndex = 0;
  bool hasAnswered = false;
  bool isCompleted = false;
  bool isRetrying = false; // Biến kiểm soát trạng thái thử lại
  final BuildContext context;

  List<Map<String, dynamic>> questions;

  QuizManager({required this.context, required this.questions});

  void checkAnswer(String selectedOption, VoidCallback updateUI) {
    if (!hasAnswered && !isCompleted) {
      hasAnswered = true;

      final currentQuestion = questions[currentQuestionIndex];
      if (selectedOption == currentQuestion["answer"]) {
        _showSnackBar("Đúng rồi!", Colors.green);

        Future.delayed(const Duration(seconds: 1), () {
          if (currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
            hasAnswered = false;
            updateUI();
          } else {
            isCompleted = true;
            _showSnackBar("Bạn đã hoàn thành tất cả câu hỏi!", Colors.blue);
            updateUI();
          }
        });
      } else {
        isRetrying = true; // Cho phép thử lại khi sai
        _showSnackBar("Sai rồi! Hãy thử lại!", Colors.red);

        Future.delayed(const Duration(seconds: 1), () {
          isRetrying = false;
          hasAnswered = false; // Cho phép chọn lại sau khi hiện thông báo
          updateUI();
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
