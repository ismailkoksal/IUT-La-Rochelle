import 'package:edt_lr/pages/class_homework.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class CourseItem extends StatefulWidget {
  CourseItem(
      {Key key,
      this.name,
      this.prof,
      this.startHour,
      this.endHour,
      this.location,
      this.uid})
      : super(key: key);

  final String uid;
  final String name;
  final String location;
  final String prof;
  final String startHour;
  final String endHour;

  @override
  _CourseItemState createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goToCourseHomework(widget.uid),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(39, 125, 202, 1),
              Color.fromRGBO(39, 125, 202, 0.15),
            ],
            stops: [0.02, 0.02],
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.place,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text(widget.location),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text(widget.prof),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                        '${formatHour(widget.startHour)} - ${formatHour(widget.endHour)}'),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      formatHour(widget.startHour),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatHour(widget.endHour),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToCourseHomework(String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassHomeworkPage(classUid: uid),
      ),
    );
  }
}

Widget courseCard(String title, String subtitle) {
  return Card(
    elevation: 0,
    color: Color.fromRGBO(146, 142, 248, 1),
    child: Column(
      children: <Widget>[
        Text(
          title,
          style: titleStyle(),
        ),
        Text(subtitle),
      ],
    ),
  );
}

Widget hours(String startHour, String endHour) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      Text(
        formatHour(startHour),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      Text(
        formatHour(endHour),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ],
  );
}

String formatHour(String date) {
  Jiffy jiffy = new Jiffy(DateTime.parse(date))..local();
  return jiffy.format('HH:mm');
}

TextStyle titleStyle() {
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}
