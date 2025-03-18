import 'package:flutter/material.dart';
import 'package:app/Widgets/Home/Level_Home.dart';
import 'package:app/Data/Home/data_home.dart';

import 'Topics/Topics.dart';

class HomeItem2 extends StatefulWidget {
  const HomeItem2({super.key});

  @override
  _HomeItem2 createState() => _HomeItem2();
}

class _HomeItem2 extends State<HomeItem2> {
  int currentLevel = 0;
  final PageController _pageController = PageController();

  void _onDotTapped(int index) {
    setState(() {
      currentLevel = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed LevelHome Widget
        LevelHome(
          currentLevel: currentLevel,
          onDotTap: _onDotTapped,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6, // Set height explicitly
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentLevel = index;
              });
            },
            itemCount: levels.keys.length,
            itemBuilder: (context, levelIndex) {
              int level = levels.keys.toList()[levelIndex];
              return ListView.builder(
                itemCount: levels[level]!.length,
                itemBuilder: (context, topicIndex) {
                  var topic = levels[level]![topicIndex];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Topic(topic: topic['title']),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: topic['color'],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                                      child: Text(
                                        "0/15",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 63,
                                      height: 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: 0.5,
                                          backgroundColor: Colors.green[200],
                                          valueColor: const AlwaysStoppedAnimation<Color>(
                                              Colors.green),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 28),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(44, 0, 0, 0),
                                  child: Text(
                                    topic['title'],
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 6,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(topic['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}






