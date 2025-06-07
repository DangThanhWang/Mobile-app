import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Guessthedefiniton extends StatefulWidget {
  final List<Map<String, String>> words;
  final String topic;

  Guessthedefiniton({required this.words, required this.topic});

  @override
  State<Guessthedefiniton> createState() => _GuessthedefinitonState();
}

class _GuessthedefinitonState extends State<Guessthedefiniton>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late String currentWord;
  late String currentDefinition;
  int currentIndex = 0;
  String? feedbackMessage;
  int numOfCorrectAnswers = 0;
  int numOfIncorrectAnswers = 0;
  bool hintUsed = false; // Thêm flag để track việc dùng gợi ý

  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    loadWord();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Load the current word and definition
  void loadWord() {
    currentWord = widget.words[currentIndex]['word']!;
    currentDefinition = widget.words[currentIndex]['definition']!;
    feedbackMessage = null;
    hintUsed = false; // Reset hint flag
    _controller.clear();

    // Trigger animations
    _fadeController.reset();
    _bounceController.reset();
    _fadeController.forward();
    _bounceController.forward();
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "🎉 Hoàn thành bài kiểm tra!",
          style: TextStyle(
            color: Color(0xFF6B4E3D),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
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
              const Text(
                "Bạn đã hoàn thành bài kiểm tra!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildScoreCard("Đúng", numOfCorrectAnswers, Colors.green),
                  _buildScoreCard("Sai", numOfIncorrectAnswers, Colors.red),
                ],
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
                    currentIndex = 0;
                    numOfCorrectAnswers = 0;
                    numOfIncorrectAnswers = 0;
                    loadWord();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4E3D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Học lại",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int score, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Reveal a hint
  void _useHint() {
    setState(() {
      feedbackMessage = "💡 Gợi ý: ${currentWord.substring(0, 1)}...";
      hintUsed = true; // Đánh dấu đã dùng gợi ý
    });
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
                    const SizedBox(width: 40), // Balance the back button
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Enhanced Progress Bar
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
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
                                  "Tiến độ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B4E3D),
                                  ),
                                ),
                                Text(
                                  "${currentIndex + 1}/${widget.words.length}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B4E3D),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearPercentIndicator(
                              lineHeight: 8.0,
                              percent: (currentIndex + 1) / widget.words.length,
                              progressColor: const Color(0xFF8B4513),
                              backgroundColor: Colors.grey.shade200,
                              animation: true,
                              animationDuration: 500,
                              barRadius: const Radius.circular(4),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Animated Question Title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _bounceAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
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
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              '🎯 Nghĩa của từ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Enhanced Definition Card
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Text(
                            currentDefinition,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF2C5F5D),
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Enhanced Input Field
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: "💭 Nhập từ tiếng Anh...",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Enhanced Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildModernButton(
                            onPressed: _checkAnswer,
                            icon: Icons.check_circle,
                            label: "Kiểm tra",
                            gradient: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                          ),
                          _buildModernButton(
                            onPressed: !hintUsed ? _useHint : null,
                            icon: Icons.lightbulb,
                            label: "Gợi ý",
                            gradient: [Color(0xFFFF9800), Color(0xFFF57C00)],
                          ),
                          _buildModernButton(
                            onPressed: _skipQuestion,
                            icon: Icons.skip_next,
                            label: "Bỏ qua",
                            gradient: [Color(0xFFF44336), Color(0xFFD32F2F)],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Enhanced Feedback
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: feedbackMessage != null ? 60 : 0,
                        child: feedbackMessage != null
                            ? Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: feedbackMessage!.startsWith("✅")
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: feedbackMessage!.startsWith("✅")
                                        ? Colors.green.withOpacity(0.3)
                                        : Colors.red.withOpacity(0.3),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    feedbackMessage!,
                                    style: TextStyle(
                                      color: feedbackMessage!.startsWith("✅")
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),

                      const Spacer(),

                      // Score Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildScoreItem(
                                "✅ Đúng", numOfCorrectAnswers, Colors.green),
                            Container(
                              height: 30,
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            _buildScoreItem(
                                "❌ Sai", numOfIncorrectAnswers, Colors.red),
                          ],
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

  Widget _buildModernButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required List<Color> gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: onPressed != null
              ? gradient
              : [Colors.grey.shade300, Colors.grey.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: gradient[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, int score, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          score.toString(),
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
