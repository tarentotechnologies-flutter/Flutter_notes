class NotesUpdate {
  int _id;
  int _chapterID;
  String _title;
  String _description;

  NotesUpdate(this._id, this._chapterID, this._title, this._description);

  NotesUpdate.withId(this._id, this._chapterID, this._title, this._description);

  int get id => _id;

  int get chapterid => _chapterID;

  String get title => _title;

  String get description => _description;

  set title(String newTitle) {
    this._title = newTitle;
  }

  set description(String newDescription) {
    this._description = newDescription;
  }

//   Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['chapterID'] = _chapterID;
    map['title'] = _title;
    map['description'] = _description;

    return map;
  }

  // Extract a Note object from a Map object
  NotesUpdate.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._chapterID = map['chapterId'];
    this._title = map['Title'];
    this._description = map['Description'];
  }
}
