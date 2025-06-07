import 'package:app/Definitons/global.dart';
import 'package:app/Pages/ChatBox/ChatBox.dart';
import 'package:app/Widgets/ChatBox/RoomChatBox.dart';
import 'package:flutter/material.dart';

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

        body: const Center(
          child: Text('Đã xảy ra lỗi không xác định'),
        ),
      );
    }

    // Wrap ChatBox trong một Scaffold có AppBar tùy chỉnh
    return Scaffold(

      body: ChatBox(
        roomId: roomId!,
        roomName: 'Chatbot AI',
      ),
    );
  }
}