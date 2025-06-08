import 'package:app/Pages/News/single_news_item_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleNewsItemPage extends StatefulWidget {
  final String title;
  final String content;
  final String category;
  final String imageAssetPath;

  const SingleNewsItemPage({
    super.key,
    required this.title,
    required this.content,
    required this.category,
    required this.imageAssetPath,
  });

  @override
  State<SingleNewsItemPage> createState() => _SingleNewsItemPageState();
}

class _SingleNewsItemPageState extends State<SingleNewsItemPage> {
  double _borderRadiusMultiplier = 1;
  bool _isTranslated = false;
  String _translatedContent =
      'Captain Jack finds an ancient map that leads to a legendary treasure on a mysterious island. Together with his brave crew, they overcome fierce storms, giant sea monsters and dangerous traps set by treasure guardians from hundreds of years ago..';
  double _fontSize = 16;
  bool _isDarkMode = false;

  bool _isSaved = false;

  // Dictionary for word translation (demo data)
  final Map<String, String> _dictionary = {
    'love': 'tình yêu',
    'heart': 'trái tim',
    'beautiful': 'đẹp',
    'wonderful': 'tuyệt vời',
    'happy': 'hạnh phúc',
    'sad': 'buồn',
    'life': 'cuộc sống',
    'dream': 'giấc mơ',
    'hope': 'hy vọng',
    'friendship': 'tình bạn',
    'family': 'gia đình',
    'home': 'nhà',
    'mother': 'mẹ',
    'father': 'cha',
    'child': 'đứa trẻ',
    'story': 'câu chuyện',
    'book': 'sách',
    'read': 'đọc',
    'write': 'viết',
    'learn': 'học',
    'old': 'cũ',
    'clothes': 'áo',
    'village': 'làng',
    'house': 'nhà',
    'small': 'nhỏ',
    'light': 'ánh sáng',
    'needle': 'kim',
    'thread': 'chỉ',
    'warm': 'ấm áp',
    'cold': 'lạnh',
    'night': 'đêm',
    'day': 'ngày',
    'time': 'thời gian',
    'year': 'năm',
    'month': 'tháng',
    'week': 'tuần',
    'yesterday': 'hôm qua',
    'today': 'hôm nay',
    'tomorrow': 'ngày mai',
    'good': 'tốt',
    'bad': 'xấu',
    'big': 'lớn',
    // ignore: equal_keys_in_map
    'small': 'nhỏ',
    'new': 'mới',
    'young': 'trẻ',
    'girl': 'cô gái',
    'boy': 'cậu bé',
    'man': 'người đàn ông',
    'woman': 'người phụ nữ',
    'friend': 'bạn',
    'teacher': 'giáo viên',
    'student': 'học sinh',
    'work': 'làm việc',
    'play': 'chơi',
    'eat': 'ăn',
    'drink': 'uống',
    'sleep': 'ngủ',
    'walk': 'đi bộ',
    'run': 'chạy',
    'talk': 'nói chuyện',
    'listen': 'nghe',
    'see': 'nhìn',
    'look': 'xem',
    'think': 'nghĩ',
    'know': 'biết',
    'understand': 'hiểu',
    'remember': 'nhớ',
    'forget': 'quên',
    'like': 'thích',
    'want': 'muốn',
    'need': 'cần',
    'have': 'có',
    'give': 'cho',
    'take': 'lấy',
    'come': 'đến',
    'go': 'đi',
    'stay': 'ở lại',
    'leave': 'rời đi',
  };

  @override
  void initState() {
    super.initState();
  }

  void _showWordTranslation(String word) {
    String cleanWord = word.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
    String? translation = _dictionary[cleanWord];

    if (translation != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF8C725E).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.translate, color: Color(0xFF8C725E)),
              ),
              SizedBox(width: 12),
              Text('Từ điển', style: TextStyle(color: Color(0xFF8C725E))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('EN',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        word,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[50]!, Colors.red[100]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('VI',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        translation,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
              label: Text('Đóng'),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF8C725E),
              ),
            ),
          ],
        ),
      );
    } else {
      // Hiển thị thông báo không tìm thấy từ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Không tìm thấy nghĩa của từ "$word"'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  String _getWordAtPosition(String text, int position) {
    if (position < 0 || position >= text.length) return '';

    // Tìm ranh giới từ
    int start = position;
    int end = position;

    // Tìm đầu từ
    while (start > 0 && RegExp(r'[a-zA-Z]').hasMatch(text[start - 1])) {
      start--;
    }

    // Tìm cuối từ
    while (end < text.length && RegExp(r'[a-zA-Z]').hasMatch(text[end])) {
      end++;
    }

    return text.substring(start, end).toLowerCase();
  }

  Widget _buildSelectableText(String text) {
    return GestureDetector(
      onTapDown: (details) {
        // Tìm từ tại vị trí click
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
              height: 1.6,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 40);

        final position =
            textPainter.getPositionForOffset(details.localPosition);
        final word = _getWordAtPosition(text, position.offset);

        if (word.isNotEmpty) {
          HapticFeedback.lightImpact();
          _showWordTranslation(word);
        }
      },
      child: SelectableText(
        text,
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.w500,
          height: 1.6,
          color: _isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final maxScreenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SingleNewsItemHeaderDelegate(
              borderRadiusAnimationValue: (value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _borderRadiusMultiplier = value;
                  });
                });
              },
              title: widget.title,
              category: widget.category,
              imageAssetPath: widget.imageAssetPath,
              minExtent: topPadding + 56,
              maxExtent: maxScreenSizeHeight / 2,
              topPadding: topPadding,
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: AnimatedContainer(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(40 * _borderRadiusMultiplier),
                color: _isDarkMode ? Colors.grey[800] : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reading controls
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.grey[700] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildControlButton(
                              icon:
                                  _isTranslated ? Icons.close : Icons.translate,
                              label: _isTranslated ? 'Bản gốc' : 'Dịch bài',
                              onTap: () {
                                setState(() {
                                  _isTranslated = !_isTranslated;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_isTranslated
                                        ? 'Đã chuyển sang bản dịch'
                                        : 'Đã chuyển về bản gốc'),
                                    duration: Duration(microseconds: 200),
                                  ),
                                );
                              },
                              isActive: _isTranslated,
                            ),
                            _buildControlButton(
                              icon: _isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              label: _isDarkMode ? 'Sáng' : 'Tối',
                              onTap: () {
                                setState(() {
                                  _isDarkMode = !_isDarkMode;
                                });
                              },
                              isActive: _isDarkMode,
                            ),
                            _buildControlButton(
                              icon: _isSaved
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              label: _isSaved ? 'Đã lưu' : 'Lưu',
                              onTap: () {
                                setState(() {
                                  _isSaved = !_isSaved;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_isSaved
                                        ? 'Đã lưu truyện!'
                                        : 'Đã bỏ lưu truyện!'),
                                    backgroundColor:
                                        _isSaved ? Colors.green : Colors.orange,
                                  ),
                                );
                              },
                              isActive: _isSaved,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text('Cỡ chữ: ',
                                style: TextStyle(
                                  color:
                                      _isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Slider(
                                value: _fontSize,
                                min: 12,
                                max: 24,
                                divisions: 12,
                                activeColor: Color(0xFF8C725E),
                                onChanged: (value) {
                                  setState(() {
                                    _fontSize = value;
                                  });
                                },
                              ),
                            ),
                            Text('${_fontSize.round()}px',
                                style: TextStyle(
                                  color:
                                      _isDarkMode ? Colors.white : Colors.black,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Content with translation tip
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Mẹo: Chọn một từ để xem nghĩa tiếng Việt!',
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Story content
                  _buildSelectableText(
                      _isTranslated ? _translatedContent : widget.content),

                  const SizedBox(height: 30),

                  // Reading progress or related stories
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF8C725E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Truyện tương tự',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8C725E),
                          ),
                        ),
                        SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              3,
                              (index) => Container(
                                margin: EdgeInsets.only(right: 12),
                                width: 120,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(widget.imageAssetPath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        'Truyện ${index + 1}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isActive ? Color(0xFF8C725E) : Color(0xFF8C725E).withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isActive ? Colors.white : Color(0xFF8C725E), size: 24),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Color(0xFF8C725E),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
