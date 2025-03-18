import 'package:app/Data/News/dummy.dart';
import 'package:app/Widgets/News/new_list_item.dart';
import 'package:flutter/material.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> filteredNewsItems = newsrItems.sublist(5);
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số lượng mục trong một hàng (2 mục/hàng)
          mainAxisSpacing: 16, // Khoảng cách giữa các hàng
          crossAxisSpacing: 16, // Khoảng cách giữa các cột
          // childAspectRatio:
          //     3 / 4, // Tỷ lệ giữa chiều rộng và chiều cao của mỗi item
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => NewsListItem(
            imageAssetPath: newsrItems[i]['imageAssetPath']!,
            category: newsrItems[i]['category']!,
            title: newsrItems[i]['title']!,
            content: newsrItems[i]['content']!,
            // author: newsrItems[i]['author']!,
            // authorImageAssetPath: newsrItems[i]['authorImageAssetPath']!,
            // date: DateTime.parse(newsrItems[i]['date']!),
          ),
          childCount: filteredNewsItems.length,
        ),
      ),
    );
  }
}
