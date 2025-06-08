import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _supportSections = [
    {
      'title': 'Sử dụng Triopybara',
      'icon': Icons.school_outlined,
      'color': const Color(0xFF4A90E2),
      'items': [
        {
          'title': 'Tại sao khóa học của tôi thay đổi?',
          'content': 'Khóa học có thể được cập nhật để cải thiện nội dung học tập và thêm tính năng mới. Những thay đổi này được thực hiện dựa trên phản hồi của người học và nghiên cứu giáo dục mới nhất để mang lại trải nghiệm học tập tốt nhất.',
          'icon': Icons.auto_stories_outlined,
        },
        {
          'title': 'Bảng xếp hạng là gì?',
          'content': 'Bảng xếp hạng là nơi bạn có thể vui vẻ thi đua thành tích hàng tuần cùng những người học khác. Hãy ghé mục Bảng xếp hạng trên ứng dụng để tham gia thi đua nhé! Điểm số được tính dựa trên số bài học hoàn thành và độ chính xác.',
          'icon': Icons.leaderboard_outlined,
        },
        {
          'title': 'Làm thế nào để nâng cao kỹ năng phát âm?',
          'content': 'Sử dụng tính năng luyện phát âm hàng ngày, lắng nghe và lặp lại theo AI. Ghi âm giọng nói của bạn và so sánh với phát âm chuẩn để cải thiện.',
          'icon': Icons.record_voice_over_outlined,
        },
      ],
    },
    {
      'title': 'Quản lý tài khoản',
      'icon': Icons.account_circle_outlined,
      'color': const Color(0xFF50C878),
      'items': [
        {
          'title': 'Làm cách nào để đổi tên người dùng hoặc địa chỉ email?',
          'content': 'Nếu bạn muốn thay đổi tên người dùng hoặc địa chỉ email của tài khoản Tripybara, hãy tới phần Hồ sơ và sửa tên người dùng hoặc địa chỉ email. Nhớ ấn "Lưu thay đổi" sau khi chỉnh sửa nhé. Lưu ý: Email chỉ có thể thay đổi trong một số trường hợp đặc biệt.',
          'icon': Icons.edit_outlined,
        },
        {
          'title': 'Tôi gặp vấn đề khi truy cập tài khoản.',
          'content': 'Nếu bạn quên mật khẩu và cần đặt mật khẩu mới, hãy nhấn vào "Quên mật khẩu" ở màn hình đăng nhập ứng dụng. Chúng tôi sẽ gửi một đường dẫn tới địa chỉ email đó, bạn có thể sử dụng đường dẫn này để tạo một mật khẩu mới.',
          'icon': Icons.lock_reset_outlined,
        },
        {
          'title': 'Làm thế nào để xóa tài khoản?',
          'content': 'Để xóa tài khoản, hãy liên hệ với chúng tôi qua mục Phản hồi hoặc email hỗ trợ. Chúng tôi sẽ hướng dẫn bạn qua các bước cần thiết và đảm bảo dữ liệu được xóa an toàn.',
          'icon': Icons.delete_outline,
        },
      ],
    },
    {
      'title': 'Tính năng & Công nghệ',
      'icon': Icons.settings_applications_outlined,
      'color': const Color(0xFF9B59B6),
      'items': [
        {
          'title': 'AI Chatbot hoạt động như thế nào?',
          'content': 'AI Chatbot của chúng tôi được đào tạo để hỗ trợ học tiếng Anh, có thể trả lời câu hỏi, giải thích ngữ pháp và giúp bạn luyện tập hội thoại. AI sử dụng công nghệ xử lý ngôn ngữ tự nhiên hiện đại.',
          'icon': Icons.smart_toy_outlined,
        },
        {
          'title': 'Tại sao có lúc ứng dụng chạy chậm?',
          'content': 'Hiệu suất ứng dụng có thể bị ảnh hưởng bởi kết nối internet, bộ nhớ thiết bị hoặc phiên bản ứng dụng. Hãy thử khởi động lại ứng dụng hoặc kiểm tra kết nối mạng.',
          'icon': Icons.speed_outlined,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _contactSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_outlined,
                    color: Color(0xFF4A90E2),
                    size: 32,
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Liên hệ hỗ trợ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Chúng tôi luôn sẵn sàng hỗ trợ bạn',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 24),

                _buildContactOption(
                  icon: Icons.email_outlined,
                  title: 'Email hỗ trợ',
                  subtitle: 'support@triopybara.com',
                  color: const Color(0xFF4A90E2),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đang mở ứng dụng email...'),
                        backgroundColor: Color(0xFF4A90E2),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildContactOption(
                  icon: Icons.chat_outlined,
                  title: 'Chat trực tuyến',
                  subtitle: 'Thời gian: 8:00 - 22:00',
                  color: const Color(0xFF50C878),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tính năng sẽ có trong phiên bản tới'),
                        backgroundColor: Color(0xFF50C878),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildContactOption(
                  icon: Icons.phone_outlined,
                  title: 'Hotline',
                  subtitle: '1900-xxxx (8:00 - 18:00)',
                  color: const Color(0xFFFF9500),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đang gọi...'),
                        backgroundColor: Color(0xFFFF9500),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LineAwesomeIcons.angle_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            color: Colors.black87,
            size: 28,
          ),
        ),
        title: const Text(
          'Trung tâm trợ giúp',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _contactSupport,
            icon: const Icon(
              Icons.support_agent_outlined,
              color: Colors.black87,
              size: 24,
            ),
            tooltip: 'Liên hệ hỗ trợ',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF805029),
                        Color(0xFF5D3A1A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Trung tâm trợ giúp',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tìm câu trả lời cho các câu hỏi thường gặp hoặc liên hệ với chúng tôi để được hỗ trợ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Quick Actions
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hành động nhanh',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickAction(
                              icon: Icons.chat_outlined,
                              title: 'Liên hệ',
                              color: const Color(0xFF50C878),
                              onTap: _contactSupport,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickAction(
                              icon: Icons.feedback_outlined,
                              title: 'Phản hồi',
                              color: const Color(0xFF9B59B6),
                              onTap: () {
                                Navigator.pop(context);
                                // Navigate to feedback form
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // FAQ Sections
                ...List.generate(_supportSections.length, (sectionIndex) {
                  final section = _supportSections[sectionIndex];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Section Header
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: section['color'].withOpacity(0.1),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: section['color'],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  section['icon'],
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  section['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: section['color'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // FAQ Items
                        ...List.generate(section['items'].length, (itemIndex) {
                          final item = section['items'][itemIndex];
                          return Column(
                            children: [
                              if (itemIndex > 0)
                                Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: Colors.grey.withOpacity(0.3),
                                  indent: 70,
                                  endIndent: 24,
                                ),
                              ExpansionTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: section['color'].withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    item['icon'],
                                    color: section['color'],
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                iconColor: section['color'],
                                collapsedIconColor: Colors.grey[600],
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                childrenPadding: const EdgeInsets.only(
                                  left: 70,
                                  right: 24,
                                  bottom: 16,
                                ),
                                children: [
                                  Text(
                                    item['content'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.6,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),

                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                }),

                // Contact Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF50C878).withOpacity(0.1),
                        const Color(0xFF4A90E2).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF4A90E2).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90E2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.contact_support_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Vẫn cần hỗ trợ?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Không tìm thấy câu trả lời bạn cần? Hãy liên hệ với đội ngũ hỗ trợ của chúng tôi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _contactSupport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.support_agent_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Liên hệ hỗ trợ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}