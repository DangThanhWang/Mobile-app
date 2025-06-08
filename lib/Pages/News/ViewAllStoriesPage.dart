import 'package:app/Definitons/dummy.dart';
import 'package:app/Pages/News/singe_news_item_page.dart';
import 'package:flutter/material.dart';

class ViewAllStoriesPage extends StatefulWidget {
  final String category;

  const ViewAllStoriesPage({
    super.key,
    this.category = "Tất cả",
  });

  @override
  State<ViewAllStoriesPage> createState() => _ViewAllStoriesPageState();
}

class _ViewAllStoriesPageState extends State<ViewAllStoriesPage> {
  String _selectedSort = 'Mới nhất';
  String _selectedFilter = 'Tất cả';
  bool _isGridView = true;

  final List<String> _sortOptions = [
    'Mới nhất',
    'Cũ nhất',
    'Tên A-Z',
    'Tên Z-A',
    'Phổ biến nhất'
  ];

  final List<String> _filterOptions = [
    'Tất cả',
    'Đã đọc',
    'Chưa đọc',
    'Yêu thích'
  ];

  // Helper function to convert string to bool
  bool _stringToBool(String? value) {
    if (value == null) return false;
    return value.toLowerCase() == 'true';
  }

  // Helper function to convert bool to string
  String _boolToString(bool value) {
    return value.toString();
  }

  List<Map<String, dynamic>> get _filteredStories {
    List<Map<String, dynamic>> stories =
        newsrItems.map((story) => Map<String, dynamic>.from(story)).toList();

    // Filter by category
    if (widget.category != "Tất cả") {
      stories = stories
          .where((story) =>
              story['category']?.toString().toLowerCase() ==
              widget.category.toLowerCase())
          .toList();
    }

    switch (_selectedFilter) {
      case 'Đã đọc':
        stories = stories
            .where((story) => _stringToBool(story['isRead']?.toString()))
            .toList();
      case 'Chưa đọc':
        stories = stories
            .where((story) => !_stringToBool(story['isRead']?.toString()))
            .toList();
      case 'Yêu thích':
        stories = stories
            .where((story) => _stringToBool(story['isFavorite']?.toString()))
            .toList();
      // 'Tất cả' không cần filter
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Tên A-Z':
        stories.sort((a, b) => (a['title']?.toString() ?? '')
            .compareTo(b['title']?.toString() ?? ''));
      case 'Tên Z-A':
        stories.sort((a, b) => (b['title']?.toString() ?? '')
            .compareTo(a['title']?.toString() ?? ''));
      case 'Cũ nhất':
        stories = stories.reversed.toList();
      case 'Phổ biến nhất':
        stories.sort((a, b) =>
            (int.tryParse(b['views']?.toString() ?? '0') ?? 0)
                .compareTo(int.tryParse(a['views']?.toString() ?? '0') ?? 0));
      // 'Mới nhất' giữ nguyên thứ tự
    }

    return stories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.category == "Tất cả" ? "Tất cả truyện" : widget.category,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF8C725E),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              // Handle menu selection
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 8),
                    Text('Tải xuống'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 8),
                    Text('Chia sẻ'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Sort Bar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Sort dropdown
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sort, size: 20, color: Color(0xFF8C725E)),
                        SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSort,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSort = value!;
                                });
                              },
                              items: _sortOptions
                                  .map(
                                    (option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(option,
                                          style: TextStyle(fontSize: 14)),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 12),

                // Filter dropdown
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list,
                            size: 20, color: Color(0xFF8C725E)),
                        SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedFilter,
                              onChanged: (value) {
                                setState(() {
                                  _selectedFilter = value!;
                                });
                              },
                              items: _filterOptions
                                  .map(
                                    (option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(option,
                                          style: TextStyle(fontSize: 14)),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stories count
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Text(
              'Tìm thấy ${_filteredStories.length} truyện',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Stories grid/list
          Expanded(
            child: _filteredStories.isEmpty
                ? _buildEmptyState()
                : CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        sliver: _isGridView
                            ? SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio:
                                      0.8, // Tăng tỷ lệ để tránh overflow
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) =>
                                      _buildStoryCard(_filteredStories[index]),
                                  childCount: _filteredStories.length,
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _buildStoryListItem(
                                      _filteredStories[index]),
                                  childCount: _filteredStories.length,
                                ),
                              ),
                      ),
                      SliverPadding(padding: EdgeInsets.only(bottom: 20)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Không tìm thấy truyện nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hãy thử thay đổi bộ lọc hoặc tìm kiếm khác',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(Map<String, dynamic> story) {
    bool isRead = _stringToBool(story['isRead']?.toString());
    bool isFavorite = _stringToBool(story['isFavorite']?.toString());
    bool isBookmarked = _stringToBool(story['isBookmarked']?.toString());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            story['isRead'] = _boolToString(true);
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleNewsItemPage(
                title: story['title']?.toString() ?? '',
                content: story['content']?.toString() ?? '',
                category: story['category']?.toString() ?? '',
                imageAssetPath: story['imageAssetPath']?.toString() ?? '',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Story image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      image: DecorationImage(
                        image: AssetImage(
                            story['imageAssetPath']?.toString() ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  if (isRead)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 12),
                      ),
                    ),
                ],
              ),
            ),
            // Story info - Fixed overflow issue
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8), // Giảm padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Quan trọng: giới hạn kích thước
                  children: [
                    // Category chip
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2), // Giảm padding
                      decoration: BoxDecoration(
                        color: Color(0xFF8C725E).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        story['category']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 9, // Giảm font size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8C725E),
                        ),
                      ),
                    ),
                    SizedBox(height: 4), // Giảm spacing
                    // Story title
                    Flexible(
                      // Thay Expanded bằng Flexible
                      child: Text(
                        story['title']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 11, // Giảm font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4), // Giảm spacing
                    // Reading status
                    Row(
                      children: [
                        Icon(Icons.visibility,
                            size: 10,
                            color: Colors.grey[600]), // Giảm icon size
                        SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '${((story['title']?.toString().length ?? 0) * 0.1).round()}k lượt đọc',
                            style: TextStyle(
                              fontSize: 9, // Giảm font size
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Action buttons - Fixed layout
            SizedBox(
              height: 40, // Cố định chiều cao
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Favorite button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          story['isFavorite'] = _boolToString(!isFavorite);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(!isFavorite
                                ? 'Đã thêm vào yêu thích!'
                                : 'Đã bỏ khỏi yêu thích!'),
                          ),
                        );
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                  // Bookmark button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          story['isBookmarked'] = _boolToString(!isBookmarked);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(!isBookmarked
                                ? 'Đã lưu để đọc sau!'
                                : 'Đã bỏ lưu!'),
                          ),
                        );
                      },
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Color(0xFF8C725E),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryListItem(Map<String, dynamic> story) {
    bool isFavorite = _stringToBool(story['isFavorite']?.toString());
    bool isBookmarked = _stringToBool(story['isBookmarked']?.toString());

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            story['isRead'] = _boolToString(true);
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleNewsItemPage(
                title: story['title']?.toString() ?? '',
                content: story['content']?.toString() ?? '',
                category: story['category']?.toString() ?? '',
                imageAssetPath: story['imageAssetPath']?.toString() ?? '',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Story image
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image:
                        AssetImage(story['imageAssetPath']?.toString() ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Story info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF8C725E).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        story['category']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8C725E),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Title
                    Text(
                      story['title']?.toString() ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    // Description
                    Text(
                      story['content']?.toString() ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // Stats
                    Row(
                      children: [
                        Icon(Icons.visibility,
                            size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          '${((story['title']?.toString().length ?? 0) * 0.1).round()}k',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          '${((story['content']?.toString().length ?? 0) / 200).round()} phút đọc',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action buttons
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        story['isFavorite'] = _boolToString(!isFavorite);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(!isFavorite
                              ? 'Đã thêm vào yêu thích!'
                              : 'Đã bỏ khỏi yêu thích!'),
                        ),
                      );
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        story['isBookmarked'] = _boolToString(!isBookmarked);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(!isBookmarked
                              ? 'Đã lưu để đọc sau!'
                              : 'Đã bỏ lưu!'),
                        ),
                      );
                    },
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Color(0xFF8C725E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
