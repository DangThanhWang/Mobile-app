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
}
