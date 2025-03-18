import 'package:app/Components/Header/Header_Genral.dart';
import 'package:app/Data/IPA/ipa.dart';
import 'package:app/Pages/Pronunciation/Pronunciation.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Pronunciation_Topic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF95785E),
        elevation: 0,
        toolbarHeight: 70.0,
        flexibleSpace: Info(),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: ipaSounds.length,
        itemBuilder: (context, index) {
          String audioPath = 'audios/ipa/${index + 1}.mp3';
          String title = ipaSounds[index].symbol;
          String tip1 = ipaSounds[index].description;
          String tip2 = ipaSounds[index].mouthPosition;
          String tip3 = ipaSounds[index].tonguePosition;
          List<String> words = ipaSounds[index].examples;

          return ListTile(
            title: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 53, 157, 195),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Âm:  $title",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Pronunciation(
                    audioPath: audioPath,
                    title: title,
                    tip1: tip1,
                    tip2: tip2,
                    tip3: tip3,
                    words: words,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
