import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:app/Pages/Auth/Login.dart';
import 'package:app/Widgets/Profile/Stats/EditProfilePage.dart';
import 'package:app/Widgets/Profile/Stats/FeedbackForm.dart';
import 'package:app/Widgets/Profile/Stats/SettingPage.dart';
import 'package:app/Widgets/Profile/Stats/SupportPage.dart';
import 'package:app/Widgets/Profile/Components/ProfileMenuWidget.dart';

class SettingsTab extends StatefulWidget {
  final Function(String?, String?) onProfileUpdated;

  const SettingsTab({
    super.key,
    required this.onProfileUpdated,
  });

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create staggered animations for menu items
    _slideAnimations = List.generate(10, (index) {
      return Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.8 + (index * 0.02),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          const Text(
            'Cài đặt tài khoản',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Quản lý thông tin cá nhân và ứng dụng',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 24),

          // Account section
          _buildSection(
            title: 'Tài khoản',
            icon: Icons.person_outline,
            children: [
              SlideTransition(
                position: _slideAnimations[0],
                child: ProfileMenuWidget(
                  title: "Cập nhật thông tin",
                  icon: LineAwesomeIcons.user_edit,
                  iconColor: const Color(0xFF3B82F6),
                  onPress: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage()),
                    );
                    if (result != null && mounted) {
                      widget.onProfileUpdated(
                        result['name'],
                        result['photoUrl'],
                      );
                    }
                  },
                ),
              ),
              SlideTransition(
                position: _slideAnimations[1],
                child: ProfileMenuWidget(
                  title: "Đổi mật khẩu",
                  icon: LineAwesomeIcons.key,
                  iconColor: const Color(0xFF10B981),
                  onPress: () {
                    _showChangePasswordDialog();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Support section
          _buildSection(
            title: 'Hỗ trợ',
            icon: Icons.support_outlined,
            children: [
              SlideTransition(
                position: _slideAnimations[2],
                child: ProfileMenuWidget(
                  title: "Hỗ trợ học viên",
                  icon: LineAwesomeIcons.headset,
                  iconColor: const Color(0xFFF59E0B),
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SupportPage()),
                    );
                  },
                ),
              ),
              SlideTransition(
                position: _slideAnimations[3],
                child: ProfileMenuWidget(
                  title: "Góp ý",
                  icon: LineAwesomeIcons.comment_dots,
                  iconColor: const Color(0xFF8B5CF6),
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackForm()),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // App settings section
          _buildSection(
            title: 'Ứng dụng',
            icon: Icons.settings_outlined,
            children: [
              SlideTransition(
                position: _slideAnimations[4],
                child: ProfileMenuWidget(
                  title: "Thông báo",
                  icon: LineAwesomeIcons.bell,
                  iconColor: const Color(0xFF6366F1),
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingPage()),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Legal section
          _buildSection(
            title: 'Pháp lý',
            icon: Icons.gavel_outlined,
            children: [
              SlideTransition(
                position: _slideAnimations[5],
                child: ProfileMenuWidget(
                  title: "Chính sách thanh toán",
                  icon: LineAwesomeIcons.credit_card,
                  iconColor: const Color(0xFF059669),
                  onPress: () => _showComingSoonDialog("Chính sách thanh toán"),
                ),
              ),
              SlideTransition(
                position: _slideAnimations[6],
                child: ProfileMenuWidget(
                  title: "Chính sách bảo mật",
                  icon: LineAwesomeIcons.child,
                  iconColor: const Color(0xFF0EA5E9),
                  onPress: () => _showComingSoonDialog("Chính sách bảo mật"),
                ),
              ),
              SlideTransition(
                position: _slideAnimations[7],
                child: ProfileMenuWidget(
                  title: "Terms of Use (EULA)",
                  icon: LineAwesomeIcons.file_contract,
                  iconColor: const Color(0xFF7C3AED),
                  onPress: () => _showComingSoonDialog("Terms of Use"),
                ),
              ),
              SlideTransition(
                position: _slideAnimations[8],
                child: ProfileMenuWidget(
                  title: "Thông tin công ty",
                  icon: LineAwesomeIcons.building,
                  iconColor: const Color(0xFF64748B),
                  onPress: () => _showComingSoonDialog("Thông tin công ty"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Danger zone
          SlideTransition(
            position: _slideAnimations[9],
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_outlined,
                        color: Color(0xFFDC2626),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Vùng nguy hiểm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ProfileMenuWidget(
                    title: "Xóa tài khoản",
                    icon: LineAwesomeIcons.trash,
                    iconColor: const Color(0xFFDC2626),
                    textColor: const Color(0xFFDC2626),
                    endIcon: false,
                    onPress: _showDeleteAccountDialog,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // App version and logout
          SlideTransition(
            position: _slideAnimations[9],
            child: Column(
              children: [
                Text(
                  'Phiên bản ứng dụng 2.3.7',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showLogoutDialog();
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFFDC2626).withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children.map((child) {
              final index = children.indexOf(child);
              return Column(
                children: [
                  child,
                  if (index < children.length - 1)
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.grey.withOpacity(0.2),
                      indent: 72,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_outlined,
                color: Color(0xFFDC2626),
              ),
              const SizedBox(width: 8),
              const Text('Xóa tài khoản'),
            ],
          ),
          content: const Text(
            'Bạn có chắc chắn muốn xóa tài khoản? Tất cả dữ liệu học tập sẽ bị mất vĩnh viễn và không thể khôi phục.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng xóa tài khoản sẽ sớm được cập nhật'),
                    backgroundColor: Color(0xFFDC2626),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              child: const Text(
                'Xóa',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Đổi mật khẩu'),
          content: const Text(
            'Chức năng đổi mật khẩu sẽ sớm được cập nhật. Bạn có thể sử dụng chức năng "Quên mật khẩu" tại màn hình đăng nhập.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(feature),
          content: Text('$feature sẽ sớm được cập nhật trong phiên bản tiếp theo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}