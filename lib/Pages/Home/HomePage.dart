import 'package:app/Components/Header/Home_Header.dart';
import 'package:app/Components/Header/Header_Genral.dart';
import 'package:app/Definitons/size_config.dart';
import 'package:app/Widgets/Dictionary/Dictionary.dart';
import 'package:app/Widgets/Home/Level_Home.dart';
import 'package:app/Widgets/Home/HomeItem.dart';
import 'package:flutter/material.dart';

import '../../Widgets/Dictionary/FloatingDictionaryButton.dart';
import '../../Widgets/Home/HomeItem2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C72E5),
        elevation: 0,
        flexibleSpace: const Info(),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFF1F1F1),
            child: SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  // Add Home_Header directly if it's already a sliver
                  Home_Header(),
                  // Ensure HomeItem2 is wrapped correctly
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: HomeItem2(),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}