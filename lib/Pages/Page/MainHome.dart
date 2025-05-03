import 'package:app/Components/Footer/Menu.dart';
import 'package:app/Definitons/global.dart';
import 'package:app/Definitons/size_config.dart';
import 'package:app/Pages/Pronunciation/Pronunciation_Topic.dart';
import 'package:app/Pages/Ranking/RankingPage.dart';
import 'package:app/Pages/Home/HomePage.dart';
import 'package:app/Pages/News/NewsPage.dart';
import 'package:app/Pages/Profile/UserProfilePage.dart';
import 'package:app/Pages/ChatBox/ChatBox.dart';
import 'package:app/Widgets/ChatBox/RoomChatBox.dart';
import 'package:app/Widgets/Dictionary/Dictionary.dart';
import 'package:flutter/material.dart';

import '../../Widgets/Dictionary/FloatingDictionaryButton.dart';
import '../../Widgets/ChatBox/ChatboxButton.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final PageController _pageController;
  int _pageIndex = 0;
  final roomService = RoomService();

  String? roomId = globalRooms;

  // Variables for tracking dictionary button position
  double _dictionaryXPosition = 40.0;
  double _dictionaryYPosition = 480.0;

  // Variables for tracking chatbox button position
  double _chatboxXPosition = 500.0;
  double _chatboxYPosition = 480.0;

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

    // Ensure the buttons stay within screen bounds
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
            left: _dictionaryXPosition.clamp(
                0.0, screenWidth - 80), // Keep within horizontal bounds
            top: _dictionaryYPosition.clamp(
                0.0, screenHeight - 160), // Keep within vertical bounds
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _dictionaryXPosition += details.delta.dx;
                  _dictionaryYPosition += details.delta.dy;
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

          // Draggable Floating ChatBox Button
          Positioned(
            left: _chatboxXPosition.clamp(
                0.0, screenWidth - 100), // Keep within horizontal bounds
            top: _chatboxYPosition.clamp(
                0.0, screenHeight - 160), // Keep within vertical bounds
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _chatboxXPosition += details.delta.dx;
                  _chatboxYPosition += details.delta.dy;
                });
              },
              onTap: () async {
                final userId = globalUserId; // lấy từ Auth hoặc Provider
                final roomService = RoomService();
                try {
                  final roomId =
                      await roomService.createRoom(userId!, 'New Room');
                  globalRooms = roomId;
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      // ignore: void_checks
                      builder: (context) => ChatBox(
                        roomId: roomId,
                        roomName: 'New Room',
                      ),
                    ),
                  );
                } catch (e) {
                  print("Lỗi tạo phòng: $e");
                  // Hiển thị thông báo lỗi nếu cần
                }
              },
              child: ChatBoxButton(
                onTap: () async {
                  final userId = globalUserId; // lấy từ Auth hoặc Provider
                  final roomService = RoomService();
                  try {
                    final roomId =
                        await roomService.createRoom(userId!, 'New Room');
                    globalRooms = roomId;
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // ignore: void_checks
                        builder: (context) => ChatBox(
                          roomId: roomId,
                          roomName: 'New Room',
                        ),
                      ),
                    );
                  } catch (e) {
                    print("Lỗi tạo phòng: $e");
                    // Hiển thị thông báo lỗi nếu cần
                  }
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
