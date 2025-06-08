import 'package:flutter/material.dart';
import 'package:app/Database/mongoDB.dart';
import 'package:app/Widgets/Games/GamePage.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';

class QuizManager {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  bool hasAnswered = false;
  bool isCompleted = false;
  final BuildContext context;

  List<Map<String, dynamic>> questions;

  QuizManager({required this.context, required this.questions});

  void checkAnswer(String selectedOption, VoidCallback updateUI, int index,
      String userId) async {
    if (!hasAnswered && !isCompleted) {
      hasAnswered = true;

      final currentQuestion = questions[currentQuestionIndex];
      if (selectedOption == currentQuestion["answer"]) {
        correctAnswers++;
        _showSnackBar("Đúng rồi!", Colors.green);

        Future.delayed(const Duration(seconds: 1), () async {
          if (currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
            hasAnswered = false;
            updateUI();
          } else {
            isCompleted = true;
            _showSnackBar(
              "Bạn đã hoàn thành tất cả câu hỏi! Số điểm bạn đã đạt được là ${correctAnswers * 10}/${questions.length * 10}",
              Colors.blue,
              showAction: true,
            );

            int newScore = correctAnswers * 10;
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);

            if (newScore > GamePage.userScores[index]) {
              await MongoDBDatabase.setUserScore(userId, index, newScore);
              GamePage.userScores[index] = newScore;

              int totalScore = GamePage.userScores[0] +
                  GamePage.userScores[1] +
                  GamePage.userScores[2] +
                  GamePage.userScores[3];
              await MongoDBDatabase.setUserScore(userId, 4, totalScore);
              GamePage.userScores[4] = totalScore;
              userProvider.setTotalScore(totalScore);
            }

            updateUI();
          }
        });
      } else {
        _showSnackBar("Sai rồi!", Colors.red);

        Future.delayed(const Duration(seconds: 1), () async {
          if (currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
            hasAnswered = false;
            updateUI();
          } else {
            isCompleted = true;
            _showSnackBar(
              "Bạn đã hoàn thành tất cả câu hỏi! Số điểm bạn đã đạt được là ${correctAnswers * 10}/${questions.length * 10}",
              Colors.blue,
              showAction: true,
            );

            int newScore = correctAnswers * 10;
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);

            if (newScore > GamePage.userScores[index]) {
              await MongoDBDatabase.setUserScore(userId, index, newScore);
              GamePage.userScores[index] = newScore;

              int totalScore = GamePage.userScores[0] +
                  GamePage.userScores[1] +
                  GamePage.userScores[2] +
                  GamePage.userScores[3];
              await MongoDBDatabase.setUserScore(userId, 4, totalScore);
              GamePage.userScores[4] = totalScore;
              userProvider.setTotalScore(totalScore);
            }

            updateUI();
          }
        });
      }
    }
  }

  void _showSnackBar(String message, Color color, {bool showAction = false}) {
    if (showAction) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("Thông báo"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Làm lại bài"),
              onPressed: () {
                currentQuestionIndex = 0;
                correctAnswers = 0;
                hasAnswered = false;
                isCompleted = false;
                Navigator.of(context).pop();
                (context as Element).markNeedsBuild();
              },
            ),
            TextButton(
              child: const Text("Xác nhận"),
              onPressed: () {
                currentQuestionIndex = 0;
                correctAnswers = 0;
                hasAnswered = false;
                isCompleted = false;
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
