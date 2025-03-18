import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../Components/HomeTopButton.dart';

class TestPage extends StatefulWidget {
  final List<Map<String, String>> words;
  final String topic;

  TestPage({required this.words, required this.topic});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late String currentWord;
  late String correctDefinition;
  late List<String> options;
  int numOfWords = 0;
  int questionIndex = 0;
  int numOfCorrectAnswers = 0;
  final _random = Random();
  bool isAnswered = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    numOfWords = widget.words.length;
    loadQuestion();
  }

  void loadQuestion() {
    currentWord = widget.words[questionIndex]['word']!;
    correctDefinition = widget.words[questionIndex]['definition']!;

    List<String> allDefinitions =
    widget.words.map((item) => item['definition']!).toList();
    allDefinitions.remove(correctDefinition);
    allDefinitions.shuffle(_random);

    options = [correctDefinition, ...allDefinitions.take(3)];
    options.shuffle(_random);

    isAnswered = false;
    selectedOption = null;
  }

  void checkAnswer(String option) {
    setState(() {
      isAnswered = true;
      selectedOption = option;

      if (option == correctDefinition) {
        numOfCorrectAnswers++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (questionIndex < widget.words.length - 1) {
        setState(() {
          questionIndex++;
          loadQuestion();
        });
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "🎉 Quiz Complete!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Correct Answers: $numOfCorrectAnswers / $numOfWords",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Exit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                questionIndex = 0;
                numOfCorrectAnswers = 0;
                loadQuestion();
              });
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE5),
      appBar: HomeTopButton(topic: widget.topic),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Indicator
            CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 6.0,
              percent: (questionIndex + 1) / numOfWords,
              progressColor: const Color(0xFF8D6E63),
              backgroundColor: Colors.grey.shade300,
              animation: true,
              animationDuration: 500,
              center: Text(
                "${((questionIndex + 1) / numOfWords * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            // Question Header
            Text(
              "Question ${questionIndex + 1} / $numOfWords",
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 15),
            // Current Word
            Text(
              currentWord,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 15),
            // Answer Options
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  String option = options[index];
                  bool isCorrect = option == correctDefinition;
                  return GestureDetector(
                    onTap: isAnswered ? null : () => checkAnswer(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isAnswered
                              ? (isCorrect
                              ? [Colors.greenAccent, Colors.green]
                              : (selectedOption == option
                              ? [Colors.redAccent, Colors.red]
                              : [Colors.grey.shade200, Colors.white]))
                              : [Colors.orangeAccent, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 4,
                            offset: const Offset(2, 4),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isAnswered && selectedOption == option
                                ? Colors.white
                                : Colors.black,
                            fontSize: 18,
                            fontFamily: 'Rubik',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Feedback Message
            // if (isAnswered)
            //   Text(
            //     selectedOption == correctDefinition
            //         ? "✅ Chinh!"
            //         : "❌ Incorrect!",
            //     style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //       color: selectedOption == correctDefinition
            //           ? Colors.green
            //           : Colors.red,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}



