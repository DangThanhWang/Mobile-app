import 'package:app/Pages/Pronunciation/PronunciationProgress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class PronunciationPracticePage extends StatefulWidget {
  final List<String> words;
  PronunciationPracticePage({required this.words});
  @override
  _PronunciationPracticePageState createState() =>
      _PronunciationPracticePageState();
}

class _PronunciationPracticePageState extends State<PronunciationPracticePage>
    with TickerProviderStateMixin {
  List<String> get words => widget.words;

  int completedSentences = 0;

  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();

  String? selectedWord;
  bool isListening = false;
  String recognizedText = '';
  int currentWordIndex = 0;
  double confidence = 0.0;
  bool isCorrect = false;

  late AnimationController _pulseController;
  late AnimationController _successController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initialize();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _successController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _initialize() async {
    await _speechToText.initialize();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.6);
    setState(() {
      selectedWord = words[currentWordIndex];
    });
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: "vi-VN", // Sử dụng tiếng Việt cho nhận diện
    );
    setState(() {
      isListening = true;
      recognizedText = '';
      confidence = 0.0;
      isCorrect = false;
    });
    _pulseController.repeat(reverse: true);
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      isListening = false;
    });
    _pulseController.stop();
    _pulseController.reset();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      recognizedText = result.recognizedWords;
      confidence = result.confidence;
    });
    _checkPronunciation();
  }

  void _checkPronunciation() {
    if (recognizedText
            .toLowerCase()
            .contains((selectedWord ?? "").toLowerCase()) &&
        confidence > 0.6) {
      setState(() {
        isCorrect = true;
        completedSentences++;
      });
      _successController.forward().then((_) {
        _successController.reverse();
      });
      _showCustomSnackBar("Tuyệt vời! Phát âm chính xác! 🎉", true);
      Future.delayed(Duration(seconds: 2), () {
        _nextWord();
      });
    } else if (recognizedText.isNotEmpty) {
      _showCustomSnackBar("Hãy thử lại! Phát âm: '$selectedWord'", false);
    }
  }

  void _nextWord() {
    setState(() {
      currentWordIndex = (currentWordIndex + 1) % words.length;
      selectedWord = words[currentWordIndex];
      recognizedText = '';
      confidence = 0.0;
      isCorrect = false;
    });
  }

  void _speakWord() async {
    await flutterTts.speak(selectedWord ?? "");
  }

  void _showCustomSnackBar(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error_outline,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green[600] : Colors.orange[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalSentences = words.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Luyện phát âm',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF95785E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF95785E), Color(0xFFB8956A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Progress Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: PronunciationProgress(
                completedSentences: completedSentences,
                totalSentences: totalSentences,
              ),
            ),

            SizedBox(height: 30),

            // Instruction Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4FC3F7).withOpacity(0.1),
                    Color(0xFF29B6F6).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFF29B6F6).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF29B6F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.record_voice_over,
                      color: Color(0xFF29B6F6),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Chạm vào micro và phát âm từ được hiển thị",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF29B6F6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // Word Display Section
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: isCorrect
                              ? Colors.green.withOpacity(0.3)
                              : Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                      border: isCorrect
                          ? Border.all(color: Colors.green, width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Từ cần phát âm:",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          selectedWord ?? "",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF95785E),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (recognizedText.isNotEmpty) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green[50]
                                  : Colors.orange[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCorrect
                                    ? Colors.green[200]!
                                    : Colors.orange[200]!,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Kết quả nhận diện:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  recognizedText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isCorrect
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                  ),
                                ),
                                Text(
                                  "Độ tin cậy: ${(confidence * 100).toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 50),

            // Control Buttons Section
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Play Button
                  _buildControlButton(
                    onPressed: !isListening ? _speakWord : null,
                    icon: Icons.volume_up,
                    label: "Nghe",
                    color: Colors.blue,
                    isEnabled: !isListening,
                  ),

                  // Microphone Button
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isListening ? _pulseAnimation.value : 1.0,
                        child: _buildMainMicButton(),
                      );
                    },
                  ),

                  // Next Button
                  _buildControlButton(
                    onPressed: !isListening ? _nextWord : null,
                    icon: Icons.skip_next,
                    label: "Tiếp",
                    color: Colors.green,
                    isEnabled: !isListening,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required bool isEnabled,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isEnabled ? color.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isEnabled ? color.withOpacity(0.3) : Colors.grey[300]!,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onPressed,
              child: Icon(
                icon,
                color: isEnabled ? color : Colors.grey,
                size: 28,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isEnabled ? color : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMainMicButton() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isListening
                  ? [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]
                  : [Color(0xFFDA47F4), Color(0xFFE47BF4)],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: (isListening ? Color(0xFFFF6B6B) : Color(0xFFDA47F4))
                    .withOpacity(0.4),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: isListening ? _stopListening : _startListening,
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          isListening ? "Đang nghe..." : "Bắt đầu",
          style: TextStyle(
            fontSize: 14,
            color: isListening ? Color(0xFFFF6B6B) : Color(0xFFDA47F4),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
