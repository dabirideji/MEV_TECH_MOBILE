import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:template/features/chat/data/signalr-model/chat_message.dart';

class DatabaseHandler {
  factory DatabaseHandler() => _instance;

  DatabaseHandler._internal();
  static final DatabaseHandler _instance = DatabaseHandler._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    return _database = await _initDatabase();
    // return _database;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'dblocal.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onUpgrade: onUpgrade,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
  CREATE TABLE messages (
    id TEXT PRIMARY KEY,
    roomId TEXT,
    userId TEXT,
    username TEXT,
    content TEXT,
    type TEXT,
    timestamp TEXT,
    metadata TEXT,
    isEdited INTEGER,
    replyToMessageId TEXT,
    replyToMessage TEXT,
    mentions TEXT,
    mediaId TEXT,
    readStatuses TEXT,
    media TEXT,
    editedAt TEXT,
    createdAt TEXT,
    updatedAt TEXT,
    rowVersion TEXT,
    createdBy TEXT,
    updatedBy TEXT,
    isDeleted INTEGER,
    deletedAt TEXT,
    deletedBy TEXT,
    isArchived INTEGER,
    archivedAt TEXT,
    archivedBy TEXT,
    physicallyArchivedAt TEXT,
    archiveReason TEXT
  )
''');
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {}

    // if (oldVersion < 3) {
    //   await db.execute('ALTER TABLE stockitems ADD COLUMN stockbalance REAL');
    // }
  }

  // db.execSQL("CREATE TABLE localpermissions(permissionstring TEXT)");

//   If a message with the same id exists, it’ll update/replace it.

// If not, it’ll insert a new one.

  // Future<void> insertMessage(MessageModel message) async {
  //   final db = await database;
  //   if (db == null) return;
  //   await db.insert(
  //     'messages',
  //     message.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  Future<void> insertSingleMessage(MessageModel message) async {
    final db = await database;
    if (db == null) return;

    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteMessage(MessageModel message) async {
    final db = await database;
    if (db == null) return;

    await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<void> updateMessage(MessageModel message) async {
    final db = await database;
    if (db == null) return;

    await db.update(
      'messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<void> insertMessage(List<MessageModel> messages) async {
    final db = await database;
    if (db == null) return;

    // Use a batch to perform all inserts efficiently in one transaction
    final batch = db.batch();

    for (final message in messages) {
      batch.insert(
        'messages',
        message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<MessageModel>> getMessages(String roomId) async {
    final db = await database;
    if (db == null) return [];
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'roomId = ?',
      whereArgs: [roomId],
      orderBy: 'timestamp ASC',
    );

    // ignore: unnecessary_lambdas
    return maps.map((m) => MessageModelMapper.fromMap(m)).toList();
  }

  Future<Map<String, List<MessageModel>>> getAllMessagesGroupedByRoom() async {
    final db = await database;
    if (db == null) return {};

    // Fetch all messages from the table
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      orderBy: 'timestamp ASC',
    );

    // Prepare a map to hold grouped messages
    final groupedMessages = <String, List<MessageModel>>{};

    for (final map in maps) {
      final message = MessageModelMapper.fromMap(map);
      final roomId = message.roomId;

      // If this room doesn't exist yet in the map, initialize it
      groupedMessages.putIfAbsent(roomId, () => []);

      // Add the message to its respective room list
      groupedMessages[roomId]!.add(message);
    }

    return groupedMessages;
  }

// usage

// final allGroupedMessages = await dbHelper.getAllMessagesGroupedByRoom();

// allGroupedMessages.forEach((roomId, messages) {
//   print('Room: $roomId has ${messages.length} messages');
// });

  Future<bool> insertRecords(
      Map<String, dynamic> initialValues, String tableName) async {
    var createSuccessful = false;
    final db = await database; // Assuming you have a reference to your database

    try {
      createSuccessful = await db!.insert(tableName, initialValues) > 0;
    } catch (e) {
      throw Exception(e);
    }

    return createSuccessful;
  }

  Future<List<Map<String, dynamic>>> getRecords(String selectQuery) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> results =
          await db!.rawQuery(selectQuery);
      return results;
    } catch (e) {
      // log('Error getting records: $e');
      return [];
    }
  }

  Future<void> deleteRecords(String deleteQuery) async {
    final db = await database; // Assuming you have a reference to your database

    await db!.rawDelete(deleteQuery);
  }

  Future<void> updateRecords(String updateQuery) async {
    final db = await database; // Assuming you have a reference to your database

    await db!.rawUpdate(updateQuery);
  }
}

// To get all rooms with messages (grouped)

// If you ever want to fetch messages grouped by rooms, you can query distinct room IDs first:

// Future<List<String>> getAllRoomIds() async {
//   final db = await database;
//   if (db == null) return [];

//   final List<Map<String, dynamic>> result =
//       await db.rawQuery('SELECT DISTINCT roomId FROM messages');

//   return result.map((row) => row['roomId'] as String).toList();
// }

// Then you can loop through each room ID and call getMessagesByRoom(roomId).
