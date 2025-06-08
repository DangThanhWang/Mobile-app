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

  static Future<void> upsertUserProgress(
    String userId, {
    String score = "000.000.000.000.000",
    String name = "User",
  }) async {
    final collection = await getCollection('Progress');
    await collection.updateOne(
      where.eq('userId', userId),
      modify.set('name', name).set('score', score),
      upsert: true,
    );
  }

  static Future<int> getUserScore(String userId, {int index = 0}) async {
    final collection = await getCollection('Progress');
    final document = await collection.findOne({'userId': userId});
    final scoreString = document?['score'] ?? "000.000.000.000.000";
    final parts = scoreString.split('.');
    if (index >= 0 && index < parts.length) {
      return int.tryParse(parts[index]) ?? 0;
    }
    return 0;
  }

  static Future<void> setUserScore(String userId, int index, int value) async {
    if (index < 0 || index > 4) return;
    if (value < 0 || value > 999) return;

    final collection = await getCollection('Progress');
    final document = await collection.findOne({'userId': userId});
    String scoreString = document?['score'] ?? "000.000.000.000.000";
    List<String> parts = scoreString.split('.');

    String newValue = value.toString().padLeft(3, '0');
    parts[index] = newValue;
    String newScore = parts.join('.');

    await collection.updateOne(
      where.eq('userId', userId),
      modify.set('score', newScore),
      upsert: true,
    );
  }

  static Future<String> getUserName(String userId) async {
    final collection = await getCollection('Progress');
    final document = await collection.findOne({'userId': userId});
    return document?['name'] ?? "User";
  }

  static Future<String> getUserScoreString(String userId) async {
    final collection = await getCollection('Progress');
    final document = await collection.findOne({'userId': userId});
    return document?['score'] ?? "000.000.000.000.000";
  }
}
