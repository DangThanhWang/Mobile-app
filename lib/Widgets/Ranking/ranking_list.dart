import 'package:app/Data/News/dummy.dart';
import 'package:app/Widgets/Ranking/ranking_list_item.dart';
import 'package:flutter/material.dart';

class RankingList extends StatelessWidget {
  final bool check;
  const RankingList({Key? key, required this.check}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFEFEFFC),
        ),
        child: Column(
          children: [
            SizedBox(height: 15),
            // SliverList
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: newsrItems.length,
              itemBuilder: (context, index) => RankingListItem(
                number: check ? index + 4 : index + 1,
                check: check,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
