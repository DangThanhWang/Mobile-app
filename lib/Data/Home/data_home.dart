import 'package:flutter/material.dart';

import '../../Widgets/Home/Topics/Topics.dart';

final List<String> entries = <String>[
  'Animals',
  'Transportation',
  'Family',
  'Nature',
];
// final List<Widget> pages = <Widget>[
//   Animals(),
//   Cities(),
//   Alphabet(),
//   Nature(),
// ];
final List<Widget> pages = <Widget>[
  Topic(topic: 'Animals'),
  Topic(topic: 'Transportation'),
  Topic(topic: 'Family'),
  Topic(topic: 'Nature'),
];
final List<String> images = <String>[
  'assets/images/home/animals.png',
  'assets/images/home/transportation.png',
  'assets/images/home/alphabet.png',
  'assets/images/home/park.png'
];
final List<Color> colorCodes = <Color>[
  Color(0xFFA1D7FF),
  Color(0xFF6AFF5D),
  Color(0xFFFFDA35),
  Color(0xFFFF8D8D)
];

final Map<int, List<Map<String, dynamic>>> levels = {
  1: [
    {
      'title': 'Animals',
      'image': 'assets/images/home/animals.png',
      'color': Color(0xFFA1D7FF)
    },
    {
      'title': 'Transportation',
      'image': 'assets/images/home/transportation.png',
      'color': Color(0xFF6AFF5D)
    },
    {
      'title': 'Family',
      'image': 'assets/images/home/family.png',
      'color': Color(0xFFFFDA35)
    },
    {
      'title': 'Nature',
      'image': 'assets/images/home/nature.png',
      'color': Color(0xFFFF8D8D)
    },
  ],
  2: [
    {
      'title': 'Science',
      'image': 'assets/images/home/science.png',
      'color': Color(0xFFA1E0FF)
    },
    {
      'title': 'Music',
      'image': 'assets/images/home/music.png',
      'color': Color(0xFFFAFF5D)
    },
    {
      'title': 'History',
      'image': 'assets/images/home/history.png',
      'color': Color(0xFFFADA35)
    },
    {
      'title': 'Art',
      'image': 'assets/images/home/art.png',
      'color': Color(0xFFFF6D8D)
    },
  ],
};
