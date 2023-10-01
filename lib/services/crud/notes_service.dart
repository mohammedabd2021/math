// // ignore_for_file: unrelated_type_equality_checks
//
import 'dart:async';

import 'package:mohammedabdnewproject/extensions/list/filter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

import 'CRUD_exception.dart';

//
// class NotesService {
//   Database? _db;
//   List<DatabaseNotes> _note = [];
//   static final NotesService _shared = NotesService._sharedInstance();
//
//   NotesService._sharedInstance(){
//     notesStreamController =
//     StreamController<List<DatabaseNotes>>.broadcast(onListen: () {
//       notesStreamController.sink.add(_note);
//     },);
//   }
//
//   factory NotesService() => _shared;
//   late final StreamController<List<DatabaseNotes>> notesStreamController;
//
//
//   Stream<List<DatabaseNotes>> get allNotes => notesStreamController.stream;
//
//   Future<DatabaseUser> getOrCreateUser({required String email}) async {
//     try {
//       final user = await getUser(email: email);
//       return user;
//     } on UserNotFoundException {
//       final createdUser = await createUser(email: email);
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<void> _cacheNote() async {
//     final allNotes = await getAllNotes();
//     _note = allNotes.toList();
//     notesStreamController.add(_note);
//   }
//
//   Future<DatabaseNotes> updateNote({
//     required DatabaseNotes note,
//     required String text,
//   }) async {
//     await ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     await getNote(id: note.id);
//     final updatedNote = db.update(noteTable, {
//       idColumn: note.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 0,
//     });
//     if (updatedNote == 0) {
//       throw CouldNotUpdateNoteException();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       _note.removeWhere((note) => note.id == updatedNote.id);
//       _note.add(updatedNote);
//       notesStreamController.add(_note);
//       return updatedNote;
//     }
//   }
//
//   Future<Iterable<DatabaseNotes>> getAllNotes() async {
//     await ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(noteTable);
//     return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
//   }
//
//   Future<DatabaseNotes> getNote({required int id}) async {
//     await ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final result = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = 1',
//       whereArgs: [id],
//     );
//     if (result.isEmpty) {
//       throw NoteNotFoundException();
//     } else {
//       final note = DatabaseNotes.fromRow(result.first);
//       _note.removeWhere((note) => note.id == id);
//       _note.add(note);
//       notesStreamController.add(_note);
//       return note;
//     }
//   }
//
//   Future<int> deleteAllNotes() async {
//     final db = _getDatabaseOrThrow();
//     final numberOfDelete = await db.delete(noteTable);
//     _note = [];
//     notesStreamController.add(_note);
//     return numberOfDelete;
//   }
//
//   Future<void> deleteNote({required int id}) async {
//     await ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedNote = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedNote == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _note.removeWhere((note) => note.id == id);
//       notesStreamController.add(_note);
//     }
//   }
//
//   Future<DatabaseNotes> createNotes({required DatabaseUser owner}) async {
//     await ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw UserNotFoundException();
//     }
//     const text = '';
//     final noteID = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });
//     final note = DatabaseNotes(
//       id: noteID,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//     );
//     _note.add(note);
//     notesStreamController.add(_note);
//
//     return note;
//   }
//
//   Future<DatabaseUser> getUser({required String email}) async {
//     await ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isEmpty) {
//       throw UserNotFoundException();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }
//
//   Future<DatabaseUser> createUser({required String email}) async {
//     await ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }
//     final userID =
//     await db.insert(userTable, {emailColumn: email.toLowerCase()});
//     return DatabaseUser(id: userID, email: email);
//   }
//
//   Future<void> deleteUser({required String email}) async {
//     final db = _getDatabaseOrThrow();
//     final userDeleted = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (userDeleted != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }
//
//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpenException();
//     } else {
//       return db;
//     }
//   }
//
//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpenException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }
//
//   Future<void> ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //empty
//     }
//   }
//
//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//
//       await db.execute(createUserTable);
//
//       await db.execute(createNotesTable);
//       await _cacheNote();
//     } on MissingPlatformDirectoryException {
//       throw UnableToProvideTheDirectoryException();
//     }
//   }
// }
//
// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;
//
//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });
//
//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;
//
//   @override
//   String toString() => 'person, ID = $id,email = $email';
//
//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
// }
//
// class DatabaseNotes {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;
//
//   DatabaseNotes({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });
//
//   DatabaseNotes.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud = (map[isSyncedWithCloudColumn]) == 1 ? true : false;
//
//   @override
//   String toString() =>
//       'Note,ID = $id,userID = $userId,IsSyncedWithCloud = $isSyncedWithCloud';
//
//   @override
//   bool operator ==(covariant DatabaseNotes other) => id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
// }
//
// //constants:
// const dbName = 'notes.db';
// const userTable = 'user';
// const noteTable = 'note';
//
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
//
// const idColumn = 'id';
// const emailColumn = 'email';
//
// const createNotesTable = '''CREATE TABLE IF NOT EXISTS "note" (
// 	"id"	INTEGER NOT NULL,
// 	"user_id"	INTEGER NOT NULL,
// 	"text"	TEXT,
// 	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
// 	FOREIGN KEY("user_id") REFERENCES "user"("id"),
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );''';
//
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
// 	"id"	INTEGER NOT NULL,
// 	"email"	TEXT NOT NULL UNIQUE,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );''';
class NotesService {
  Database? _db;
  DatabaseUser? _user;
  List<DatabaseNote> _notes = [];
  static final NotesService _share = NotesService._shareInstance();

  late final StreamController<List<DatabaseNote>> _notesStreamController;
  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream.filter((note) {
    final currentUser = _user;
    if (currentUser != null) {
      return note.userId == currentUser.id;
    }else{
      throw UserShouldBeSetBeforeReadingAllNotes();
    }
  });

  factory NotesService() => _share;

  NotesService._shareInstance() {
    _notesStreamController =
        StreamController<List<DatabaseNote>>.broadcast(onListen: () {
      _notesStreamController.sink.add(_notes);
    });
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
      // ignore: empty_catches
    } on DatabaseAlreadyOpenException {}
  }

  Future<DatabaseUser> getOrCreateUser({required String email,bool setAsCurrentUser = true}) async {
    try {
      final user = await getUser(email: email);
      if(setAsCurrentUser){
        _user = user;
      }
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      if (setAsCurrentUser) {
        _user = createdUser;
      }
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNote() async {
    final allNotes = await getAllNote();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatedNote = await db.update(noteTabel, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    },where: 'id = ?',whereArgs: [note.id]);
    // ignore: unrelated_type_equality_checks
    if (updatedNote == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      final noteUpdated = await getNote(id: note.id);
      _notes.removeWhere((element) => element.id == noteUpdated.id);
      _notes.add(noteUpdated);
      _notesStreamController.add(_notes);
      return noteUpdated;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTabel);
    return notes.map(
      (noteRow) => DatabaseNote.fromRow(noteRow),
    );
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTabel,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw NoteNotFoundException();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((element) => element.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletion = await db.delete(noteTabel);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletion;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedNote = await db.delete(
      noteTabel,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedNote == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((element) => element.id == id);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbUser =await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    String text = '';
    final noteId = await db.insert(
      noteTabel,
      {
        userIdColumn: owner.id,
        textColumn: text,
        isSyncedWithCloudColumn: 1,
      },
    );
    final note = DatabaseNote(
      id: noteId,
      text: text,
      userId: owner.id,
      isSyncedWithCloud: true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTabel,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTabel,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }
    final userId = await db.insert(
      userTabel,
      {emailColumn: email.toLowerCase()},
    );
    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = db.delete(userTabel,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);
    // ignore: unrelated_type_equality_checks
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      await _cacheNote();
    } on MissingPlatformDirectoryException {
      throw UnableToProvideTheDirectoryException();
    }
  }
}

class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person id, ID = $id,email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.text,
    required this.userId,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        text = map[textColumn] as String,
        userId = map[userIdColumn] as int,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id,userId = $userId, text = $text, is Synced With Cloud $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const noteTabel = 'note';
const userTabel = 'user';
const dbName = 'notes.db';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT));''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	FOREIGN KEY("user_id") REFERENCES "user"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
