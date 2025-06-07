import 'package:flutter/material.dart';
import '../Dictionary/Dictionary.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xF98C725E),
        fontFamily: 'Rubik',
      ),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xF98C725E).withOpacity(0.9),
                  Color(0xF98C725E).withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Color(0xF98C725E).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              'Vocabulary Flashcards',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF5F1EB),
                Color(0xFFEDE7DD),
                Color(0xFFE8DDD0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Dictionary(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FlashcardList extends StatefulWidget {
  List<Map<String, String>> words = [];

  FlashcardList({required this.words});

  @override
  _FlashcardListState createState() => _FlashcardListState();
}

class _FlashcardListState extends State<FlashcardList>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.words;

    return words.isEmpty
        ? Center(
            child: Container(
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xF98C725E).withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xF98C725E)),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Đang tải từ vựng...',
                    style: TextStyle(
                      color: Color(0xF98C725E),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : SlideTransition(
            position: _slideAnimation,
            child: Container(
              height: 420,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: PageView.builder(
                itemCount: words.length,
                controller: PageController(viewportFraction: 0.85),
                itemBuilder: (context, index) {
                  final word = words[index];
                  if (word['word'] == null || word['definition'] == null) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          'Dữ liệu từ vựng không hợp lệ',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                      ),
                    );
                  }
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        // Navigation logic here
                      },
                      child: Flashcard(
                        word: word['word'] ?? '',
                        definition: word['definition'] ?? '',
                      ),
                    ),
                  );
                },
              ),
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

class _FlashcardState extends State<Flashcard> with TickerProviderStateMixin {
  bool _isFlipped = false;
  bool _showContent = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Subtle pulse animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
      _showContent = false;
    });

    Future.delayed(Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final rotate = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animation, curve: Curves.easeInOut));
                  return RotationYTransition(turns: rotate, child: child);
                },
                child: _isFlipped ? _buildDefinitionCard() : _buildWordCard(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWordCard() {
    return _buildCardContent(
      widget.word,
      alignment: Alignment.center,
      isWord: true,
    );
  }

  Widget _buildDefinitionCard() {
    return _buildCardContent(
      widget.definition,
      alignment: Alignment.center,
      isWord: false,
    );
  }

  Widget _buildCardContent(
    String text, {
    Alignment alignment = Alignment.center,
    bool isWord = true,
  }) {
    return SizedBox(
      key: ValueKey(text),
      width: double.infinity,
      height: 350,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isWord
                ? [
                    Color(0xF98C725E),
                    Color(0xF98C725E).withOpacity(0.8),
                    Color(0xF9A67C52),
                  ]
                : [
                    Color(0xF9A67C52),
                    Color(0xF98C725E).withOpacity(0.9),
                    Color(0xF9704638),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Color(0xF98C725E).withOpacity(0.4),
              blurRadius: 25,
              offset: Offset(0, 15),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon indicator
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isWord ? Icons.translate : Icons.lightbulb_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Main content
                  Expanded(
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _showContent ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: text.length > 20 ? 28 : 36,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  // Bottom indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isWord ? 'Từ vựng' : 'Định nghĩa',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
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
    final angle = turns.value * 3.1415926535897932;

    if (angle >= 1.5708) {
      return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(3.1415926535897932),
        alignment: Alignment.center,
        child: angle > 1.5708
            ? Transform(
                transform: Matrix4.identity()..rotateY(3.1415926535897932),
                alignment: Alignment.center,
                child: child,
              )
            : child,
      );
    } else {
      return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle),
        alignment: Alignment.center,
        child: child,
      );
    }
  }
}
