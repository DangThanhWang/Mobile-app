// ignore_for_file: library_private_types_in_public_api

import 'package:app/Definitons/global.dart';
import 'package:app/Definitons/size_config.dart';
import 'package:app/Pages/Auth/Login.dart';
import 'package:app/Widgets/Profile/Stats/EditProfilePage.dart';
import 'package:app/Widgets/Profile/Stats/FeedbackForm.dart';
import 'package:app/Widgets/Profile/Stats/SettingPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Widgets/Profile/Stats/SupportPage.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePage createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPhotoUrl;

  @override
  void initState() {
    super.initState();
    userName = globalUserName ?? 'Capybara';
    userPhotoUrl = user?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF2C2C2C) : const Color(0xFF4A90E2),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header với gradient background
            _buildHeader(context, isDark),

            // Profile content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildMenuSection(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar với hiệu ứng shadow
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 47,
                  backgroundImage: userPhotoUrl != null
                      ? NetworkImage(userPhotoUrl!)
                      : const AssetImage('assets/images/avatar_default.jpeg')
                          as ImageProvider,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // User name với style đẹp
            Text(
              userName!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                gmailUser ?? 'guest@example.com',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileMenuWidget(
            title: "Hồ sơ",
            icon: LineAwesomeIcons.user_edit,
            iconColor: const Color(0xFF4A90E2),
            onPress: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
              );
              if (result != null && mounted) {
                setState(() {
                  userName = result['name'] ?? userName;
                  userPhotoUrl = result['photoUrl'] ?? userPhotoUrl;
                });
              }
            },
          ),
          _buildDivider(),
          ProfileMenuWidget(
            title: "Cài đặt",
            icon: LineAwesomeIcons.cog,
            iconColor: const Color(0xFF50C878),
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
          ),
          _buildDivider(),
          ProfileMenuWidget(
            title: "Trung tâm trợ giúp",
            icon: LineAwesomeIcons.headset,
            iconColor: const Color(0xFFFF9500),
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportPage()),
              );
            },
          ),
          _buildDivider(),
          ProfileMenuWidget(
            title: "Phản hồi",
            icon: LineAwesomeIcons.comment_dots,
            iconColor: const Color(0xFF9B59B6),
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackForm()),
              );
            },
          ),
          _buildDivider(),
          ProfileMenuWidget(
            title: "Đăng xuất",
            icon: Icons.exit_to_app,
            iconColor: const Color(0xFFE74C3C),
            textColor: const Color(0xFFE74C3C),
            endIcon: false,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.grey.withOpacity(0.3),
      indent: 70,
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    this.iconColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Icon container với màu sắc đẹp
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.blue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:
                        textColor ?? (isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ),
              // Arrow icon
              if (endIcon)
                Icon(
                  LineAwesomeIcons.angle_right,
                  size: 20,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
