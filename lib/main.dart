import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_notes_application/ViewControllers/NoteCreation/Notecreation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Roboto",
        iconTheme: IconThemeData(color: Colors.black),
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.black),
        ),
        primarySwatch: Colors.blue,
      ),
      home: NotesHomePage(),

    );
  }
}
