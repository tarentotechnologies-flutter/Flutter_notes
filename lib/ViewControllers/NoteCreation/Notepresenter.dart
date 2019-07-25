import 'package:flutter_notes_application/Models/RestApi.dart';
import 'package:flutter_notes_application/Models/notesmodel.dart';

abstract class NotePageContract {
  void onNotePageSuccess(NotesModel notes);
  void onNotePageError(String error);
}

class NotesPagepresenter {
  NotePageContract _view;
  RestData api = new RestData();
  NotesPagepresenter(this._view);

  NotesAdd(String isiconavail, String Name) {
    api
        .Notes(isiconavail, Name)
        .then((notes) => _view.onNotePageSuccess(notes))
        .catchError((onError) => _view.onNotePageError(onError.toString()));
  }


}
