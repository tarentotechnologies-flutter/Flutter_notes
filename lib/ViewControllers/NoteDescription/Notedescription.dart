import 'package:flutter/material.dart';
import 'package:flutter_notes_application/ViewControllers/NoteCreation/Notecreation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesDescription(title: 'Scrolling and Cards'),
    );
  }
}

class NotesDescription extends StatefulWidget {
  NotesDescription({Key key, this.id, this.description, this.title})
      : super(key: key);
  String name;
  int id;
  String title;
  String description;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NotesDescription> {
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<Selection> select = new List();
  PageController controller = PageController();
  var currentPageValue = 0.0;
  List<Widget> cardList;
  String BookName = '';
  String Desc;
  List Items = [];
  bool iconavaliable = false;
  bool descTextShowFlag = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).orientation;
    Color color = Theme.of(context).primaryColor;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Notes Creation',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        body: Stack(children: <Widget>[
          PageView.builder(
            controller: controller,
//          scrollDirection: Axis.vertical,
            itemBuilder: (context, position) {
              if (position == currentPageValue.floor() + 1) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.004)
                    ..rotateY(currentPageValue - position)
                    ..rotateZ(currentPageValue - position),
                  child: Container(
                    color: position % 2 == 0 ? Colors.blue : Colors.pink,
                    child: Center(
                      child: Text(
                        "Page",
                        style: TextStyle(color: Colors.white, fontSize: 22.0),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  decoration: new BoxDecoration(
                    color: Colors.blue,
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  // color: position % 2 == 0 ? Colors.blue : Colors.pink,
                  margin: EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 20.0, right: 20.0),
//                margin: EdgeInsets.only(bottom: 100.0),

                  child: GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) =>
                        _onHorizontalDrag(details),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        new SizedBox(
                            height: 25.0,
                            child: new Center(
                                child: new Text(
                              widget.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                              ),
//                          style: TextStyle(
//                            fontSize: 20,
//                            fontWeight: FontWeight.bold,
//                            color: Colors.white,
//                          )
                            ))),
                        new Divider(
                          height: 5.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                            height: 450.0,
                            child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(3, 0, 5, 0),
                                child: new Text(widget.description,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    )))),
                        InkWell(
                          onTap: () {
                            setState(() {
                              descTextShowFlag = !descTextShowFlag;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              descTextShowFlag
                                  ? Text(
                                      "Show Less",
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  : Text("Show More",
                                      style: TextStyle(color: Colors.blue))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            itemCount: 10,
          ),
        ]));
  }

  _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity.compareTo(0) == -1)
      print('dragged from left');
    else
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotesHomePage()),
      );
    print('dragged from right');
  }
}

class Selection {
  String BookName;
  //Icons Icon;
  bool iconavaliable;
  Selection({this.BookName});
}

abstract class ListItem {}

// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;
  final String Desc;

  HeadingItem(this.heading, this.Desc);
}
