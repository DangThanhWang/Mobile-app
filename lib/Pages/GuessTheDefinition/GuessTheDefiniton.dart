import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../Components/HomeTopButton.dart';

class Guessthedefiniton extends StatefulWidget {
  final List<Map<String, String>> words;
  final String topic;

  Guessthedefiniton({required this.words, required this.topic});

  @override
  State<Guessthedefiniton> createState() => _GuessthedefinitonState();
}

class _GuessthedefinitonState extends State<Guessthedefiniton> {
  final TextEditingController _controller = TextEditingController();
  late String currentWord;
  late String currentDefinition;
  int currentIndex = 0;
  String? feedbackMessage;
  int numOfCorrectAnswers = 0;
  int numOfIncorrectAnswers = 0;

  // Load the current word and definition
  void loadWord() {
    currentWord = widget.words[currentIndex]['word']!;
    currentDefinition = widget.words[currentIndex]['definition']!;
    feedbackMessage = null;
    _controller.clear();
  }

  // Check if the answer is correct
  void _checkAnswer() {
    setState(() {
      if (_controller.text.trim().toLowerCase() == currentWord.toLowerCase()) {
        feedbackMessage = "✅ Chính xác!";
        numOfCorrectAnswers++;
      } else {
        feedbackMessage = "❌ Sai rồi, đáp án là: $currentWord";
        numOfIncorrectAnswers++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (currentIndex < widget.words.length - 1) {
        setState(() {
          currentIndex++;
          loadWord();
        });
      } else {
        _showCompletionDialog();
      }
    });
  }

  // Skip question logic
  void _skipQuestion() {
    setState(() {
      feedbackMessage = "⏩ Đã bỏ qua! Đáp án là: $currentWord";
      numOfIncorrectAnswers++;
      if (currentIndex < widget.words.length - 1) {
        currentIndex++;
        loadWord();
      } else {
        _showCompletionDialog();
      }
    });
  }

  // Show completion dialog
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFEADBC8),
        title: const Text(
          "🎉 Hoàn thành bài kiểm tra!",
          style: TextStyle(color: Colors.brown),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Bạn đã hoàn thành bài kiểm tra!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Đúng: $numOfCorrectAnswers",
              style: const TextStyle(color: Colors.green, fontSize: 18),
            ),
            Text(
              "Sai: $numOfIncorrectAnswers",
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Thoát"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentIndex = 0;
                numOfCorrectAnswers = 0;
                numOfIncorrectAnswers = 0;
                loadWord();
              });
            },
            child: const Text("Học lại"),
          ),
        ],
      ),
    );
  }

  // Reveal a hint
  void _useHint() {
    setState(() {
      feedbackMessage = "Gợi ý: ${currentWord.substring(0, 1)}...";
    });
  }

  @override
  void initState() {
    super.initState();
    loadWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeTopButton(topic: widget.topic),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/capybara_background.png'),
            fit: BoxFit.cover,
            colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.dstATop),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Progress Bar
              LinearPercentIndicator(
                lineHeight: 15.0,
                percent: (numOfCorrectAnswers) / widget.words.length,
                progressColor: const Color(0xFF8D6E63),
                backgroundColor: Colors.grey.shade300,
                animation: true,
                animationDuration: 500,
                center: Text(
                  "${((numOfCorrectAnswers) / widget.words.length * 100).toInt()}%",
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              // Question Title
              const Text(
                'Nghĩa của từ',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Rubik',
                  shadows: [
                    Shadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Current Definition
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5E8D0),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Text(
                  currentDefinition,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 26,
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Input Field
              TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Nhập từ tiếng Anh...",
                  hintStyle: const TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildThemedButton(
                    onPressed: _controller.text.isNotEmpty ? _checkAnswer : null,
                    icon: Icons.check,
                    label: "Kiểm tra",
                    backgroundColor: const Color(0xFF2A5934), // Deep Forest Green
                    textColor: Colors.white,
                  ),
                  _buildThemedButton(
                    onPressed: _useHint,
                    icon: Icons.lightbulb,
                    label: "Gợi ý",
                    backgroundColor: const Color(0xFFF3B044), // Golden Sand
                    textColor: Colors.black,
                  ),
                  _buildThemedButton(
                    onPressed: _skipQuestion,
                    icon: Icons.skip_next,
                    label: "Bỏ qua",
                    backgroundColor: const Color(0xFFED66C9), // Dusty Rose
                    textColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Feedback
              if (feedbackMessage != null)
                Text(
                  feedbackMessage!,
                  style: TextStyle(
                    color: feedbackMessage!.startsWith("✅")
                        ? Colors.green
                        : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              const Spacer(),
              // Mascot
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/capybara_mascot.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Score
              Text(
                "Đúng: $numOfCorrectAnswers   Sai: $numOfIncorrectAnswers",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for Buttons
  Widget _buildThemedButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 4,
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: textColor,
        size: 20,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}



