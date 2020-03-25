import 'package:flutter/material.dart';

class ClassHomeworkPage extends StatefulWidget {
  final String classUid;

  const ClassHomeworkPage({Key key, @required this.classUid}) : super(key: key);

  @override
  _ClassHomeworkPageState createState() => _ClassHomeworkPageState();
}

class _ClassHomeworkPageState extends State<ClassHomeworkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devoirs'),
      ),
      body: Container(
        child: Center(
          child: Text(widget.classUid),
        ),
      ),
    );
  }
}
