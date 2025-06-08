import 'package:app/Database/mongoDB.dart';
import 'package:app/Definitons/global.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State, Center, Switch;

class InitialSetupPage extends StatefulWidget {
  const InitialSetupPage({super.key});

  @override
  State<InitialSetupPage> createState() => _InitialSetupPageState();
}

class _InitialSetupPageState extends State<InitialSetupPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // Dữ liệu người dùng chọn
  String? _selectedLevel;
  String? _selectedGoal;
  List<String> _selectedInterests = [];
  bool _notificationEnabled = false;

  // Dữ liệu cho các lựa chọn
  final List<Map<String, dynamic>> _englishLevels = [
    {
      'id': 'beginner',
      'title': 'Mới bắt đầu',
      'description': 'Tôi mới bắt đầu học tiếng Anh',
      'icon': LineAwesomeIcons.seedling,
    },
    {
      'id': 'basic',
      'title': 'Cơ bản',
      'description': 'Tôi biết một số từ vựng và ngữ pháp cơ bản',
      'icon': LineAwesomeIcons.book,
    },
    {
      'id': 'intermediate',
      'title': 'Trung bình',
      'description': 'Tôi có thể giao tiếp đơn giản',
      'icon': LineAwesomeIcons.comments,
    },
    {
      'id': 'advanced',
      'title': 'Nâng cao',
      'description': 'Tôi giao tiếp tốt và muốn hoàn thiện',
      'icon': LineAwesomeIcons.graduation_cap,
    },
  ];

  final List<Map<String, dynamic>> _learningGoals = [
    {
      'id': '15min',
      'title': '15 phút/ngày',
      'description': 'Học nhanh, hiệu quả',
      'icon': LineAwesomeIcons.clock,
    },
    {
      'id': '30min',
      'title': '30 phút/ngày',
      'description': 'Cân bằng và ổn định',
      'icon': LineAwesomeIcons.hourglass_half,
    },
    {
      'id': '1hour',
      'title': '1 giờ/ngày',
      'description': 'Học sâu và toàn diện',
      'icon': LineAwesomeIcons.hourglass,
    },
    {
      'id': 'flexible',
      'title': 'Linh hoạt',
      'description': 'Tùy theo thời gian rảnh',
      'icon': LineAwesomeIcons.calendar,
    },
  ];

  final List<Map<String, dynamic>> _interests = [
    {
      'id': 'daily_conversation',
      'title': 'Giao tiếp hàng ngày',
      'icon': LineAwesomeIcons.comments,
    },
    {
      'id': 'business',
      'title': 'Tiếng Anh kinh doanh',
      'icon': LineAwesomeIcons.briefcase,
    },
    {
      'id': 'travel',
      'title': 'Du lịch',
      'icon': LineAwesomeIcons.plane,
    },
    {
      'id': 'exam',
      'title': 'Thi cử (IELTS, TOEIC)',
      'icon': LineAwesomeIcons.certificate,
    },
    {
      'id': 'academic',
      'title': 'Học thuật',
      'icon': LineAwesomeIcons.university,
    },
    {
      'id': 'entertainment',
      'title': 'Giải trí (phim, nhạc)',
      'icon': LineAwesomeIcons.film,
    },
  ];

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveSetupAndContinue() async {
    if (_selectedLevel == null ||
        _selectedGoal == null ||
        _selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng hoàn thành tất cả các bước thiết lập'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final usersCollection = await MongoDBDatabase.getCollection('Users');

      // Cập nhật thông tin thiết lập ban đầu cho user
      await usersCollection.updateOne(
        where.eq('userId', globalUserId),
        modify.set('initialSetup', {
          'englishLevel': _selectedLevel,
          'learningGoal': _selectedGoal,
          'interests': _selectedInterests,
          'notificationEnabled': _notificationEnabled,
          'setupCompletedAt': DateTime.now().toUtc().toIso8601String(),
        }).set('updatedAt', DateTime.now().toUtc().toIso8601String()),
      );

      // Chuyển đến trang home
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lưu thiết lập: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Thiết lập ban đầu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= _currentPage
                          ? Color(0xFFD3B591)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildLevelSelectionPage(),
                _buildGoalSelectionPage(),
                _buildInterestSelectionPage(),
                _buildNotificationPage(),
              ],
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousPage,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFD3B591)),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Quay lại',
                        style: TextStyle(
                          color: Color(0xFFD3B591),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (_currentPage > 0) SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : (_currentPage == 3
                            ? _saveSetupAndContinue
                            : _nextPage),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD3B591),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _currentPage == 3 ? 'Hoàn thành' : 'Tiếp tục',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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

  Widget _buildLevelSelectionPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset('assets/images/capy_level.png', height: 120),
          ),
          SizedBox(height: 20),
          Text(
            'Trình độ tiếng Anh của bạn?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Chọn trình độ phù hợp để chúng tôi tạo lộ trình học tập tốt nhất cho bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 30),
          ..._englishLevels.map((level) => _buildLevelCard(level)),
        ],
      ),
    );
  }

  Widget _buildLevelCard(Map<String, dynamic> level) {
    bool isSelected = _selectedLevel == level['id'];
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLevel = level['id'];
          });
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Color(0xFFD3B591) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(15),
            color:
                isSelected ? Color(0xFFD3B591).withOpacity(0.1) : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFD3B591) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  level['icon'],
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 24,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Color(0xFFD3B591) : Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      level['description'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Color(0xFFD3B591),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalSelectionPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset('assets/images/capy_goal.png', height: 120),
          ),
          SizedBox(height: 20),
          Text(
            'Mục tiêu học tập của bạn?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Chọn thời gian học mỗi ngày để xây dựng thói quen học tập hiệu quả',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 30),
          ..._learningGoals.map((goal) => _buildGoalCard(goal)),
        ],
      ),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    bool isSelected = _selectedGoal == goal['id'];
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGoal = goal['id'];
          });
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Color(0xFFD3B591) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(15),
            color:
                isSelected ? Color(0xFFD3B591).withOpacity(0.1) : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFD3B591) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  goal['icon'],
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 24,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Color(0xFFD3B591) : Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      goal['description'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Color(0xFFD3B591),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestSelectionPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset('assets/images/capy_interest.png', height: 120),
          ),
          SizedBox(height: 20),
          Text(
            'Lĩnh vực quan tâm',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Chọn các lĩnh vực bạn muốn tập trung học (chọn ít nhất 1)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.2,
            ),
            itemCount: _interests.length,
            itemBuilder: (context, index) {
              return _buildInterestCard(_interests[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInterestCard(Map<String, dynamic> interest) {
    bool isSelected = _selectedInterests.contains(interest['id']);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedInterests.remove(interest['id']);
          } else {
            _selectedInterests.add(interest['id']);
          }
        });
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xFFD3B591) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? Color(0xFFD3B591).withOpacity(0.1) : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFD3B591) : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                interest['icon'],
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 28,
              ),
            ),
            SizedBox(height: 10),
            Text(
              interest['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Color(0xFFD3B591) : Colors.black,
              ),
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFFD3B591),
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child:
                Image.asset('assets/images/capy_notification.png', height: 120),
          ),
          SizedBox(height: 20),
          Text(
            'Thông báo nhắc nhở',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Cho phép thông báo để không bỏ lỡ thời gian học tập của bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFD3B591).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        LineAwesomeIcons.bell,
                        color: Color(0xFFD3B591),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nhận thông báo nhắc nhở',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Chúng tôi sẽ gửi thông báo nhắc nhở bạn học tập theo lịch trình đã đặt',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _notificationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationEnabled = value;
                        });
                      },
                      activeColor: Color(0xFFD3B591),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bạn có thể thay đổi cài đặt thông báo bất cứ lúc nào trong phần Cài đặt',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
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
}
