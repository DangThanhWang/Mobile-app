import 'package:app/Components/HomeTopButton.dart';
import 'package:app/Pages/GuessTheDefinition/GuessTheDefiniton.dart';
import 'package:app/Pages/MultipleChoice/MultipleChoice.dart';
import 'package:app/Widgets/Home/Topics/TopicChips.dart';
import 'package:app/helpers/dbHelper.dart';
import 'package:flutter/material.dart';

import '../../../Data/Home/data_home.dart';
import '../../Flashcard/Flashcard.dart';

class Topic extends StatefulWidget {
  final String topic;

  const Topic({super.key, required this.topic});

  @override
  // ignore: library_private_types_in_public_api
  _Topic createState() => _Topic();
}

class _Topic extends State<Topic> {
  List<Map<String, String>> words = [];

  @override
  void initState() {
    super.initState();
    DatabaseHelper().loadWords(widget.topic).then((loadedWords) {
      setState(() {
        words = loadedWords;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade800,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          widget.topic,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 60, // Tăng chiều cao của header
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FlashcardList(words: words),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildTestButton(
                      "Kiểm tra nghĩa",
                      Icons.translate,
                      const Color(0xF98C725E),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestPage(
                            words: words,
                            topic: widget.topic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildTestButton(
                      "Kiểm tra từ",
                      Icons.spellcheck,
                      const Color(0xF98C725E),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Guessthedefiniton(
                              words: words, topic: widget.topic),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TopicChips(currentTopic: widget.topic, levels: levels),
          ],
        ),
      ),
    );
  }
}

Widget _buildTestButton(
    String title, IconData icon, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          Icon(Icons.chevron_right, color: Colors.white, size: 28),
        ],
      ),
    ),
  );
}
