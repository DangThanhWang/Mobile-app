import 'package:app/Definitons/size_config.dart';
import 'package:app/Pages/Auth/Login.dart';
import 'package:app/Pages/Auth/SignUp.dart';
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

class _UserProfilePage extends State<UserProfilePage> with SingleTickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPhotoUrl;

  @override
  void initState() {
    super.initState();
    userName = user?.displayName ?? 'Capybara';
    userPhotoUrl = user?.photoURL;
  }

  // Làm mới dữ liệu người dùng từ Firebase
  Future<void> _refreshUserData() async {
    await user?.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = refreshedUser?.displayName ?? 'Capybara';
      userPhotoUrl = refreshedUser?.photoURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                width: 130,
                height: 130,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image(
                      image: userPhotoUrl != null
                          ? NetworkImage(userPhotoUrl!)
                          : const AssetImage('assets/images/avatar_default.jpeg') as ImageProvider,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userName!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Hồ sơ",
                icon: LineAwesomeIcons.edit,
                onPress: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                  if (result != null && mounted) {
                    setState(() {
                      userName = result['name'] ?? userName;
                      userPhotoUrl = result['photoUrl'] ?? userPhotoUrl;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              ProfileMenuWidget(
                title: "Cài đặt",
                icon: LineAwesomeIcons.cog,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
              ),
              const SizedBox(height: 30),
              ProfileMenuWidget(
                title: "Trung tâm trợ giúp",
                icon: LineAwesomeIcons.headset,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SupportPage()),
                  );
                },
              ),
              const SizedBox(height: 30),
              ProfileMenuWidget(
                title: "Phản hồi",
                icon: LineAwesomeIcons.comment_dots,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackForm()),
                  );
                },
              ),
              const SizedBox(height: 30),
              ProfileMenuWidget(
                title: "Đăng xuất",
                icon: Icons.exit_to_app,
                textColor: Colors.red,
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
        ),
      ),
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
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color(0xffd1e4ef).withOpacity(0.1),
        ),
        child: Icon(
          icon,
          size: 30,
          color: Colors.black,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
      ),
      trailing: endIcon? Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(
          LineAwesomeIcons.angle_right,
          size: 18,
          color: Colors.black,
        ),
      ) : null,
    );
  }
}

