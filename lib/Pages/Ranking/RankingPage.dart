import 'package:app/Components/Header/Header_Genral.dart';
import 'package:app/Definitons/size_config.dart';
import 'package:app/Widgets/Ranking/Leader_board.dart';
import 'package:app/Widgets/Ranking/announce_user.dart';
import 'package:app/Widgets/Ranking/ranking_list.dart';
import 'package:app/Widgets/Ranking/timer_ranking.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChampionPage createState() => _ChampionPage();
}

class _ChampionPage extends State<RankingPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool check = true;
  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF95785E),
        elevation: 0,
        toolbarHeight: 70.0,
        flexibleSpace: Info(
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<int>(
            icon: Icon(
              Icons.more_vert,
              size: 35,
              color: Colors.white,
            ),
            offset: Offset(0, 40),
            onSelected: (value) {
              setState(() {
                if (value == 1) {
                  check = false;
                } else if (value == 2) {
                  check = true;
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.view_list_outlined, size: 20),
                  title: Text("Lists", style: TextStyle(fontSize: 14)),
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.leaderboard, size: 20),
                  title: Text("Leadings", style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            TimerRanking(tasks: ["Weekly", "Monthly"]),
            if (check) AnnounceUser(),
            if (check) LeaderboardWidget(),
            RankingList(
              check: check,
            ),
          ],
        ),
      ),
    );
  }
}
