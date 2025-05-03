import 'package:app/Definitons/global.dart';
import 'package:app/Pages/ChatBox/ChatBox.dart';
import 'package:app/Widgets/ChatBox/RoomChatBox.dart';
import 'package:flutter/material.dart';
import 'package:app/Database/mongoDB.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State, Center;
import 'package:intl/intl.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllChatsScreenState createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final collection = await MongoDBDatabase.getCollection('Rooms');

      // Lấy userId từ người dùng hiện tại (đây là ví dụ, thay thế bằng mã lấy userId thực tế)
      final String? currentUserId = globalUserId;

      // Tìm tất cả các phòng của người dùng
      final cursor = collection.find(where.eq('userId', currentUserId));
      final List<Map<String, dynamic>> rooms = await cursor.toList();

      // Sắp xếp theo thời gian cập nhật gần nhất
      rooms.sort((a, b) => DateTime.parse(b['updatedAt'])
          .compareTo(DateTime.parse(a['updatedAt'])));

      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải danh sách cuộc trò chuyện: $e')),
      );
    }
  }

  // Xóa một phòng chat
  Future<void> _deleteRoom(String roomId) async {
    try {
      final roomService = RoomService();
      await roomService.deleteRoom(roomId);

      setState(() {
        _rooms.removeWhere((room) => room['roomId'] == roomId);
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa cuộc trò chuyện')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xóa cuộc trò chuyện: $e')),
      );
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tất cả cuộc trò chuyện'),
        backgroundColor: const Color(0xFF7C72E5),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Bạn chưa có cuộc trò chuyện nào',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    final List messages = room['messages'] ?? [];
                    final lastMessage =
                        messages.isNotEmpty ? messages.last : null;

                    return Dismissible(
                      key: Key(room['roomId']),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: const Text(
                                'Bạn có chắc muốn xóa cuộc trò chuyện này?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Xóa'),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        _deleteRoom(room['roomId']);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF7C72E5).withOpacity(0.2),
                          child:
                              const Icon(Icons.chat, color: Color(0xFF7C72E5)),
                        ),
                        title: Text(
                          room['roomName'] ?? 'Cuộc trò chuyện',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (lastMessage != null)
                              Text(
                                lastMessage['text'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            Text(
                              'Cập nhật: ${_formatDate(room['updatedAt'])}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${messages.length} tin nhắn',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          // Điều hướng đến màn hình chat với roomId này
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // ignore: void_checks
                                  ChatBox(
                                      // ignore: void_checks
                                      roomId: room['roomId'],
                                      roomName: room['roomName'] ??
                                          'Cuộc trò chuyện'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
