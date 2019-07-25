import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:flutter_notes_application/Models/note.dart';
import 'package:flutter_notes_application/ViewControllers/NoteDescription/NoteDecsPresenter.dart';
import 'package:flutter_notes_application/Models/SqliteHandler.dart';
import 'package:flutter_notes_application/Models/chapterModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_notes_application/ViewControllers/NoteCreation/Notecreation.dart';
import 'package:sqflite/sqflite.dart';

class NotePageCreation extends StatefulWidget {
  NotePageCreation(
      {Key key, this.id, this.chapid, this.title, this.description, this.note})
      : super(key: key);
  String title;
  int id;
  int chapid;
  String description;
  final Notedesc note;

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.id, this.title, this.description, this.note);
  }
}

class NoteDetailState extends State<NotePageCreation>
    implements NoteDescPageContract {
//  NotesDBHandler helper = NotesDBHandler();
  NotesDBHandler databaseHelper = NotesDBHandler();

  int id;
  String appBarTitle;
  Notedesc Note;
  bool _canSaveButton = false;
  bool _canupdate = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  int count = 1;
  String title = 'Chapter Creation';
  List<Notedesc> noteList;

  String description;

  NoteDetailState(this.id, this.appBarTitle, this.description, this.Note);
  NotesPageDescpresenter _presenter;
  String updatetitle;
  String updatedesc;

  @override
  void initState() {
    // TODO: implement initState
    _presenter = new NotesPageDescpresenter(this);
    super.initState();
    setState(() {
      if (this.Note == null) {
        _canSaveButton = true;
      } else if (this.Note.title != null || this.Note.description != null) {
        _canupdate = true;
      } else {
        _canSaveButton = true;
      }
//      print(this.Note.title);
//      print(this.Note.description);
    });
  }

  @override
  void onNotePageSuccess(Notedesc notesdesc) async {
    var db = new NotesDBHandler();
    await db.insertNote(notesdesc);
    print('success');
    moveToLastScreen();
    // TODO: implement onNotePageSuccess
  }

  List<Notedesc> chapterList;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    if (this.Note != null) {
      titleController.text = Note.title;
      descriptionController.text = Note.description;
    } else {}
    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              this.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
            backgroundColor: Colors.blue,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
//          GestureDetector(
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    textAlign: TextAlign.start,
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      titleController.text = value;
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    maxLength: 25,
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    onChanged: (value) {
//                      debugPrint(value)
                      debugPrint('Something changed in Description Text Field');

                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Fourth Element
                _canSaveButton
                    ? Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(children: <Widget>[
                          Container(width: 5.0),
                          Expanded(
                              child: SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    // color: Theme.of(context).primaryColorDark,
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    elevation: 4.0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      side: BorderSide(color: Colors.white10),
                                    ),
                                    child: Text(
                                      'Save',
                                      textScaleFactor: 1.5,
                                      style: new TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
//                                      setState(() {
                                      _save();
//                                      });
                                    },
                                  ))),
                          Container(
                            width: 5.0,
                          ),
                          Expanded(
                              child: SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    // color: Theme.of(context).primaryColorDark,
                                    color: Colors.grey,
                                    textColor: Colors.white,
                                    elevation: 4.0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      side: BorderSide(color: Colors.white10),
                                    ),
                                    child: Text(
                                      'Clear All',
                                      textScaleFactor: 1.5,
                                      style: new TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        titleController.text = "";
                                        descriptionController.text = "";
                                      });
                                    },
                                  ))),
                        ]))
                    : SizedBox(),
                _canupdate
                    ? Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    color: Theme.of(context).primaryColorDark,
                                    textColor: Colors.black,
                                    elevation: 3.0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      side: BorderSide(color: Colors.white10),
                                    ),
                                    child: Text(
                                      'Update',
                                      textScaleFactor: 1.5,
                                      style: new TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _Update();
                                      });
                                    },
                                  ))),
                          Container(
                            width: 5.0,
                          ),
                          Expanded(
                              child: SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    // color: Theme.of(context).primaryColorDark,
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    elevation: 3.0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      side: BorderSide(color: Colors.white10),
                                    ),
                                    child: Text(
                                      'Delete',
                                      textScaleFactor: 1.5,
                                      style: new TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        delete();
                                      });
                                    },
                                  ))),
                        ]))
                    : SizedBox(),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotesHomePage(Id: widget.id)));
  }

  void getAllchapter(int Id) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Notedesc>> chapterList = databaseHelper.getChapterList(Id);

      chapterList.then((chapterList) {
        setState(() {
          this.noteList = chapterList;
          this.count = noteList.length;
          print(this.count);
          print(this.noteList);
        });
      });
    });
  }

  // Save data to database
  void _save() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter the Title and Desicption",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1);
    } else {
      _presenter.notedesc(
          widget.id, 0, titleController.text, descriptionController.text);
    }
  }

  @override
  void onNotePageError(String error) {
    print(error);
    // TODO: implement onNotePageError
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _Update() async {
    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (widget.id == null ||
        widget.title == null ||
        widget.title == null ||
        widget.description == null) {
      _showAlertDialog('Status', 'There is no chapter to edit ');
      return;
    } else {
      var db = new NotesDBHandler();
      await db.UpdateNote(Note);
      moveToLastScreen();
    }
  }

  delete() async {
    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (Note.chapterid == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteNote(Note.chapterid);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
    moveToLastScreen();
  }

  @override
  void onNoteUpdateError(String error) {
    // TODO: implement onNoteUpdateError
  }

  @override
  void onPageUpdateSuccess(Notedesc noteUpdatedesc) async {
    // TODO: implement onPageUpdateSuccess
    var db = new NotesDBHandler();
    await db.UpdateNote(noteUpdatedesc);
  }

  void updateDescription() {
    print(descriptionController);
    //widget.description = descriptionController.text;
    Note.description = descriptionController.text;
    print('nnn');
    print(description);
  }

  void updateTitle() {
    Note.title = titleController.text;
  }
}
