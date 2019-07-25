class NotesModel {
  int _id;
  String _IsIconAvail;
  String _Name;

  NotesModel(this._IsIconAvail, this._Name);
  NotesModel.withId(this._id, this._IsIconAvail);

  NotesModel.map(dynamic obj) {
    this._id = obj['Id'];
    this._IsIconAvail = obj['IsIconAvail'];
    this._Name = obj['Name'];
  }

  int get Id => _id;
  String get IsIconAvail => _IsIconAvail;
  String get Name => _Name;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Id"] = _id;
    map["IsIconAvail"] = _IsIconAvail;
    map["Name"] = _Name;
    return map;
  }

  NotesModel.fromMapObject(Map<String, dynamic> map) {
//  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['Id'];
    this._IsIconAvail = map['IsIconAvail'];
    this._Name = map['Name'];
  }
}
