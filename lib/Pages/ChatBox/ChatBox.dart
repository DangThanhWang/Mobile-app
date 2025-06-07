import 'package:app/Database/mongoDB.dart';
import 'package:app/Widgets/ChatBox/RoomChatBox.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:app/Services/ChatBotApiService.dart';
import 'package:app/Definitons/global.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Center, State;

class ChatBox extends StatefulWidget {
  final String roomId;
  final String roomName;
  const ChatBox({super.key, required this.roomId, required this.roomName});
  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FocusNode _focusNode = FocusNode();
  late AnimationController _sendButtonController;
  late AnimationController _typingIndicatorController;
  late AnimationController _fadeController;
  bool _isComposing = false;
  bool _showTypingIndicator = false;
  final roomService = RoomService();

  Future<void> _loadMessages() async {
    try {
      final collection = await MongoDBDatabase.getCollection('Rooms');
      final room = await collection.findOne(where.eq('roomId', widget.roomId));

      if (room != null && room.containsKey('messages')) {
        List messages = room['messages'];

        // Clear existing messages in UI
        setState(() {
          _messages.clear();
        });

        // Add messages to UI in reverse order (oldest first)
        for (var message in messages) {
          final ChatMessage chatMessage = ChatMessage(
            text: message['text'],
            isUser: message['sender'] == 'user',
            animationController: AnimationController(
              duration: const Duration(
                  milliseconds: 0), // No animation for loaded messages
              vsync: this,
            ),
          );

          setState(() {
            _messages.insert(0, chatMessage);
          });
          chatMessage.animationController.forward();
        }
      }
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  // Save message to database
  Future<void> _saveMessageToDatabase(String sender, String text) async {
    try {
      await roomService.addMessageToRoom(widget.roomId, sender, text);
      print('Message saved to database: $sender - $text');
    } catch (e) {
      print('Error saving message: $e');

      // Show error message if room is full
      if (e.toString().contains("Phòng đã đầy")) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Phòng đã đầy. Hãy tạo phòng mới.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> deleteMessageFromDatabase(String roomId) async {
    try {
      await roomService.deleteMessage(roomId);
      setState(() {
        _messages.clear();
      });
      print('Message deleted from database: $roomId');
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _typingIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeController.forward();
    print(widget.roomId);

    // Add initial welcome message and save to database
    final welcomeMessage =
        "Xin chào! Tôi là trợ lý học tập của bạn. Hãy cho tôi biết tôi có thể giúp gì cho bạn hôm nay?";
    _addBotMessage(welcomeMessage);

    // Load existing messages for this room
    _loadMessages();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _sendButtonController.dispose();
    _typingIndicatorController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
      _showTypingIndicator = true;
    });

    final ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
    _saveMessageToDatabase("user", text);

    // Simulate bot response after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _showTypingIndicator = false;
      });

      _respondToMessage(text);
    });
  }

  void _respondToMessage(String text) {
    try {
      // Show temporary processing message
      _addBotMessage("Đang xử lý...");

      // Use custom ChatBot API instead of Gemini
      print("User ID: $globalUserId");
      ChatBotApiService.sendMessage(text, globalUserId ?? 'anonymous').then((response) {
        print("Nhận được phản hồi từ ChatBot API");
        if (response != null && response['status'] == 'success') {
          // Remove temporary processing message
          setState(() {
            if (_messages.isNotEmpty && _messages[0].text == "Đang xử lý...") {
              _messages.removeAt(0);
            }
          });

          // Get bot response text
          final botResponse = response['response'] ?? 'Không có phản hồi';

          // Add bot message to UI
          final ChatMessage message = ChatMessage(
            text: botResponse,
            isUser: false,
            animationController: AnimationController(
              duration: const Duration(milliseconds: 500),
              vsync: this,
            ),
          );

          setState(() {
            _messages.insert(0, message);
          });
          message.animationController.forward();

          // Save bot message to database
          _saveMessageToDatabase("bot", botResponse);
        } else {
          setState(() {
            if (_messages.isNotEmpty && _messages[0].text == "Đang xử lý...") {
              _messages.removeAt(0);
              _addBotMessage("Không nhận được phản hồi từ trợ lý");

              // Save error message to database
              _saveMessageToDatabase("bot", "Không nhận được phản hồi từ trợ lý");
            }
          });
        }
      }).catchError((error) {
        print('Lỗi ChatBot API: $error');
        setState(() {
          if (_messages.isNotEmpty && _messages[0].text == "Đang xử lý...") {
            _messages.removeAt(0);
          }

          final errorMessage = "Xin lỗi, đã xảy ra lỗi khi kết nối đến dịch vụ.";
          _addBotMessage(errorMessage);

          // Save error message to database
          _saveMessageToDatabase("bot", errorMessage);
        });
      });
    } catch (e) {
      print('Lỗi khởi tạo request: $e');
      final errorMessage = "Đã xảy ra lỗi khi kết nối đến dịch vụ.";
      _addBotMessage(errorMessage);

      // Save error message to database
      _saveMessageToDatabase("bot", errorMessage);
    }
  }

  void _addBotMessage(String text) {
    final ChatMessage message = ChatMessage(
      text: text,
      isUser: false,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C72E5), Color(0xFF5C52DB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Hero(
              tag: 'chatAvatar',
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avar_chatbox.jpg'),
                  backgroundColor: Colors.white,
                  radius: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.roomName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Đang hoạt động',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.more_vert, color: Colors.white),
            ),
            onPressed: () {
              // Show options menu
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => _buildOptionsSheet(),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Chat history
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/chat_background.jpg'),
                    opacity: 0.03,
                    fit: BoxFit.cover,
                  ),
                ),
                child: _messages.isEmpty
                    ? FadeTransition(
                  opacity: _fadeController,
                  child: _buildEmptyChat(),
                )
                    : ListView.builder(
                  reverse: true,
                  itemCount:
                  _messages.length + (_showTypingIndicator ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_showTypingIndicator && index == 0) {
                      return _buildTypingIndicator();
                    }
                    final adjustedIndex =
                    _showTypingIndicator ? index - 1 : index;
                    return _messages[adjustedIndex];
                  },
                ),
              ),
            ),
            // Typing suggestions
            _buildSuggestionChips(),
            // Input area
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7C72E5).withOpacity(0.1),
                  const Color(0xFF5C52DB).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C72E5).withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 60,
              color: const Color(0xFF7C72E5).withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Bắt đầu cuộc trò chuyện',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C72E5),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Hãy đặt câu hỏi hoặc chọn một gợi ý bên dưới để bắt đầu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: const AssetImage('assets/images/avar_chatbox.jpg'),
            backgroundColor: Colors.grey[200],
            radius: 16,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(
                3,
                    (index) => AnimatedBuilder(
                  animation: _typingIndicatorController,
                  builder: (context, child) {
                    final double value = math.sin(
                      _typingIndicatorController.value * math.pi * 2 +
                          index * (math.pi / 2),
                    );
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8 + (value + 1) * 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF7C72E5),
                            const Color(0xFF5C52DB),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips() {
    final suggestions = [
      "Giúp tôi học tiếng Anh",
      "Cách sử dụng thì hiện tại đơn",
      "Giúp tôi luyện phát âm",
      "Bài tập ngữ pháp",
    ];

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _handleSubmitted(suggestions[index]),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF7C72E5).withOpacity(0.1),
                        const Color(0xFF5C52DB).withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF7C72E5).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    suggestions[index],
                    style: const TextStyle(
                      color: Color(0xFF7C72E5),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  // Show attachment options
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => _buildAttachmentSheet(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.add_circle,
                    color: Color(0xFF7C72E5),
                    size: 28,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                  onSubmitted: _isComposing ? _handleSubmitted : null,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _sendButtonController,
              builder: (context, child) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : () {
                      // Handle voice input
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          const Text('Tính năng ghi âm đang được phát triển'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF7C72E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: _isComposing
                            ? Container(
                          key: const ValueKey('send'),
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7C72E5), Color(0xFF5C52DB)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                            : const Icon(
                          Icons.mic_rounded,
                          key: ValueKey('mic'),
                          color: Color(0xFF7C72E5),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSheet() {
    final options = [
      {
        'icon': Icons.delete_outline,
        'title': 'Xóa lịch sử trò chuyện',
        'color': Colors.red,
      },
      {
        'icon': Icons.note_alt_outlined,
        'title': 'Tất cả cuộc trò chuyện',
        'route': '/all-chats',
        'color': Colors.blue,
      },
      {
        'icon': Icons.chat,
        'title': 'Phòng chat mới',
        'route': '/new-chat',
        'color': Colors.green,
      },
      {
        'icon': Icons.help_outline,
        'title': 'Trợ giúp',
        'route': '/help',
        'color': Colors.orange,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          ...options.map((option) {
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (option['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option['icon'] as IconData,
                  color: option['color'] as Color,
                ),
              ),
              title: Text(
                option['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context); // Đóng options sheet
                if (option['title'] == 'Xóa lịch sử trò chuyện') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text('Xác nhận'),
                      content: const Text(
                          'Bạn có chắc chắn muốn xoá toàn bộ lịch sử trò chuyện không?'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(), // Đóng dialog
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng dialog
                            deleteMessageFromDatabase(widget.roomId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Đã xoá lịch sử trò chuyện.'),
                                backgroundColor: Colors.green.shade600,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Xoá',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.pushNamed(context, option['route'] as String);
                }
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAttachmentSheet() {
    final attachments = [
      {'icon': Icons.image, 'title': 'Hình ảnh', 'color': Colors.green},
      {'icon': Icons.camera_alt, 'title': 'Máy ảnh', 'color': Colors.blue},
      {'icon': Icons.mic, 'title': 'Ghi âm', 'color': Colors.orange},
      {'icon': Icons.description, 'title': 'Tài liệu', 'color': Colors.purple},
      {'icon': Icons.location_on, 'title': 'Vị trí', 'color': Colors.red},
      {'icon': Icons.contact_page, 'title': 'Liên hệ', 'color': Colors.teal},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Đính kèm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: attachments.length,
            itemBuilder: (context, index) {
              final attachment = attachments[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Show snackbar for demo purposes
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã chọn: ${attachment['title']}'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF7C72E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              (attachment['color'] as Color).withOpacity(0.2),
                              (attachment['color'] as Color).withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          attachment['icon'] as IconData,
                          color: attachment['color'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        attachment['title'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.animationController,
  });

  final String text;
  final bool isUser;
  final AnimationController animationController;

  // Function to parse text with **bold** formatting
  List<TextSpan> _parseText(String text) {
    final List<TextSpan> spans = [];
    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    int lastEnd = 0;

    for (final match in boldRegex.allMatches(text)) {
      // Add normal text before the bold text
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15,
            height: 1.5,
          ),
        ));
      }

      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 15,
          height: 1.5,
        ),
      ));

      lastEnd = match.end;
    }

    // Add any remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black87,
          fontSize: 15,
          height: 1.5,
        ),
      ));
    }

    return spans.isEmpty
        ? [
      TextSpan(
        text: text,
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black87,
          fontSize: 15,
          height: 1.5,
        ),
      )
    ]
        : spans;
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutQuad,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Row(
          mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              CircleAvatar(
                backgroundImage:
                const AssetImage('assets/images/avar_chatbox.jpg'),
                backgroundColor: Colors.grey[200],
                radius: 16,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isUser
                      ? const LinearGradient(
                    colors: [Color(0xFF7C72E5), Color(0xFF5C52DB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: isUser ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20).copyWith(
                    bottomLeft: isUser
                        ? const Radius.circular(20)
                        : const Radius.circular(5),
                    bottomRight: isUser
                        ? const Radius.circular(5)
                        : const Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isUser
                          ? const Color(0xFF7C72E5).withOpacity(0.3)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: RichText(
                  text: TextSpan(
                    children: _parseText(text),
                  ),
                ),
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundImage:
                const AssetImage('assets/images/avatar_default.jpeg'),
                backgroundColor: Colors.grey[200],
                radius: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}