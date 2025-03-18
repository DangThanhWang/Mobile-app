import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
// class Info extends StatelessWidget {
//   final bool check;
//   final bool check_name;
//   const Info({super.key, required this.check, required this.check_name});

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  _Info createState() => _Info();
}
class _Info extends State<Info>  with SingleTickerProviderStateMixin {
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
    return Container(
      decoration: BoxDecoration(
        color: Color(0xDA805029),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/home/morning.png",
                        width: 20,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "GOOD MORNING",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFD6DD),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    userName!,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Spacer(),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: userPhotoUrl != null
                        ? NetworkImage(userPhotoUrl!)
                        : const AssetImage('assets/images/avatar_default.jpeg') as ImageProvider,
                  ),
                ),
              SizedBox(width: 15,)
            ],
          ),
        ),
      ),
    );
  }
}
