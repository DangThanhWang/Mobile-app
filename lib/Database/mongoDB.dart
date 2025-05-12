import 'package:mongo_dart/mongo_dart.dart';
import 'package:app/Definitons/Constants.dart';

class MongoDBDatabase {
  static Db? _db;

  static Future<Db> connect() async {
    if (_db == null || !_db!.isConnected) {
      _db = await Db.create(MONGO_URL);
      await _db!.open();
    }
    return _db!;
  }

  static Future<DbCollection> getCollection(String name) async {
    final db = await connect();
    return db.collection(name);
  }

  static Future<List<Map<String, dynamic>>> getQuizData(String topic) async {
    final collection = await getCollection('quiz_questions');
    final results = await collection.find(where.eq('topic', topic)).toList();

    return results.map((doc) {
      return {
        'id': doc['_id'],
        'question': doc['question'],
        'options': List<String>.from(doc['options']),
        'answer': doc['answer'],
      };
    }).toList();
  }
}
