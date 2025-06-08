// ignore: file_names
import 'package:app/Components/Header/Home_Header.dart';
import 'package:app/Components/Header/Header_Genral.dart';
import 'package:flutter/material.dart';
import '../../Widgets/Home/HomeItem2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
