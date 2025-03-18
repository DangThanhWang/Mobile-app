import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/Pronunciation/Pronunciation_Practice.dart';

class Pronunciation extends StatelessWidget {
  final String audioPath;
  final String title;
  final String tip1;
  final String tip2;
  final String tip3;

  final List<String> words;

  // Constructor nhận audioPath và title
  Pronunciation(
      {required this.audioPath,
      required this.title,
      required this.tip1,
      required this.tip2,
      required this.tip3,
      required this.words});

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await audioPlayer.play(AssetSource(audioPath));
                print("hehe");
              },
              child: Text("Play Audio"),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mẹo:  ",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip1,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          tip2,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          tip3,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PronunciationPracticePage(words: words),
                  ),
                );
              },
              child: Text(
                "Luyện tập ngay",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
