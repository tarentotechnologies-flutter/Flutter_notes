class NotesDescModel {
  int _id;
  int _chapterId;
  String _ChapterName;
  String _ChapterDesc;

  NotesDescModel(
      this._id, this._chapterId, this._ChapterName, this._ChapterDesc);
  NotesDescModel.withId(
      this._id, this._chapterId, this._ChapterName, this._ChapterDesc);

  NotesDescModel.map(dynamic obj) {
    this._id = obj['Id'];
    this._chapterId = obj['ChapterID'];
    this._ChapterName = obj['ChapterName'];
    this._ChapterDesc = obj['ChapterDesc'];
  }

  int get Id => _id;
  int get ChapterID => _chapterId;
  String get ChapterName => ChapterName;
  String get ChapterDesc => ChapterDesc;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Id"] = _id;
    map["ChapterId"] = ChapterID;
    map["ChapterName"] = ChapterName;
    map["ChapterDesc"] = ChapterDesc;
    return map;
  }

  NotesDescModel.fromMapObject(Map<String, dynamic> map) {
//  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['Id'];
    this._chapterId = map['ChapterID'];
    this._ChapterName = map['ChapterName'];
    this._ChapterDesc = map['ChapterDesc'];
  }
}
