import 'package:app/Components/Footer/Menu.dart';
import 'package:app/Definitons/size_config.dart';
import 'package:app/Pages/Pronunciation/Pronunciation_Topic.dart';
import 'package:app/Pages/Ranking/RankingPage.dart';
import 'package:app/Pages/Home/HomePage.dart';
import 'package:app/Pages/News/NewsPage.dart';
import 'package:app/Pages/Profile/UserProfilePage.dart';
import 'package:app/Widgets/Dictionary/Dictionary.dart';
import 'package:flutter/material.dart';

import '../../Widgets/Dictionary/FloatingDictionaryButton.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final PageController _pageController;
  int _pageIndex = 0;

  // Variables for tracking button position
  double _xPosition = 50.0; // Default horizontal position
  double _yPosition = 300.0; // Default vertical position

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);

    // Ensure the button stays within screen bounds
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // PageView for main pages
          PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _pageIndex = value;
              });
            },
            children: [
              const HomePage(),
              Pronunciation_Topic(),
              const NewsPage(),
              const RankingPage(),
              const UserProfilePage(),
            ],
          ),

          // Draggable Floating Dictionary Button
          Positioned(
            left: _xPosition.clamp(0.0, screenWidth - 80), // Keep within horizontal bounds
            top: _yPosition.clamp(0.0, screenHeight - 160), // Keep within vertical bounds
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _xPosition += details.delta.dx; // Update horizontal position
                  _yPosition += details.delta.dy; // Update vertical position
                });
              },
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Dictionary()),
                );
              },
              child: FloatingDictionaryButton(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Dictionary()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Menu(
          currentIndex: _pageIndex,
          pageController: _pageController,
          onTap: (value) {
            _pageController.jumpToPage(value);
          },
        ),
      ),
    );
  }
}

