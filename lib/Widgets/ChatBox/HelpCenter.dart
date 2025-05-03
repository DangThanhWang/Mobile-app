import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các mục hướng dẫn sử dụng
    final List<Map<String, dynamic>> helpItems = [
      {
        'icon': Icons.chat,
        'title': 'Phòng chat mới',
        'description':
            'Tạo một cuộc trò chuyện mới khi bạn muốn bắt đầu với một chủ đề khác. Mỗi phòng chat sẽ lưu trữ lịch sử riêng biệt.',
        'steps': [
          'Nhấn vào biểu tượng menu ở góc trên bên phải',
          'Chọn "Phòng chat mới"',
          'Chọn tên phòng Chat mới và nhấn "Tạo"',
          'Bắt đầu trò chuyện với ChatBox'
        ]
      },
      {
        'icon': Icons.note_alt_outlined,
        'title': 'Tất cả cuộc trò chuyện',
        'description':
            'Xem danh sách tất cả các cuộc trò chuyện bạn đã tạo. Bạn có thể quay lại cuộc trò chuyện cũ hoặc quản lý các phòng chat của mình.',
        'steps': [
          'Nhấn vào biểu tượng menu ở góc trên bên phải',
          'Chọn "Tất cả cuộc trò chuyện"',
          'Chạm vào bất kỳ cuộc trò chuyện nào để mở lại và khám phá nội dung bên trong'
        ]
      },
      {
        'icon': Icons.delete_outline,
        'title': 'Xóa lịch sử trò chuyện',
        'description':
            'Xóa tất cả tin nhắn trong phòng chat hiện tại khi bạn muốn bắt đầu lại hoặc không còn cần nội dung cũ nữa.',
        'steps': [
          'Nhấn vào biểu tượng menu ở góc trên bên phải',
          'Chọn "Xóa lịch sử trò chuyện"',
          'Xác nhận khi được hỏi để hoàn tất việc xóa'
        ]
      },
      {
        'icon': Icons.help_outline,
        'title': 'Trợ giúp',
        'description':
            'Mở trang hướng dẫn này để tìm hiểu về cách sử dụng các tính năng của ứng dụng.',
        'steps': [
          'Nhấn vào biểu tượng menu ở góc trên bên phải',
          'Chọn "Trợ giúp"'
        ]
      },
    ];

    // Danh sách các mẹo sử dụng
    final List<String> tips = [
      'Bạn có thể nhấn giữ một tin nhắn để xem thêm tùy chọn.',
      'Sử dụng tính năng tìm kiếm để nhanh chóng tìm lại các cuộc trò chuyện cũ.',
      'Thử sử dụng các phím tắt phổ biến để tăng hiệu quả sử dụng.',
      'Nhấn đúp vào một tin nhắn để xem chi tiết hơn.',
      'Kéo xuống để tải thêm tin nhắn cũ trong lịch sử trò chuyện.'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ giúp',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7C72E5),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[50],
        child: ListView(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF7C72E5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.help_outline,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Hướng Dẫn Sử Dụng',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Chào mừng bạn! Hãy khám phá những tính năng hữu ích của ứng dụng chat của chúng tôi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Các tính năng chính',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            // Help Items
            ...helpItems.map((item) => _buildHelpItem(context, item)),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Mẹo hữu ích',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            // Tips Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FF),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...tips.map((tip) => _buildTipItem(tip)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Contact Support Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  // Hiển thị thông tin liên hệ hỗ trợ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Liên hệ hỗ trợ: support@example.com'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C72E5),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Liên hệ hỗ trợ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Footer
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Phiên bản 1.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị mục trợ giúp
  Widget _buildHelpItem(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            item['icon'] as IconData,
            color: const Color(0xFF7C72E5),
          ),
        ),
        title: Text(
          item['title'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          item['description'] as String,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cách sử dụng:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF7C72E5),
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(
                  (item['steps'] as List).length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C72E5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item['steps'][index],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị mẹo
  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: Color(0xFF7C72E5),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
