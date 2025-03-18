import 'package:app/Widgets/Ranking/Leader_board_item.dart';
import 'package:flutter/material.dart';

class LeaderboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LeaderboardItem(
                number: '2',
                point: '100 QP',
                name: 'Tai',
                widthUser: 104,
                heightUser: 100,
              ),
              LeaderboardItem(
                number: '1',
                point: '150 QP',
                name: 'Thanh',
                widthUser: 110,
                heightUser: 120,
              ),
              LeaderboardItem(
                number: '3',
                point: '80 QP',
                name: 'Nhat',
                widthUser: 104,
                heightUser: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
