import 'package:app/Widgets/Dictionary/Word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/helpers/dbHelper.dart';

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

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  List<String> _suggestions = [];
  Word? _searchResult;
  bool _isLoading = false;

  void _searchWord() async {
    String query = _controller.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _searchResult = null;
      });

      Word? result = await Word.search(query);
      setState(() {
        _isLoading = false;
        _searchResult = result;
      });
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
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dictionary", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF81C784),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search a word...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchWord,
                      ),
                    ),
                    onChanged: _updateSuggestions,
                    onSubmitted: (_) => _searchWord(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Suggestions List
            if (_suggestions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _suggestions[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      leading: const Icon(Icons.bookmark_border),
                      onTap: () {
                        _controller.text = _suggestions[index];
                        _suggestions.clear();
                        _searchWord();
                      },
                    );
                  },
                ),
              ),

            // Loading Indicator
            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),

            // Search Result Display
            if (_searchResult != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _searchResult!.word,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () => _copyToClipboard(_searchResult!.word),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Definition:",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          Text(
                            _searchResult!.definition,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 16),
                          if (_searchResult!.example.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Example:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                                Text(
                                  _searchResult!.example,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          if (_searchResult!.synonyms.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Synonyms:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                                Text(
                                  _searchResult!.synonyms,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // "No Results" Display
            if (_searchResult == null && !_isLoading && _suggestions.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No results found. Try searching for a different word.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


