import 'package:flutter/material.dart';
import '../../helpers/dbHelper.dart';
import '../Dictionary/Dictionary.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFD2B48C),
          title: Center(child: Text('Vocabulary Flashcards')),
          //elevation: 1,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(300, 20, 0, 20),
              child: Dictionary(),
            ),
          ],
        ),
      ),
    );
  }
}

class FlashcardList extends StatefulWidget {
  List<Map<String, String>> words = [];

  FlashcardList({required this.words});

  @override
  _FlashcardListState createState() => _FlashcardListState();
}

class _FlashcardListState extends State<FlashcardList> {
  @override
  void initState() {
    super.initState();
    // DatabaseHelper().loadWords(widget.topic).then((loadedWords) {
    //   setState(() {
    //     words = loadedWords;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.words;
    print("Vocab List: $words");
    // Debugging statement
    return words.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Container(
            //color: Colors.brown,
            height: 400,
            // decoration: BoxDecoration(
            //   //color: Colors.brown,
            //   //borderRadius: BorderRadius.circular(12),
            //   // boxShadow: [
            //   //   BoxShadow(
            //   //     color: Colors.black26,
            //   //     blurRadius: 6,
            //   //     offset: Offset(0, 4),
            //   //   ),
            //   // ],
            // ),
            child: PageView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                if (word['word'] == null || word['definition'] == null) {
                  return Center(child: Text('Invalid vocab entry'));
                }
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => VocabDetailPage(
                    //       word: word['source'],
                    //       definition: word['target'],
                    //       EDefinition: word['definition'],
                    //       example: word['example'],
                    //       synonyms: word['synonyms'],
                    //       pronounce: word['pronounce'],
                    //       audio: word['audio'],
                    //       source: word['source'],
                    //       type: word['type'],
                    //       //targetLang: word['targetLang'],
                    //     ),
                    //   ),
                    // );
                  },
                  child: Flashcard(
                    word: word['word'] ?? '',
                    definition: word['definition'] ?? '',
                  ),
                );
              },
            ),
          );
  }
}

class Flashcard extends StatefulWidget {
  final String word;
  final String definition;

  Flashcard({required this.word, required this.definition});

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _isFlipped = false;
  bool _showContent = true;

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
    // Delay the appearance of the content (word/definition) by 0.2 seconds
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showContent = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showContent = false;
        _flipCard();
      },
      // Flip the card when tapped
      child: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500), // Animation duration
          transitionBuilder: (Widget child, Animation<double> animation) {
            final rotate = Tween(begin: 0.0, end: 1.0).animate(animation);
            return RotationYTransition(turns: rotate, child: child);
          },
          child: _isFlipped
              ? _buildDefinitionCard() // Show the definition when flipped
              : _buildWordCard(), // Show the word initially
        ),
      ),
    );
  }

  Widget _buildWordCard() {
    return _buildCardContent(widget.word, alignment: Alignment.center);
  }

  Widget _buildDefinitionCard() {
    return _buildCardContent(widget.definition, alignment: Alignment.center);
  }

  Widget _buildCardContent(String text,
      {Alignment alignment = Alignment.center}) {
    return SizedBox(
      key: ValueKey(text), // Unique key for each side of the card
      width: 400,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade400, Colors.brown.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8), // Match the Card's border radius
        ),
        child: Card(
          color: Colors.transparent, // Make the Card itself transparent
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: alignment,
              child: AnimatedOpacity(
                opacity: _showContent ? 1.0 : 0.0,
                duration: Duration(milliseconds: 200),
                // Fade-in effect for the content
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                      fontFamily: 'Rubik',
                      fontSize: 40,
                      fontWeight: FontWeight.normal),
                  textAlign: alignment == Alignment.center
                      ? TextAlign.center
                      : TextAlign.left,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  final Widget child;
  final Animation<double> turns;

  RotationYTransition({required this.turns, required this.child})
      : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final angle = turns.value * 3.1415926535897932; // π radians = 180 degrees
    return Transform(
      transform: Matrix4.rotationY(angle),
      alignment: Alignment.center,
      child: angle <
              1.5708 // Show only one side at a time (π / 2 radians = 90 degrees)
          ? child
          : Transform(
              transform: Matrix4.rotationY(3.1415926535897932),
              alignment: Alignment.center,
              child: child,
            ),
    );
  }
}
