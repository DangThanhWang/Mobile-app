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
  // ignore: library_private_types_in_public_api
  _PronunciationPracticePageState createState() =>
      _PronunciationPracticePageState();
}

class _PronunciationPracticePageState extends State<PronunciationPracticePage> {
  List<String> get words => widget.words;

  int completedSentences = 0;

  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();

  String? selectedWord;
  bool isListening = false;
  String recognizedText = '';
  int currentWordIndex = 0;
  double confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _speechToText.initialize();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    setState(() {
      selectedWord = words[currentWordIndex];
    });
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      isListening = true;
      recognizedText = '';
      confidence = 0.0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      recognizedText = result.recognizedWords;
      confidence = result.confidence;
      _checkPronunciation();
    });
  }

  void _checkPronunciation() {
    if (recognizedText.toLowerCase() == (selectedWord ?? "").toLowerCase() &&
        confidence > 0.8) {
      _showSnackBar("Phát âm chính xác!");
      _nextWord();
      setState(() {
        completedSentences++;
      });
    } else {
      _showSnackBar("Phát âm chưa chính xác. Hãy thử lại!");
    }
  }

  void _nextWord() {
    setState(() {
      currentWordIndex = (currentWordIndex + 1) % words.length;
      selectedWord = words[currentWordIndex];
      recognizedText = '';
      confidence = 0.0;
    });
  }

  void _speakWord() async {
    await flutterTts.speak(selectedWord ?? "");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    int totalSentences = words.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Luyện phát âm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PronunciationProgress(
              completedSentences: completedSentences,
              totalSentences: totalSentences,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/users/chatbot.png",
                  width: 35,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "Your turn! Tap the microphone and pronounce the word",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  Text(
                    selectedWord ?? "",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text("Kết quả nhận diện: $recognizedText"),
                  Text("Độ tin cậy: ${(confidence * 100).toStringAsFixed(2)}%"),
                  SizedBox(height: 300),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                        ),
                        onPressed: !isListening ? _speakWord : null,
                        child: SvgPicture.asset(
                          "assets/svg/play_record.svg",
                          width: 20,
                          // ignore: deprecated_member_use
                          color: !isListening ? null : Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(186, 218, 71, 244),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                        ),
                        onPressed:
                            isListening ? _stopListening : _startListening,
                        child: Icon(
                          isListening ? Icons.mic : Icons.mic_off,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                        ),
                        onPressed: !isListening ? _nextWord : null,
                        child: Icon(
                          Icons.chevron_right_sharp,
                          size: 24,
                          color: !isListening ? null : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
