import 'package:app/helpers/dbHelper.dart';

class Word {
  final String word;
  final String definition;

  Word({
    required this.word,
    required this.definition,
  });

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['target'] ?? '',
      // KHÔNG parse HTML ở đây, giữ nguyên để _formatDefinition() xử lý
      definition: map['definition'] ?? '',
    );
  }

  // Phương thức để lấy plain text (nếu cần thiết cho search hoặc preview)
  String get plainTextDefinition {
    if (definition.isEmpty) return '';

    String cleanText = definition
        .replaceAll(RegExp(r'<[^>]*>'), '') // Loại bỏ tất cả thẻ HTML
        .replaceAll(RegExp(r'\s+'), ' ') // Thay thế nhiều khoảng trắng bằng 1
        .trim();

    return cleanText;
  }

  static Future<Word?> search(String word) async {
    try {
      var dbHelper = DatabaseHelper();
      final db = await dbHelper.database;

      var results = await db.query(
        'dictionary',
        where: 'target = ?',
        whereArgs: [word],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      var row = results.first;
      Map<String, dynamic> wordMap = {
        'target': row['target'],
        'definition': row['definition'], // Giữ nguyên HTML
      };

      return Word.fromMap(wordMap);
    } catch (e) {
      print("❌ Lỗi khi tìm kiếm từ: $e");
      return null;
    }
  }

  static Future<List<String>> getSuggestions(String query) async {
    try {
      var dbHelper = DatabaseHelper();
      final db = await dbHelper.database;

      var results = await db.query(
        'dictionary',
        columns: ['target'],
        where: 'target LIKE ?',
        whereArgs: ['$query%'],
        limit: 10,
        orderBy: 'target ASC',
      );

      List<String> suggestions = [];
      for (var row in results) {
        suggestions.add(row['target'].toString());
      }

      return suggestions;
    } catch (e) {
      print("❌ Lỗi khi lấy gợi ý: $e");
      return [];
    }
  }

  static Future<List<Word>> searchMultiple(String query,
      {int limit = 10}) async {
    try {
      var dbHelper = DatabaseHelper();
      final db = await dbHelper.database;

      var results = await db.rawQuery('''
        SELECT * FROM dictionary 
        WHERE target LIKE ? 
          OR definition LIKE ? 
        ORDER BY 
          CASE 
            WHEN target = ? THEN 1
            WHEN target LIKE ? THEN 2
            ELSE 3
          END
        LIMIT ?
      ''', ['%$query%', '%$query%', query, '$query%', limit]);

      List<Word> words = [];
      for (var row in results) {
        Map<String, dynamic> wordMap = {
          'target': row['target'],
          'definition': row['definition'], // Giữ nguyên HTML
        };
        words.add(Word.fromMap(wordMap));
      }

      return words;
    } catch (e) {
      print("❌ Lỗi khi tìm kiếm multiple: $e");
      return [];
    }
  }
}
