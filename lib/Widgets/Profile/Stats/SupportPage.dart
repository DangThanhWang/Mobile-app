import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class SupportPage extends StatelessWidget {
  final _formSupport = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text('Trung tâm trợ giúp'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildContainer(
                context,
                title: 'Sử dụng Triopybara',
                items: [
                  {
                    'title': 'Tại sao khóa học của tôi thay đổi?',
                    'content': 'Khóa học có thể được cập nhật để cải thiện nội dung học tập và thêm tính năng mới.',
                  },
                  {
                    'title': 'Bảng xếp hạng là gì?',
                    'content':
                    'Bảng xếp hạng là nơi bạn có thể vui vẻ thi đua thành tích hàng tuần cùng những người học khác. Hãy ghé mục Bảng xếp hạng trên ứng dụng để tham gia thi đua nhé!',
                  },
                ],
              ),
              const SizedBox(height: 20),
              _buildContainer(
                context,
                title: 'Quản lý tài khoản',
                items: [
                  {
                    'title': 'Làm cách nào để đổi tên người dùng hoặc địa chỉ email?',
                    'content':
                    'Nếu bạn muốn thay đổi tên người dùng hoặc địa chỉ email của tài khoản Tripybara, hãy tới phần Hồ sơ và sửa tên người dùng hoặc địa chỉ email. Nhớ ấn "Lưu thay đổi" sau khi chỉnh sửa nhé.',
                  },
                  {
                    'title': 'Tôi gặp vấn đề khi truy cập tài khoản.',
                    'content':
                    'Nếu bạn quên mật khẩu và cần đặt mật khẩu mới, hãy nhấn vào "Quên mật khẩu" ở màn hình đăng nhập ứng dụng. Chúng tôi sẽ gửi một đường dẫn tới địa chỉ email đó, bạn có thể sử dụng đường dẫn này để tạo một mật khẩu mới.',
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, {required String title, required List<Map<String, String>> items}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ...items.map((item) => buildListItem(item['title']!, item['content']!)).toList(),
        ],
      ),
    );
  }

  Widget buildListItem(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xff24498e),
          fontSize: 16,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
      iconColor: Colors.black,
      collapsedIconColor: Colors.black,
    );
  }
}
