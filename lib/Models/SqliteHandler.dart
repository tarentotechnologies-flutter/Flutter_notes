import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:flutter_notes_application/Models/chapterModel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_notes_application/Models/notesmodel.dart';

class NotesDBHandler {
  static final NotesDBHandler _instance = new NotesDBHandler.internal();
  factory NotesDBHandler() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initializeDatabase();
    return _db;
  }

  NotesDBHandler.internal();

  Future<Database> initializeDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Noteheader(Id INTEGER PRIMARY KEY AUTOINCREMENT, IsIconAvail TEXT, Name TEXT)");
    await db.execute(
        "CREATE TABLE noteTable(id INTEGER, chapterId INTEGER PRIMARY KEY AUTOINCREMENT, Title TEXT, Description TEXT)");
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

// build the create query dynamically using the column:field dictionary.

//
  static Future<String> dbPath() async {
    String path = await getDatabasesPath();
    return path;
  }

  Future<int> FristNote(NotesModel note) async {
    var dbClient = await db;
    print("insert called");
    var result = await dbClient.insert("Noteheader", note.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> selectAllNotes() async {
    var dbClient = await db;
    // query all the notes sorted by last edited
    var data = await dbClient.query("Noteheader",
        orderBy: "date_last_edited desc",
        where: "is_archived = ?",
        whereArgs: [0]);

    return data;
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    var dbClient = await db;
    var result = await dbClient.query("Noteheader");
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<NotesModel>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<NotesModel> noteList = List<NotesModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(NotesModel.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Notedesc note) async {
    Database db = await _db;
    var result = await db.insert("noteTable", note.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getChapterMapList(int Id) async {
    var dbClient = await db;

    var result =
        await dbClient.rawQuery('SELECT * FROM noteTable WHERE id = $Id');
    return result;
  }

  Future<List<Notedesc>> getChapterList(int Id) async {
    var notechapterList =
        await getChapterMapList(Id); // Get 'Map List' from database
    int count =
        notechapterList.length; // Count the number of map entries in db table

    List<Notedesc> chapterdesc = List<Notedesc>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      chapterdesc.add(Notedesc.fromMapObject(notechapterList[i]));
    }
    return chapterdesc;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> UpdateNote(Notedesc note) async {
    var db = await this.db;
    var res = await db.update("noteTable", note.toMap(),
        where: "chapterId = ?", whereArgs: [note.chapterid]);
    return res;
  }

  Future<int> deleteNote(int id) async {
    var db = await this.db;
//    final db = await database;
    int result =
        await db.delete("noteTable", where: "chapterId = ?", whereArgs: [id]);
//    int result =  await db.rawDelete('DELETE FROM Noteheader WHERE Id = $id');
    return result;
  }
}
