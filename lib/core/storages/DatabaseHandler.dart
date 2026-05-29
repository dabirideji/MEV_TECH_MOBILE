import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mevtech/data/database_model.dart';
import 'package:mevtech/features/chat/data/signalr-model/chat_message.dart';
import 'package:mevtech/features/chat/data/signalr-model/room.dart';
import 'package:mevtech/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:mevtech/features/quiz/data/models/question_model.dart';
import 'package:mevtech/features/quiz/data/models/subject_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  factory DatabaseHandler() => _instance;

  DatabaseHandler._internal();
  static final DatabaseHandler _instance = DatabaseHandler._internal();

  // static Database? _database;
  Database? _database;
  String? _currentUserId;

  // Future<Database?> get database async {
  //   if (_database != null) return _database;
  //   return _database = await _initDatabase();
  //   // return _database;
  // }

  Future<Database?> get database async {
    if (_database == null) {
      throw Exception(
        'Database not initialized. Call openDatabaseForUser first.',
      );
    }
    return _database;
  }

  // Future<Database> _initDatabase() async {
  //   final path = join(await getDatabasesPath(), 'dblocal.db');
  //   return openDatabase(
  //     path,
  //     version: 2,
  //     onCreate: _createDatabase,
  //     onUpgrade: onUpgrade,
  //   );
  // }

  Future<Database> _initDatabase(String userId) async {
    final path = join(await getDatabasesPath(), 'dblocal_$userId.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onUpgrade: onUpgrade,
    );
  }

  Future<void> openDatabaseForUser(String userId) async {
    if (_currentUserId == userId && _database != null) return;

    await close();

    _database = await _initDatabase(userId);
    _currentUserId = userId;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      _currentUserId = null;
    }
  }

  Future<void> deleteUserDatabase(String? userId) async {
    if (userId == null) return;
    final path = join(await getDatabasesPath(), 'dblocal_$userId.db');

    await deleteDatabase(path);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE rooms (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      createdBy TEXT NOT NULL,
      members TEXT NOT NULL,
      settings TEXT NOT NULL,
      isPrivate INTEGER NOT NULL DEFAULT 0,
      password TEXT,
      lastMessageAt TEXT,
      maxMembers INTEGER NOT NULL,
      isArchived INTEGER NOT NULL DEFAULT 0,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    )
      ''');

    await db.execute('''
  CREATE TABLE messages (
    id TEXT PRIMARY KEY,
    roomId TEXT  NOT NULL,
    userId TEXT,
    username TEXT,
    content TEXT,
    type TEXT,
    timestamp TEXT,
    metadata TEXT,
    isEdited INTEGER NOT NULL DEFAULT 0,
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
    isDeleted INTEGER NOT NULL DEFAULT 0,
    deletedAt TEXT,
    deletedBy TEXT,
    isArchived INTEGER NOT NULL DEFAULT 0,
    archivedAt TEXT,
    archivedBy TEXT,
    physicallyArchivedAt TEXT,
    archiveReason TEXT
  )
''');

    await db.execute('''
    CREATE INDEX idx_messages_roomId
    ON messages(roomId);

    ''');

    await db.execute('''
    CREATE INDEX idx_messages_roomId_timestamp
    ON messages(roomId, timestamp);

    ''');

    await db.execute('''
    CREATE INDEX idx_room_createdAt
    ON rooms(createdAt);

    ''');

    await db.execute('''
  CREATE TABLE course (
    id TEXT PRIMARY KEY,
    courseName TEXT,
    courseTitle TEXT,
    description TEXT,
    isFree INTEGER,
    courseImageUrl TEXT,
    instructorId TEXT,
    categoryNames TEXT,
    tagNames TEXT,
    contentCount INTEGER,
    lessonCount INTEGER,
    quizCount INTEGER
   
  )
''');

    await db.execute('''
  CREATE TABLE courseCategory (
    id TEXT PRIMARY KEY,
    categoryName TEXT,
    categoryDescription TEXT,
    categoryImageUrl TEXT,
    courseCount INTEGER
   
  )
''');

    await db.execute('''
  CREATE TABLE questions (
  id INTEGER,
  subject TEXT,
  question TEXT,
  option TEXT,
  section TEXT,
  image TEXT,
  answer TEXT,
  solution TEXT,
  examtype TEXT,
  examyear TEXT,
  questionNub INTEGER,
  hasPassage INTEGER,
  category TEXT,
  PRIMARY KEY (id, subject)
)
''');

    await db.execute('''
  CREATE TABLE subjects (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE,
  updatedAt INTEGER
)
''');

    await db.execute('''
  CREATE INDEX IF NOT EXISTS idx_questions_subject
  ON questions(subject)
''');

    await db.execute('''
CREATE TABLE course_enrollments (
  id TEXT PRIMARY KEY,
  courseId TEXT NOT NULL,
  studentId TEXT NOT NULL,
  enrolledAt TEXT NOT NULL,
  completedAt TEXT,
  isCompleted INTEGER NOT NULL DEFAULT 0,
  course TEXT,
  studentName TEXT,
  courseTitle TEXT NOT NULL,
  UNIQUE (studentId, courseId)
)
''');

    await db.execute('''
   CREATE INDEX idx_enrollment_lookup
ON course_enrollments(studentId, courseId);
''');
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {}
    // if (oldVersion < 3) {
    //   await db.execute('ALTER TABLE stockitems ADD COLUMN stockbalance REAL');
    // }
    // if (oldVersion < 4) {

    // }
  }

  // Rooms

  Future<void> insertRooms(List<RoomMain> rooms) async {
    final db = await database;
    if (db == null) return;

    // Use a batch to perform all inserts efficiently in one transaction
    final batch = db.batch();

    for (final room in rooms) {
      batch.insert(
        'rooms',
        room.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);

    // remove the below
    // for (final room in rooms) {
    //   final res = await db.query(
    //     'room',
    //     where: 'id = ?',
    //     whereArgs: [room.id],
    //     limit: 1,
    //   );
    //   debugPrint('[DB READ BACK] ${res.first['timestamp']}');
    // }
    // log('done');
  }

  Future<void> insertSingleRoom(RoomMain room) async {
    final db = await database;
    if (db == null) return;

    await db.insert(
      'rooms',
      room.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteRoom(RoomMain room) async {
    final db = await database;
    if (db == null) return;

    await db.delete('rooms', where: 'id = ?', whereArgs: [room.id]);
  }

  Future<List<RoomMain>> getRooms() async {
    final db = await database;
    if (db == null) return [];
    final List<Map<String, dynamic>> maps = await db.query(
      'rooms',
      orderBy: 'createdAt DESC',
    );

    // ignore: unnecessary_lambdas
    final results = maps.map((m) => RoomMain.fromMap(m)).toList();

    return results;
  }

  Future<List<RoomMain>> getPaginatedDBRooms({
    required String previousCreatedAt,
    required int limit,
  }) async {
    final db = await database;
    if (db == null) return [];

    final maps = await db.query(
      'rooms',
      where: 'createdAt < ?',
      whereArgs: [previousCreatedAt],
      orderBy: 'createdAt DESC',
      limit: limit,
    );

    return maps.map(RoomMain.fromMap).toList();
  }

  Future<void> insertSingleMessage(MessageModel message) async {
    final db = await database;
    if (db == null) return;

    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteMessage(String id) async {
    final db = await database;
    if (db == null) return;

    await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateMessage(MessageModel message) async {
    final db = await database;
    if (db == null) return;

    await db.update(
      'messages',
      message.toEditUpdateMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<void> softDeleteMessage(MessageModel message) async {
    final db = await database;
    if (db == null) return;

    await db.update(
      'messages',
      message.toDeleteUpdateMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  // 'roomId = ? AND isDeleted = 0'

  Future<void> insertMessages(List<MessageModel> messages) async {
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

    // remove the below
    // for (final message in messages) {
    //   final res = await db.query(
    //     'messages',
    //     where: 'id = ?',
    //     whereArgs: [message.id],
    //     limit: 1,
    //   );
    //   debugPrint('[DB READ BACK] ${res.first['timestamp']}');
    // }
    // log('done');
  }

  Future<List<MessageModel>> getMessages(String roomId) async {
    final db = await database;
    if (db == null) return [];
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'roomId = ? AND isDeleted = 0',
      whereArgs: [roomId],
      orderBy: 'timestamp ASC',
    );

    // ignore: unnecessary_lambdas
    final results = maps.map((m) => MessageModelMapper.fromMap(m)).toList();

    // remove the below
    // for (final message in results) {
    //   // remove the below
    //   final res = await db.query(
    //     'messages',
    //     where: 'id = ?',
    //     whereArgs: [message.id],
    //     limit: 1,
    //   );
    //   debugPrint('[DB READ BACK] ${res.first['timestamp']}');
    // }
    // log('done');
    return results;
  }

  Future<List<MessageModel>> getPaginatedDBMessages({
    required String roomId,
    required String previousTimestamp,
    required int limit,
  }) async {
    final db = await database;
    if (db == null) return [];

    final maps = await db.query(
      'messages',
      where: 'roomId = ? AND isDeleted = 0 AND timestamp < ?',
      whereArgs: [roomId, previousTimestamp],
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return maps.map(MessageModelMapper.fromMap).toList();
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

  // ======================  general insertion ========================

  Future<void> insertDbRecord<T extends DatabaseModel>(
    String tableName,
    List<T> values,
  ) async {
    final db = await database;
    if (db == null) return;

    // Use a batch to perform all inserts efficiently in one transaction
    final batch = db.batch();

    for (final value in values) {
      batch.insert(
        tableName,
        value.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getDbRecords(String tableName) async {
    final db = await database;
    if (db == null) return [];
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      // where: 'roomId = ?',
      // whereArgs: [roomId],
      // orderBy: 'timestamp ASC',
    );

    return maps;
  }

  Future<List<Map<String, dynamic>>> getDbWhereRecords(
    String tableName, {
    String? where,
    Object? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    if (db == null) return [];
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$where = ?',
      whereArgs: [whereArgs],
      orderBy: orderBy,
    );

    return maps;
  }

  Future<void> deleteDbRecords(String tableName) async {
    final db = await database;
    if (db == null) return;
    await db.delete(tableName);
  }
  // ===========================================================

  Future<bool> insertRecords(
    Map<String, dynamic> initialValues,
    String tableName,
  ) async {
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
      final List<Map<String, dynamic>> results = await db!.rawQuery(
        selectQuery,
      );
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

  // quiz subject Database operation

  Future<bool> hasSubjects() async {
    final db = await database;
    if (db == null) return false;
    final res = await db.rawQuery('SELECT 1 FROM subjects LIMIT 1');
    return res.isNotEmpty;
  }

  Future<List<String>> getSubjects() async {
    final db = await database;
    if (db == null) return [];

    final res = await db.query('subjects');

    final data = res
        .map((e) => e['name'])
        .whereType<String>()
        .where((name) => name.trim().isNotEmpty)
        .toList();

    return data;
  }

  Future<void> saveSubjects(List<String> subjects) async {
    final db = await database;
    if (db == null) return;

    final batch = db.batch();

    for (final s in subjects) {
      batch.insert(
        'subjects',
        Subject.toMap(s.toLowerCase().trim()),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await batch.commit(noResult: true);
  }

  // quiz question database operations

  Future<bool> hasQuestions(String subject) async {
    final db = await database;
    if (db == null) return false;
    final res = await db.rawQuery(
      'SELECT 1 FROM questions WHERE subject = ? LIMIT 1',
      [subject.toLowerCase().trim()],
    );
    return res.isNotEmpty;
  }

  Future<List<QuestionModel>> getQuestionBySubject(
    String subject,
    int limit,
  ) async {
    final db = await database;
    if (db == null) return [];
    final res = await db.query(
      'questions',
      where: 'subject = ?',
      whereArgs: [subject.toLowerCase().trim()],
      orderBy: 'RANDOM()',
      limit: limit,
    );

    return res.map(QuestionModel.fromMap).toList();
  }

  Future<void> saveQuestions(
    String subject,
    List<QuestionModel> questions,
  ) async {
    final db = await database;
    if (db == null) return;
    final batch = db.batch();

    for (final q in questions) {
      final map = q.toMap();
      // 👇 inject subject HERE
      map['subject'] = subject.toLowerCase().trim();

      batch.insert(
        'questions',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  // Student enrolment

  Future<CourseEnrollmentModel?> getEnrollment({
    required String studentId,
    required String courseId,
  }) async {
    final db = await database;
    if (db == null) return null;

    final res = await db.query(
      'course_enrollments',
      where: 'studentId = ? AND courseId = ?',
      whereArgs: [studentId, courseId],
      limit: 1,
    );

    if (res.isEmpty) return null;

    return CourseEnrollmentModel.fromMap(res.first);
  }

  Future<void> saveEnrollment(CourseEnrollmentModel enrollment) async {
    final db = await database;
    if (db == null) return;
    await db.insert(
      'course_enrollments',
      enrollment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
