import 'package:app/Definitons/global.dart';
import 'package:app/Pages/ChatBox/ChatBox.dart';
import 'package:app/Widgets/ChatBox/RoomChatBox.dart';
import 'package:flutter/material.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final roomService = RoomService();

      // Lấy userId của người dùng hiện tại
      final String currentUserId = _getCurrentUserId();

      // Tạo phòng mới
      final roomId = await roomService.createRoom(
        currentUserId,
        _roomNameController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      // ignore: use_build_context_synchronously
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã tạo phòng chat mới')),
        );

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            // ignore: void_checks
            builder: (context) => ChatBox(
                roomId: roomId, roomName: _roomNameController.text.trim()),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tạo phòng chat: $e')),
      );
    }
  }

  // Lấy userId của người dùng hiện tại
  String _getCurrentUserId() {
    String userId = globalUserId!;
    return userId; // Giá trị mẫu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo cuộc trò chuyện mới'),
        backgroundColor: const Color(0xFF7C72E5),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _roomNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên cuộc trò chuyện',
                  hintText: 'Nhập tên cho cuộc trò chuyện mới',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.chat_bubble_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên cuộc trò chuyện';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _createRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C72E5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Tạo cuộc trò chuyện',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
