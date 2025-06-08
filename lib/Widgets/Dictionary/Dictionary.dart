import 'package:app/Widgets/Dictionary/Word.dart';
import 'package:app/helpers/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Thêm package này

class Dictionary extends StatefulWidget {
  const Dictionary({super.key});

  @override
  State<Dictionary> createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  @override
  Widget build(BuildContext context) {
    return const SearchPage();
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  List<String> _suggestions = [];
  Word? _searchResult;
  bool _isLoading = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Thêm FlutterTts instance
  FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;

  var dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> words = [];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Khởi tạo TTS
    _initTts();
  }

  // Khởi tạo Text-to-Speech
  void _initTts() async {
    await flutterTts.setLanguage("en-US"); // Đặt ngôn ngữ tiếng Anh
    await flutterTts.setSpeechRate(0.5); // Tốc độ nói (0.0 - 1.0)
    await flutterTts.setVolume(1.0); // Âm lượng (0.0 - 1.0)
    await flutterTts.setPitch(1.0); // Cao độ giọng nói (0.5 - 2.0)

    // Lắng nghe trạng thái
    flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  // Hàm phát âm từ
  void _speakWord(String word) async {
    if (_isSpeaking) {
      await flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      setState(() {
        _isSpeaking = true;
      });
      await flutterTts.speak(word);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _controller.dispose();
    flutterTts.stop(); // Dừng TTS khi dispose
    super.dispose();
  }

  void _searchWord() async {
    String query = _controller.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _searchResult = null;
      });
      _fadeController.reset();

      try {
        Word? result = await Word.search(query);
        setState(() {
          _isLoading = false;
          _searchResult = result;
        });

        if (result != null) {
          _fadeController.forward();
          _slideController.forward();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Không tìm thấy từ '$query'"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi khi tìm kiếm: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateSuggestions(String query) async {
    if (query.isNotEmpty) {
      try {
        List<String> suggestions = await Word.getSuggestions(query);
        setState(() {
          _suggestions = suggestions;
        });
      } catch (e) {
        print("❌ Lỗi khi lấy gợi ý: $e");
        setState(() {
          _suggestions = [];
        });
      }
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _suggestions.clear();
      _searchResult = null;
    });
    _fadeController.reset();
    _slideController.reset();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              "Đã sao chép!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  List<Widget> _formatDefinition(String htmlDefinition) {
    List<Widget> widgets = [];

    if (htmlDefinition.isEmpty) {
      return [const Text('Không có định nghĩa')];
    }

    String cleanHtml = htmlDefinition
        .replaceAll('\uFEFF', '')
        .replaceAll(RegExp(r'^<[IQ]><[QI]>'), '')
        .replaceAll(RegExp(r'</[QI]></[IQ]>$'), '')
        .trim();

    // Tách từng dòng theo <br> hoặc <br/>
    List<String> lines = cleanHtml.split(RegExp(r'<br\s*/?>\s*'));

    for (String line in lines) {
      String trimmed = line.trim();

      if (trimmed.isEmpty) continue;

      // Phân loại dòng theo ký tự đầu
      if (trimmed.startsWith('@')) {
        // Phonetic: @dog /dɔg/
        widgets.add(_buildPhonetic(trimmed));
      } else if (trimmed.startsWith('*')) {
        // Word type: * danh từ, * ngoại động từ
        widgets.add(_buildWordType(trimmed));
      } else if (trimmed.startsWith('-')) {
        // Meaning: - chó, - chó săn
        widgets.add(_buildMeaning(trimmed));
      } else if (trimmed.startsWith('=')) {
        // Example: =a sly dog+ thằng cha vận đỏ
        widgets.add(_buildExample(trimmed));
      } else if (trimmed.startsWith('!')) {
        // Idiom: !to be a dog in the manger
        widgets.add(_buildIdiom(trimmed));
      } else {
        // Default HTML content
        widgets.add(_buildHtmlDefinition(trimmed));
      }

      // Thêm khoảng cách giữa các dòng
      widgets.add(const SizedBox(height: 6));
    }

    // Bỏ SizedBox cuối cùng nếu có
    if (widgets.isNotEmpty && widgets.last is SizedBox) {
      widgets.removeLast();
    }

    return widgets;
  }

  Widget _buildPhonetic(String line) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              line,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.indigo,
              ),
            ),
          ),
          // Thêm nút phát âm cho phần phonetic
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                _isSpeaking ? Icons.volume_off : Icons.volume_up,
                color: Colors.indigo,
                size: 20,
              ),
              onPressed: () {
                // Lấy từ trong ngoặc vuông hoặc toàn bộ dòng
                String wordToSpeak = line.contains(' ')
                    ? line.split(' ').first.replaceAll('@', '')
                    : line.replaceAll('@', '');
                _speakWord(wordToSpeak);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordType(String line) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        line,
        style: const TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildMeaning(String line) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Html(
              data: line.substring(1).trim(),
              style: {
                "body": Style(
                  fontSize: FontSize(15),
                  color: const Color(0xFF2D3748),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(String line) {
    // Xử lý format =text+ translation
    String content = line.substring(1).trim();

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 2, bottom: 2),
      child: Html(
        data: "<i>$content</i>",
        style: {
          "i": Style(
            color: Colors.grey.shade700,
            fontSize: FontSize(14),
          ),
          "body": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
        },
      ),
    );
  }

  Widget _buildIdiom(String line) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Html(
        data: "<b>${line.substring(1).trim()}</b>",
        style: {
          "b": Style(
            color: Colors.brown.shade700,
            fontSize: FontSize(15),
            fontWeight: FontWeight.bold,
          ),
          "body": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
        },
      ),
    );
  }

  Widget _buildHtmlDefinition(String line) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Html(
        data: line,
        style: {
          "body": Style(
            fontSize: FontSize(15),
            color: const Color(0xFF4A5568),
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Gradient
          SliverAppBar(
            expandedHeight: 60,
            floating: false,
            pinned: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: Color(0xF98C725E),
              ),
              child: const FlexibleSpaceBar(
                title: Text(
                  "Tra từ điển",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Enhanced Search Bar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm 1 từ tại đây...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 20,
                              ),
                              suffixIcon: _controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Colors.grey),
                                      onPressed: _clearSearch,
                                    )
                                  : null,
                            ),
                            onChanged: _updateSuggestions,
                            onSubmitted: (_) => _searchWord(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xF98C725E),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search,
                                color: Colors.white, size: 24),
                            onPressed: _searchWord,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Suggestions List with Animation
                  if (_suggestions.isNotEmpty)
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: _suggestions.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey.shade200,
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _controller.text = _suggestions[index];
                                setState(() {
                                  _suggestions.clear();
                                });
                                _searchWord();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF667eea)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.bookmark_border,
                                        color: const Color(0xFF667eea),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        _suggestions[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey.shade400,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // Loading Indicator
                  if (_isLoading)
                    SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFF667eea),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Đang tìm kiếm...",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Search Result Display with Animation
                  if (_searchResult != null)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Word Header với nút phát âm
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _searchResult!.word,
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF2D3748),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          // Nút phát âm chính
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade600,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                _isSpeaking
                                                    ? Icons.stop
                                                    : Icons.volume_up,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () => _speakWord(
                                                  _searchResult!.word),
                                              tooltip: _isSpeaking
                                                  ? 'Dừng phát âm'
                                                  : 'Phát âm',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xF98C725E),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.copy,
                                            color: Colors.white),
                                        onPressed: () => _copyToClipboard(
                                            _searchResult!.word),
                                        tooltip: 'Sao chép từ',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Definition Section with Enhanced Formatting
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          Colors.blue.shade200.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.book_outlined,
                                              color: Colors.blue.shade700,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "Định nghĩa",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: _formatDefinition(
                                            _searchResult!.definition),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Empty State
                  if (_searchResult == null &&
                      !_isLoading &&
                      _suggestions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.search_off,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Bắt đầu hành trình ngôn từ của bạn",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tìm kiếm bất kỳ từ nào để khám phá ý nghĩa của nó",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
