import 'package:flutter_notes_application/Models/RestApi.dart';
import 'package:flutter_notes_application/Models/chapterModel.dart';

abstract class NoteDescPageContract {
  void onNotePageSuccess(Notedesc notesdesc);
  void onNotePageError(String error);
  void onPageUpdateSuccess(Notedesc noteUpdatedesc);
  void onNoteUpdateError(String error);
}

class NotesPageDescpresenter {
  NoteDescPageContract _view;
  RestData api = new RestData();
  NotesPageDescpresenter(this._view);

notedesc(int id, int _chapterID, String _title, String _description) {
  api
      .NoteChapter(id, _chapterID, _title, _description)
      .then((notesdesc) => _view.onNotePageSuccess(notesdesc))
      .catchError((onError) => _view.onNotePageError(onError.toString()));
}

  noteUpdatedesc(int id, int _chapterID, String _title, String _description) {
    api
        .NoteChapter(id, _chapterID, _title, _description)
        .then((noteUpdatedesc) => _view.onPageUpdateSuccess(noteUpdatedesc))
        .catchError((onError) => _view.onNoteUpdateError(onError.toString()));
  }

}

