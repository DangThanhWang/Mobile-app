// ignore: file_names
import 'package:app/Definitons/size_config.dart';
import 'package:app/Pages/News/ViewAllStoriesPage.dart';
import 'package:app/Widgets/News/home_slider.dart';
import 'package:app/Widgets/News/new_list.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> categories = [
    "Tất cả",
    "Truyện ngắn",
    "Tiểu thuyết",
    "Truyện cổ tích",
    "Truyện kinh dị",
    "Truyện tình cảm",
    "Truyện phiêu lưu"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Thư viện truyện",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF8C725E),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
              showSearch(context: context, delegate: StorySearchDelegate());
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: Color(0xFF8C725E),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: categories.map((category) => Tab(text: category)).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories
            .map((category) => _buildCategoryContent(category))
            .toList(),
      ),
    );
  }

  Widget _buildCategoryContent(String category) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category == "Tất cả" ? "Truyện nổi bật" : category,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8C725E),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewAllStoriesPage(category: category),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios, size: 16),
                  label: Text("Xem tất cả"),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF8C725E),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (category == "Tất cả") HomeSlider(),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Text(
              "Gợi ý cho bạn",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8C725E),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: NewsList(category: category),
        ),
      ],
    );
  }
}

// Search delegate for story search
class StorySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results
    return Center(
      child: Text(
        'Kết quả tìm kiếm cho: "$query"',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Truyện cổ tích Việt Nam'),
          onTap: () {
            query = 'Truyện cổ tích Việt Nam';
            showResults(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Truyện ngắn hay'),
          onTap: () {
            query = 'Truyện ngắn hay';
            showResults(context);
          },
        ),
      ],
    );
  }
}
