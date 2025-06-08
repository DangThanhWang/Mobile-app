import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoPlayEnabled = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _settingItems = [];

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

    _loadSettings();
    _animationController.forward();
    _initializeSettingItems();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeSettingItems() {
    _settingItems.addAll([
      {
        'title': 'Hiệu ứng âm thanh',
        'subtitle': 'Bật/tắt âm thanh khi tương tác',
        'icon': Icons.volume_up_outlined,
        'color': const Color(0xFF4A90E2),
        'value': _soundEnabled,
        'onChanged': (value) {
          setState(() {
            _soundEnabled = value;
          });
          _saveSettings();
        },
      },
      {
        'title': 'Cài đặt rung',
        'subtitle': 'Rung khi có thông báo hoặc tương tác',
        'icon': Icons.vibration_outlined,
        'color': const Color(0xFF50C878),
        'value': _vibrationEnabled,
        'onChanged': (value) {
          setState(() {
            _vibrationEnabled = value;
          });
          _saveSettings();
        },
      },
      {
        'title': 'Thông báo',
        'subtitle': 'Nhận thông báo từ ứng dụng',
        'icon': Icons.notifications_outlined,
        'color': const Color(0xFFFF9500),
        'value': _notificationsEnabled,
        'onChanged': (value) {
          setState(() {
            _notificationsEnabled = value;
          });
          _saveSettings();
        },
      },
      {
        'title': 'Chế độ tối',
        'subtitle': 'Sử dụng giao diện tối',
        'icon': Icons.dark_mode_outlined,
        'color': const Color(0xFF9B59B6),
        'value': _darkModeEnabled,
        'onChanged': (value) {
          setState(() {
            _darkModeEnabled = value;
          });
          _saveSettings();
        },
      },
      {
        'title': 'Tự động phát',
        'subtitle': 'Tự động phát âm thanh khi học',
        'icon': Icons.play_circle_outline,
        'color': const Color(0xFFE74C3C),
        'value': _autoPlayEnabled,
        'onChanged': (value) {
          setState(() {
            _autoPlayEnabled = value;
          });
          _saveSettings();
        },
      },
    ]);
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _darkModeEnabled = prefs.getBool('darkModeEnabled') ?? false;
      _autoPlayEnabled = prefs.getBool('autoPlayEnabled') ?? true;
    });
    _initializeSettingItems();
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('soundEnabled', _soundEnabled);
    prefs.setBool('vibrationEnabled', _vibrationEnabled);
    prefs.setBool('notificationsEnabled', _notificationsEnabled);
    prefs.setBool('darkModeEnabled', _darkModeEnabled);
    prefs.setBool('autoPlayEnabled', _autoPlayEnabled);

    _showSnackBar('Cài đặt đã được lưu');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF50C878),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.restore_outlined,
                color: Color(0xFFE74C3C),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Khôi phục mặc định',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Bạn có chắc chắn muốn khôi phục tất cả cài đặt về mặc định không?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _soundEnabled = true;
                  _vibrationEnabled = true;
                  _notificationsEnabled = true;
                  _darkModeEnabled = false;
                  _autoPlayEnabled = true;
                });
                _saveSettings();
                _showSnackBar('Đã khôi phục cài đặt mặc định');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Khôi phục',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
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
          'Cài đặt',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _resetToDefaults,
            icon: const Icon(
              Icons.restore_outlined,
              color: Colors.black87,
              size: 24,
            ),
            tooltip: 'Khôi phục mặc định',
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
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Cài đặt ứng dụng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tùy chỉnh ứng dụng theo sở thích của bạn',
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

                // Settings List
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
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
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A90E2).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.tune_outlined,
                                color: Color(0xFF4A90E2),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Tùy chọn cài đặt',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Settings Items
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _settingItems.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.grey.withOpacity(0.3),
                          indent: 70,
                          endIndent: 24,
                        ),
                        itemBuilder: (context, index) {
                          final item = _settingItems[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: AdvancedSwitchListTile(
                              title: item['title'],
                              subtitle: item['subtitle'],
                              icon: item['icon'],
                              iconColor: item['color'],
                              value: item['value'],
                              onChanged: item['onChanged'],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Additional Settings
                Container(
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
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF50C878).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Color(0xFF50C878),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Thông tin thêm',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildInfoItem(
                        icon: Icons.storage_outlined,
                        title: 'Dung lượng cache',
                        subtitle: '24.5 MB',
                        color: const Color(0xFF9B59B6),
                        onTap: () {
                          _showSnackBar('Tính năng sẽ có trong phiên bản tới');
                        },
                      ),

                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.withOpacity(0.3),
                        indent: 70,
                        endIndent: 24,
                      ),

                      _buildInfoItem(
                        icon: Icons.language_outlined,
                        title: 'Ngôn ngữ',
                        subtitle: 'Tiếng Việt',
                        color: const Color(0xFFFF9500),
                        onTap: () {
                          _showSnackBar('Tính năng sẽ có trong phiên bản tới');
                        },
                      ),

                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.withOpacity(0.3),
                        indent: 70,
                        endIndent: 24,
                      ),

                      _buildInfoItem(
                        icon: Icons.info_outline,
                        title: 'Phiên bản',
                        subtitle: 'v1.0.0',
                        color: const Color(0xFF4A90E2),
                        onTap: () {
                          _showSnackBar('Bạn đang sử dụng phiên bản mới nhất');
                        },
                      ),

                      const SizedBox(height: 24),
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

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
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
                        color: Colors.black87,
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
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdvancedSwitchListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AdvancedSwitchListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: iconColor,
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              activeColor: Colors.white,
              activeTrackColor: iconColor,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[300],
              splashRadius: 0,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}