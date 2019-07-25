import 'package:flutter/material.dart';
import 'package:flutter_notes_application/Models/updatechapter.dart';
import 'package:flutter_notes_application/Models/notesmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_notes_application/ViewControllers/NoteDescription/Notedescription.dart';
import 'package:flutter_notes_application/ViewControllers/NoteCreation/Notepresenter.dart';
import 'package:flutter_notes_application/Models/SqliteHandler.dart';
import 'package:flutter_notes_application/ViewControllers/Pagecreation/NotePage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_notes_application/Models/chapterModel.dart';
import 'package:progress_hud/progress_hud.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesHomePage(title: 'Scrolling and Cards'),
    );
//
  }
}

class NotesHomePage extends StatefulWidget {
  NotesHomePage({Key key, this.title, this.Id}) : super(key: key);
  final String title;
  final int Id;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NotesHomePage>
    implements NotePageContract {
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<Selection> select = new List();
  bool _validate = false;
  final _text = TextEditingController();
  PageController controller = PageController();
  var currentPageValue = 0.0;
  List<Widget> cardList;
  String BookName = "";
  String Desc;
  bool _loading = true;
  ProgressHUD _progressHUD;
  List Items = [];
  int count = 0;
  int Id = 1;
  String Name;
  bool iconavaliable = false;
  NotesDBHandler databaseHelper = NotesDBHandler();
  List<NotesModel> noteList;
  bool descTextShowFlag = false;
  bool _canShowButton = true;
  List<Notedesc> chapList;
  List<NotesUpdate> NoteList;

  int count11 = 0;

  int _selectedIndex = 0;
  @override
  void initState() {
    getAllchapter(Id);
    if (widget.Id == null) {
    } else {
      Id = widget.Id;
    }
    print(widget.Id);
//    _selectedIndex = widget.Id;
    print('idddddddd');
    // TODO: implement initState
    super.initState();
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.white,
      color: Colors.grey,
      containerColor: Colors.white,
      borderRadius: 5.0,
      text: 'Loading...',
    );
    setState(() {
      updateListView();
    });
  }

  void dismissProgressHUD() {
    setState(() {
      if (_loading) {
        _progressHUD.state.dismiss();
      } else {
        _progressHUD.state.show();
      }
      _loading = !_loading;
    });
  }

  Widget get showWidget {
    if (_loading) {
      getAllchapter(Id);
      return loadingScreen;
    } else {
      //_progressHUD.state.dismiss();
      return NotesCreationPage;
    }
  }

  Widget get loadingScreen {
    return new Stack(
      children: <Widget>[
        new Text(''),
        _progressHUD,
      ],
    );
  }

  Widget get NotesCreationPage {
    return Stack(children: <Widget>[
      PageView.builder(
//        controller: controller,
//      scrollDirection: Axis.vertical,
        physics: new NeverScrollableScrollPhysics(),
        itemBuilder: (context, position) {
          if (this.chapList.length == 0) {
            return Container(
                margin: EdgeInsets.only(
                    top: 20.0, bottom: 90.0, left: 20.0, right: 20.0),
                child: GestureDetector(
                    child: Stack(
                  children: <Widget>[
                    Swiper(
                        itemWidth: 200.0,
                        itemHeight: 300.0,
                        physics: new NeverScrollableScrollPhysics(),
                        loop: false,
                        itemBuilder: (context, index) {
//                          noteList = this.noteList[index];
                          return new GestureDetector(
                              child: Container(
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Container(
                                    height: 350.0,
                                    width: 280.0,
                                    // width: MediaQuery.of(context).size.width,
                                    child: new Card(
                                        color: Colors.lightBlue,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(7.0),
                                        ),
                                        margin: new EdgeInsets.only(top: 05.0),
                                        child: new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: new EdgeInsets.only(
                                                    left: 15.0, right: 15.0),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: new Text(
                                                      'Click Add Note To Proceed',
                                                      style: new TextStyle(
                                                        fontSize: 15.0,
                                                        fontFamily: 'Roboto',
                                                        //fontStyle: 'Bold',
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              ),
                                            ])))
                              ],
                            ),
                          ));
                        },
                        itemCount: this.count),
                    new Container(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                            color: Colors.white,
                            child: Text("Add Note"),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.red),
                            ),
                            elevation: 5.0,
                            onPressed: () {
                              _navigateToDetail(this.Id);
                            }))
                  ],
                )));
          } else {
            return Container(
                margin: EdgeInsets.only(
                    top: 20.0, bottom: 90.0, left: 20.0, right: 20.0),
                child: GestureDetector(
                    child: Stack(
                  children: <Widget>[
                    Swiper(
                        loop: false,
                        index: 0,
                        autoplay: false,
                        layout: SwiperLayout.STACK,
                        customLayoutOption: new CustomLayoutOption(
                                startIndex: -1, stateCount: -1)
                            .addRotate(
                                [-45.0 / 180, 0.0, 45.0 / 180]).addTranslate([
                          new Offset(-370.0, -40.0),
                          new Offset(0.0, 0.0),
                          new Offset(370.0, -40.0)
                        ]),
                        itemWidth: 300.0,
                        itemHeight: 400.0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          int startindex = index + 1;
                          return new GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotePageCreation(
                                              id: Id,
                                              chapid:
                                                  this.chapList[position].id,
                                              title: this.chapList[index].title,
                                              description: this
                                                  .chapList[index]
                                                  .description,
                                              note: this.chapList[position],
                                            ),
                                      ));
                                });
                              },
                              onHorizontalDragEnd: (DragEndDetails details) =>
                                  _onHorizontalDrag(
                                      details,
                                      this.chapList[index].title,
                                      this.chapList[index].description),
                              child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(7.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  color: Colors.blue,
                                ),
                                child: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Container(
                                        padding: new EdgeInsets.only(top: 16.0),
                                        child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: new EdgeInsets.only(
                                                    left: 15.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: new Text(
                                                    this.chapList[index].title,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 20,
                                                        fontFamily: 'Roboto'),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    new EdgeInsets.all(15.0),
                                                child: Container(
                                                  height: 290.0,
                                                  child: SingleChildScrollView(
                                                    child: new Text(
                                                      this
                                                          .chapList[index]
                                                          .description,
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      style: new TextStyle(
                                                        fontSize: 17.0,
                                                        fontFamily: 'Roboto',
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    200.0, 0.0, 0.0, 0.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        '$startindex/$count11',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]))
                                  ],
                                ),
                              ));
                        },
                        itemCount: this.count11,
                        viewportFraction: 0.8,
                        scale: 0.9),
                    new Container(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                            color: Colors.white,
                            child: Text("Add Note"),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.red),
                            ),
                            elevation: 5.0,
                            onPressed: () {
                              _navigateToDetail(this.Id);
                            }))
                  ],
                )));
          }
        },
      ),
      new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              color: Colors.lightBlue,
              height: 80.0,
              width: 400.0,
              margin:
                  const EdgeInsets.only(bottom: 0, right: 3, left: 3, top: 3),
              child: new Row(children: [
                new Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(right: 6, left: 6),
                      child: GridView.builder(
                        itemCount: this.count,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, position) {
                          return GestureDetector(
                              onTap: () => setState(() {
                                    this.Id = this.noteList[position].Id;
                                    this.Name = this.noteList[position].Name;
                                    getAllchapter(this.noteList[position].Id);
                                  }),
                              child: Card(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(7.0),
                                  ),
                                  color: _selectedIndex != null &&
                                          _selectedIndex == position
                                      ? Colors.lightBlueAccent[100]
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      this.noteList[position].Name,
                                      textAlign: TextAlign.center,
                                      style: _selectedIndex != null &&
                                              _selectedIndex == position
                                          ? TextStyle(color: Colors.white)
                                          : TextStyle(color: Colors.black),
                                    ),
                                  )));
                        },
                      )),
                  flex: 4,
                ),
                new Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(right: 6, left: 0),
                      child: GridView.builder(
                          itemCount: 1,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1),
//                              scrollDirection: Axis.horizontal,

                          shrinkWrap: true,
                          itemBuilder: (context, position) {
                            return GestureDetector(
                                onTap: () => setState(() {
                                      print([position]);
                                    }),
                                child: RaisedButton(
                                  color: Colors.white,
                                  elevation: 4.0,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(7.0),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                  splashColor: Colors.white10,
                                  child: new Icon(Icons.add),
                                  onPressed: () => {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _builtdialog(context),
                                        )
                                      },
                                ));
                          }),
                      decoration: new BoxDecoration(boxShadow: [
                        new BoxShadow(
                          // spreadRadius: 5,
                          color: Colors.blue,
                          blurRadius: 5.0,
                        ),
                      ])),
                  flex: 1,
                ),
              ]),
            )
          ])
    ]);
  }

  NotesPagepresenter _presenter;
  _MyHomePageState() {
    _presenter = new NotesPagepresenter(this);
  }
  @override
  Widget build(BuildContext context) {
    if (NoteList == null) {
      NoteList = List<NotesUpdate>();
      updateListView();
    }

    MediaQuery.of(context).orientation;
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Notes Creation',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
//        backgroundColor: Colors.blueAccent[100],
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _builtdialog(BuildContext context) {
    return new AlertDialog(
      content: Form(
          key: this._formKey,
          autovalidate: _validate,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(9.0),
                child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text,
                    maxLength: 10,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                    decoration:
                        new InputDecoration(hintText: 'Please Enter Your Name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Enter the Book  Name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1);
                      }
                    },
                    onSaved: (value) {
                      this.BookName = value;
                      print(this.BookName);
                    }),
              ),
              Padding(
                padding: EdgeInsets.all(9.0),
                child: RaisedButton(
                  child: Text("Submit"),
                  onPressed: () => setState(() {
                        print(_text.text);
                        if (_text.text == null || _text.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please Enter the Book  Name",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIos: 1);
                        } else {
                          if (this.noteList.any((E) => E.Name == _text.text)) {
                            Fluttertoast.showToast(
                                msg:
                                    "Please Enter the BookName Already exists.. Please choose different Name ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 5);
                          } else {
                            _presenter.NotesAdd('No', _text.text);
                          }

                          moveToLastScreen();
                          getAllchapter(Id);
                        }
                        _text.text = '';
                      }),
                ),
              ),
            ],
          )),
    );
  }

  _onHorizontalDrag(
      DragEndDetails details, String desctitle, String chapdescription) {
    if (details.primaryVelocity == 0)
      return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity.compareTo(0) == -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotesDescription(
                title: desctitle, description: chapdescription)),
      );
    }
  }

  @override
  void onNotePageError(String error) {
    // TODO: implement onNotePageError
  }

  @override
  void onNotePageSuccess(NotesModel notes) async {
    var db = new NotesDBHandler();
    int result = await db.FristNote(notes);
    print(result);
    print(notes);
    updateListView();
    getAllchapter(result);

    // TODO: implement onNotePageSuccess
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<NotesModel>> noteList = databaseHelper.getNoteList();
      noteList.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
          print(this.count);
        });
      });
    });
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _navigateToDetail(int id) {
    print(this.noteList.length);
    if (this.noteList.length == 0) {
      Fluttertoast.showToast(
          msg: "Please Enter the BookName to add Page description..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 5);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotePageCreation(id: id),
          ));
      getAllchapter(Id);
    }
  }

  void getAllchapter(int Id) {
    print(Id);
    _selectedIndex = Id - 1;
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Notedesc>> chapterList = databaseHelper.getChapterList(Id);
      chapterList.then((chapterList) {
        setState(() {
          this.chapList = chapterList;
          this.count11 = chapList.length;
          print(this.count11);
          print(this.chapList);
        });
      });
      _loading = false;
    });
  }

  Widget _buildBody() {
    Widget body;
    if (_loading) {
      // _progressHUD.state.show();
      body = loadingScreen;
      getAllchapter(Id);
    } else {
      //_progressHUD.state.dismiss();
      body = NotesCreationPage;
    }
    return body;
  }

  editChapnotes(String title, String description) {
    print('double clicked');
    if (title.isEmpty || description.isEmpty) {
      Fluttertoast.showToast(
          msg:
              "Please Enter the BookName Already exists.. Please choose different Name ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 5);
    } else {


    }
  }
}
