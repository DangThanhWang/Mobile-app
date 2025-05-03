import 'package:app/Database/mongoDB.dart';
import 'package:mongo_dart/mongo_dart.dart';

class RoomService {
  Future<String> createRoom(String userId, String roomName) async {
    final collection = await MongoDBDatabase.getCollection('Rooms');
    // ignore: deprecated_member_use
    final roomId = ObjectId().toHexString();

    await collection.insertOne({
      // ignore: deprecated_member_use
      "roomId": roomId, // Hoặc tạo random ID
      "userId": userId,
      "roomName": roomName,
      "messages": [],
      "totalTokens": 0,
      "createdAt": DateTime.now().toUtc().toIso8601String(),
      "updatedAt": DateTime.now().toUtc().toIso8601String(),
    });
    return roomId;
  }

  Future<String?> roomName(String roomId) async {
    final collection = await MongoDBDatabase.getCollection('Rooms');

    final room = await collection.findOne(where.eq('roomId', roomId));

    if (room == null || !room.containsKey('roomName')) {
      return null;
    }

    return room['roomName'] as String;
  }

  Future<void> addMessageToRoom(
      String roomId, String sender, String text) async {
    final collection = await MongoDBDatabase.getCollection('Rooms');
    final room = await collection.findOne(where.eq('roomId', roomId));

    if (room == null) throw Exception("Phòng không tồn tại");

    final List messages = room['messages'];
    if (messages.length >= 10) {
      throw Exception("Phòng đã đầy. Hãy tạo phòng mới.");
    }

    final tokens = countTokens(text);

    final message = {
      "sender": sender,
      "text": text,
      "tokens": tokens,
      "timestamp": DateTime.now().toUtc().toIso8601String(),
    };

    await collection.updateOne(
      where.eq('roomId', roomId),
      modify
        ..push('messages', message)
        ..inc('totalTokens', tokens)
        ..set('updatedAt', DateTime.now().toUtc().toIso8601String()),
    );

    // Cập nhật tokenUsed trong user
    final users = await MongoDBDatabase.getCollection('Users');
    await users.updateOne(
      where.eq('userId', room['userId']),
      modify.inc('subscription.tokensUsed', tokens),
    );
  }

  Future<List<Map<String, dynamic>>> getMessages(String roomId) async {
    try {
      final collection = await MongoDBDatabase.getCollection('Rooms');
      final room = await collection.findOne(where.eq('roomId', roomId));

      if (room == null) {
        return [];
      }

      final List messages = room['messages'] ?? [];
      return List<Map<String, dynamic>>.from(messages);
    } catch (e) {
      print('Error getting messages: $e');
      return [];
    }
  }

  Future<void> deleteRoom(String roomId) async {
    final collection = await MongoDBDatabase.getCollection('Rooms');
    await collection.deleteOne(where.eq('roomId', roomId));
  }

  Future<void> deleteMessage(String roomId) async {
    final collection = await MongoDBDatabase.getCollection('Rooms');
    final room = await collection.findOne(where.eq('roomId', roomId));

    if (room == null) {
      throw Exception("Phòng không tồn tại");
    }

    final List messages = room['messages'];
    if (messages.isEmpty) {
      throw Exception("Không có tin nhắn nào để xóa.");
    }

    await collection.updateOne(
      where.eq('roomId', roomId),
      modify
        ..set('messages', [])
        ..inc('totalTokens', -1)
        ..set('updatedAt', DateTime.now().toUtc().toIso8601String()),
    );
  }

  int countTokens(String text) {
    return text.trim().split(RegExp(r'\s+')).length;
  }
}
