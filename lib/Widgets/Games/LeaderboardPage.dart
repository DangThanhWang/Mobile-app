import 'package:flutter/material.dart';
import 'package:app/Database/mongoDB.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  State<LeaderboardPage> createState() => _LeaderboardPage();
}

class _LeaderboardPage extends State<LeaderboardPage>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> leaderboard = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    fetchLeaderboard();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchLeaderboard() async {
    try {
      final collection = await MongoDBDatabase.getCollection('Progress');
      final users = await collection.find().toList();

      leaderboard = users.map<Map<String, dynamic>>((user) {
        String scoreString = user['score'] ?? "000.000.000.000.000";
        List<String> parts = scoreString.split('.');
        int totalScore = int.tryParse(parts.length > 4 ? parts[4] : "0") ?? 0;
        return {
          'userName': user['name'] ?? 'User',
          'photoUrl': user['photoUrl'] ?? '',
          'score': totalScore,
        };
      }).toList();

      leaderboard.sort((a, b) => b['score'].compareTo(a['score']));
      if (leaderboard.length > 20) {
        leaderboard = leaderboard.sublist(0, 20);
      }

      setState(() {
        isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return const Color(0xFF6C7CE7);
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.military_tech;
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.stars;
    }
  }

  Widget _buildTopThree() {
    if (leaderboard.length < 3) return const SizedBox.shrink();

    return Container(
      height: 280,
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildPodiumItem(0, 120),
                _buildPodiumItem(1, 80),
                _buildPodiumItem(2, 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(int index, double height) {
    final user = leaderboard[index];
    final rank = index == 0 ? 1 : (index == 1 ? 2 : 3);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getRankColor(rank),
                boxShadow: [
                  BoxShadow(
                    color: _getRankColor(rank).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundImage:
                    user['photoUrl'] != null && user['photoUrl'] != ''
                        ? NetworkImage(user['photoUrl'])
                        : const AssetImage('assets/images/avatar_default.jpeg')
                            as ImageProvider,
                child: (user['photoUrl'] == null || user['photoUrl'] == '')
                    ? null
                    : null,
              ),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  _getRankIcon(rank),
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          user['userName'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          "${user['score']}",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getRankColor(rank).withOpacity(0.8),
                _getRankColor(rank),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: _getRankColor(rank).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(int index) {
    final user = leaderboard[index];
    final rank = index + 1;

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _fadeAnimation.value)),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: rank <= 3
                    ? Border.all(
                        color: _getRankColor(rank).withOpacity(0.3),
                        width: 2,
                      )
                    : null,
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: rank <= 3
                            ? _getRankColor(rank)
                            : const Color(0xFF6C7CE7),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (rank <= 3
                                    ? _getRankColor(rank)
                                    : const Color(0xFF6C7CE7))
                                .withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: rank <= 3
                            ? Icon(
                                _getRankIcon(rank),
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                "$rank",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: rank <= 3
                              ? _getRankColor(rank).withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            user['photoUrl'] != null && user['photoUrl'] != ''
                                ? NetworkImage(user['photoUrl'])
                                : const AssetImage(
                                        'assets/images/avatar_default.jpeg')
                                    as ImageProvider,
                        child:
                            (user['photoUrl'] == null || user['photoUrl'] == '')
                                ? null
                                : null,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  user['userName'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                subtitle: rank <= 3
                    ? Text(
                        rank == 1
                            ? 'Vô địch'
                            : (rank == 2 ? 'Á quân' : 'Hạng ba'),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getRankColor(rank),
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : null,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF6B6B),
                        const Color(0xFFFF8E53),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "${user['score']}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FAFF),
              Color(0xFFEEF2FF),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  "🏆 Bảng xếp hạng",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    fontSize: 20,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: isLoading
                  ? const SizedBox(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF667eea)),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Đang tải bảng xếp hạng...",
                              style: TextStyle(
                                color: Color(0xFF718096),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : leaderboard.isEmpty
                      ? const SizedBox(
                          height: 300,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.emoji_events_outlined,
                                  size: 64,
                                  color: Color(0xFF718096),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Chưa có dữ liệu xếp hạng",
                                  style: TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            if (leaderboard.length >= 3) _buildTopThree(),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.format_list_numbered,
                                      color: Color(0xFF718096)),
                                  SizedBox(width: 8),
                                  Text(
                                    "Xếp hạng chi tiết",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            ),
            if (!isLoading && leaderboard.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildLeaderboardItem(index),
                  childCount: leaderboard.length,
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}
