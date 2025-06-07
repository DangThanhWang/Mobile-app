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

// Tạo ChatBotPage như một widget riêng
class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  String? roomId;
  bool isLoading = true;
  String? error;
  final roomService = RoomService();

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
  }

  Future<void> _initializeChatRoom() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final userId = globalUserId;
      if (userId == null) {
        setState(() {
          error = 'Vui lòng đăng nhập để sử dụng chatbot';
          isLoading = false;
        });
        return;
      }

      // Tạo room mới hoặc sử dụng room hiện tại
      String newRoomId;
      if (globalRooms != null) {
        newRoomId = globalRooms!;
      } else {
        newRoomId = await roomService.createRoom(userId, 'Cuộc trò chuyện với AI');
        globalRooms = newRoomId;
      }

      setState(() {
        roomId = newRoomId;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Không thể tạo cuộc trò chuyện: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _createNewChat() async {
    try {
      setState(() {
        isLoading = true;
      });

      final userId = globalUserId;
      if (userId == null) return;

      final newRoomId = await roomService.createRoom(userId, 'Cuộc trò chuyện mới với AI');
      globalRooms = newRoomId;

      setState(() {
        roomId = newRoomId;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Không thể tạo cuộc trò chuyện mới: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot AI'),
          backgroundColor: const Color(0xFF7C72E5),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF7C72E5),
              ),
              SizedBox(height: 16),
              Text('Đang khởi tạo cuộc trò chuyện...'),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot AI'),
          backgroundColor: const Color(0xFF7C72E5),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initializeChatRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C72E5),
                ),
                child: const Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (roomId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot AI'),
          backgroundColor: const Color(0xFF7C72E5),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Text('Đã xảy ra lỗi không xác định'),
        ),
      );
    }

    // Sử dụng ChatBox với wrapper AppBar
    return Scaffold(
      body: ChatBox(
        roomId: roomId!,
        roomName: 'Chatbot AI',
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final PageController _pageController;
  int _pageIndex = 0;

  // Variables for tracking dictionary button position only
  double _dictionaryXPosition = 40.0;
  double _dictionaryYPosition = 480.0;

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

    // Ensure the dictionary button stays within screen bounds
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
              const HomePage(),                // Index 0: Home
              Pronunciation_Topic(),           // Index 1: Pronunciation
              const NewsPage(),               // Index 2: News
              const ChatBotPage(),            // Index 3: Chatbot AI
              const UserProfilePage(),        // Index 4: Profile
            ],
          ),

          // Chỉ giữ lại Floating Dictionary Button
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
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Menu(
          currentIndex: _pageIndex,
          pageController: _pageController,
          onTap: (value) {
            // Tất cả các tab hoạt động bình thường với PageView
            _pageController.jumpToPage(value);
          },
        ),
      ),
    );
  }
}