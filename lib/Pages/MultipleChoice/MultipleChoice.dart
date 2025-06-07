import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TestPage extends StatefulWidget {
  final List<Map<String, String>> words;
  final String topic;

  TestPage({required this.words, required this.topic});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  late String currentWord;
  late String correctDefinition;
  late List<String> options;
  int numOfWords = 0;
  int questionIndex = 0;
  int numOfCorrectAnswers = 0;
  final _random = Random();
  bool isAnswered = false;
  String? selectedOption;

  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    numOfWords = widget.words.length;

    // Initialize animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    loadQuestion();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
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

    // Trigger animations
    _slideController.reset();
    _scaleController.reset();
    _slideController.forward();
    _scaleController.forward();
  }

  void checkAnswer(String option) {
    setState(() {
      isAnswered = true;
      selectedOption = option;

      if (option == correctDefinition) {
        numOfCorrectAnswers++;
      }
    });

    // Tự động chuyển câu hỏi sau 1.5 giây
    Future.delayed(const Duration(milliseconds: 1500), () {
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
    double percentage = (numOfCorrectAnswers / numOfWords) * 100;
    String grade = '';
    Color gradeColor = Colors.grey;

    if (percentage >= 90) {
      grade = 'Xuất sắc! 🏆';
      gradeColor = Colors.amber;
    } else if (percentage >= 80) {
      grade = 'Tốt! 🎉';
      gradeColor = Colors.green;
    } else if (percentage >= 70) {
      grade = 'Khá! 👍';
      gradeColor = Colors.blue;
    } else if (percentage >= 60) {
      grade = 'Trung bình! 📚';
      gradeColor = Colors.orange;
    } else {
      grade = 'Cần cố gắng thêm! 💪';
      gradeColor = Colors.red;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradeColor.withOpacity(0.2),
                    gradeColor.withOpacity(0.1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                grade,
                style: TextStyle(
                  color: gradeColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8F4E6), Color(0xFFE8DCC0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Kết quả của bạn",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B4E3D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildResultCard("Đúng", numOfCorrectAnswers, Colors.green),
                  _buildResultCard(
                      "Sai", numOfWords - numOfCorrectAnswers, Colors.red),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: gradeColor.withOpacity(0.3)),
                ),
                child: Text(
                  "${percentage.toInt()}% chính xác",
                  style: TextStyle(
                    color: gradeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Thoát",
                    style: TextStyle(color: Colors.black87)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    questionIndex = 0;
                    numOfCorrectAnswers = 0;
                    loadQuestion();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4E3D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Làm lại",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F4E6),
              Color(0xFFE8DCC0),
              Color(0xFFD4C4A0),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B4513), Color(0xFF6B4E3D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.topic,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Enhanced Progress Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Câu hỏi ${questionIndex + 1}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B4E3D),
                                  ),
                                ),
                                Text(
                                  "$numOfCorrectAnswers đúng",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            CircularPercentIndicator(
                              radius: 40.0,
                              lineWidth: 8.0,
                              percent: (questionIndex + 1) / numOfWords,
                              progressColor: const Color(0xFF8B4513),
                              backgroundColor: Colors.grey.shade200,
                              animation: true,
                              animationDuration: 500,
                              center: Text(
                                "${questionIndex + 1}/$numOfWords",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF6B4E3D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Animated Word Card
                      SlideTransition(
                        position: _slideAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6B4E3D), Color(0xFF8B4513)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Nghĩa của từ này là gì?",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currentWord,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Options List - Fixed height, no scrolling
                      Expanded(
                        child: Column(
                          children: List.generate(options.length, (index) {
                            String option = options[index];
                            bool isCorrect = option == correctDefinition;
                            bool isSelected = selectedOption == option;

                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: GestureDetector(
                                  onTap: isAnswered
                                      ? null
                                      : () => checkAnswer(option),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: _getOptionColors(
                                            isAnswered, isCorrect, isSelected),
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: isAnswered && isCorrect
                                          ? Border.all(
                                              color: Colors.green, width: 3)
                                          : isAnswered &&
                                                  isSelected &&
                                                  !isCorrect
                                              ? Border.all(
                                                  color: Colors.red, width: 3)
                                              : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              String.fromCharCode(
                                                  65 + index), // A, B, C, D
                                              style: TextStyle(
                                                color: _getTextColor(isAnswered,
                                                    isCorrect, isSelected),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              color: _getTextColor(isAnswered,
                                                  isCorrect, isSelected),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isAnswered && isCorrect)
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        else if (isAnswered &&
                                            isSelected &&
                                            !isCorrect)
                                          const Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      // Feedback Message
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: isAnswered ? 50 : 0,
                        child: isAnswered
                            ? Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: selectedOption == correctDefinition
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedOption == correctDefinition
                                        ? Colors.green.withOpacity(0.3)
                                        : Colors.red.withOpacity(0.3),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    selectedOption == correctDefinition
                                        ? "🎉 Chính xác!"
                                        : "❌ Sai rồi!",
                                    style: TextStyle(
                                      color: selectedOption == correctDefinition
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
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

  List<Color> _getOptionColors(
      bool isAnswered, bool isCorrect, bool isSelected) {
    if (!isAnswered) {
      return [Colors.white, Color(0xFFF8F4E6)];
    }

    if (isCorrect) {
      return [Colors.green, Colors.green.shade600];
    } else if (isSelected) {
      return [Colors.red, Colors.red.shade600];
    } else {
      return [Colors.grey.shade200, Colors.grey.shade300];
    }
  }

  Color _getTextColor(bool isAnswered, bool isCorrect, bool isSelected) {
    if (!isAnswered) {
      return Color(0xFF6B4E3D);
    }

    if (isCorrect || isSelected) {
      return Colors.white;
    } else {
      return Colors.grey.shade600;
    }
  }
}
