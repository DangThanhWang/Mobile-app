import 'package:app/Widgets/Dictionary/Word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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

      Word? result = await Word.search(query);
      setState(() {
        _isLoading = false;
        _searchResult = result;
      });

      if (result != null) {
        _fadeController.forward();
        _slideController.forward();
      }
    }
  }

  void _updateSuggestions(String query) async {
    if (query.isNotEmpty) {
      List<String> suggestions = await Word.Suggestions(query);
      setState(() {
        _suggestions = suggestions;
      });
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
              "Copied to clipboard!",
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
                              "Searching...",
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
                                // Word Header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Definition Section
                                _buildSection(
                                  "Definition",
                                  _searchResult!.definition,
                                  Icons.book_outlined,
                                  const Color(0xFF3182CE),
                                ),

                                // Example Section
                                if (_searchResult!.example.isNotEmpty) ...[
                                  const SizedBox(height: 20),
                                  _buildSection(
                                    "Example",
                                    _searchResult!.example,
                                    Icons.lightbulb_outline,
                                    const Color(0xFFD69E2E),
                                  ),
                                ],

                                // Synonyms Section
                                if (_searchResult!.synonyms.isNotEmpty) ...[
                                  const SizedBox(height: 20),
                                  _buildSection(
                                    "Synonyms",
                                    _searchResult!.synonyms,
                                    Icons.swap_horiz,
                                    const Color(0xFF38A169),
                                  ),
                                ],
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

  Widget _buildSection(
      String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4A5568),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
