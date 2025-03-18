import '../../helpers/dbHelper.dart';

class Word {
  final String word;
  final String definition;
  final String eDefinition;
  final String example;
  final String synonyms;
  final String pronounce;
  final String audio;
  final String source;
  final String type;

  Word({
    required this.word,
    required this.definition,
    required this.eDefinition,
    required this.example,
    required this.synonyms,
    required this.pronounce,
    required this.audio,
    required this.source,
    required this.type,
  });

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['source'],
      definition: map['target'],
      eDefinition: map['definition'] ?? '',
      example: map['example'] ?? '',
      synonyms: map['synonyms'] ?? '',
      pronounce: map['pronounce'] ?? '',
      audio: map['audio'] ?? '',
      source: map['source'] ?? '',
      type: map['type'] ?? '',
    );
  }

  static Future<Word?> search(String word) async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'bookmark',
      where: 'source = ?',
      whereArgs: [word],
    );

    if (result.isEmpty) {
      return null;
    }

    return Word.fromMap(result.first);
  }

  static Future<List<String>> Suggestions(String query) async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> results = await db.query(
      'bookmark',
      where: 'source LIKE ?',
      whereArgs: ['$query%'],
    );

    return results.map((e) => e['source'] as String).toList();
  }
}