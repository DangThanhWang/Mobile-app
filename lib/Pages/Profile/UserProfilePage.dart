// ignore_for_file: library_private_types_in_public_api

import 'package:provider/provider.dart';
import 'package:app/Definitons/global.dart';
import 'package:app/Definitons/size_config.dart';
import 'package:app/Widgets/Profile/Components/ProfileHeader.dart';
import 'package:app/Widgets/Profile/Components/StatsTab.dart';
import 'package:app/Widgets/Profile/Components/SettingsTab.dart';
import 'package:app/Widgets/Profile/Components/CoachTab.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/Providers/UserProvider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePage createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage>
    with TickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPhotoUrl;
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    userName = globalUserName ?? 'Capybara';
    userPhotoUrl = user?.photoURL;
    _tabController = TabController(length: 3, vsync: this);

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

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onProfileUpdated(String? newName, String? newPhotoUrl) {
    setState(() {
      userName = newName ?? userName;
      userPhotoUrl = newPhotoUrl ?? userPhotoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<UserProvider>().userName;
    AppSizes().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Profile Header
            ProfileHeader(
              userName: userName!,
              userEmail: gmailUser ?? 'guest@example.com',
              userPhotoUrl: userPhotoUrl,
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF64748B),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF805029), Color(0xFF805029)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                tabAlignment: TabAlignment.fill,
                tabs: const [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      child: Text('Thống kê'),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      child: Text('Cài đặt'),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      child: Text('Coach'),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const StatsTab(),
                  SettingsTab(onProfileUpdated: _onProfileUpdated),
                  const CoachTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}