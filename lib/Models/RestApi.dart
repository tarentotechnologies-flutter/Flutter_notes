import 'dart:async';
import 'package:flutter_notes_application/ViewControllers/NoteCreation/Notecreation.dart';
import 'package:flutter_notes_application/Models/chapterModel.dart';
import 'package:flutter_notes_application/Models/notesmodel.dart';
import 'package:flutter_notes_application/Models/updatechapter.dart';

class RestData {
  Future<NotesModel> Notes(String IsIconAvail, String Name) {
    return new Future.value(new NotesModel(IsIconAvail, Name));
  }

  Future<Notedesc> NoteChapter(
      int _id, int _chapterID, String _title, String _description) {
    return new Future.value(new Notedesc(_id, _title, _description));
  }

  Future<NotesUpdate> noteUpdatedesc(
      int _id, int _chapterID, String _title, String _description) {
    return new Future.value(
        new NotesUpdate(_id, _chapterID, _title, _description));
  }
}
