import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class DateWidget extends StatefulWidget {
  final DateTime dateTime;
  final Color todayLabelColor;
  final Color dateLabelColor;

  const DateWidget(
      {Key key,
      @required this.dateTime,
      this.dateLabelColor,
      this.todayLabelColor})
      : super(key: key);

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            Jiffy(widget.dateTime).E.toUpperCase(),
            style: TextStyle(color: Colors.black26, fontSize: 12),
          ),
          Text(
            Jiffy(widget.dateTime).date.toString(),
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color:
                  (Jiffy(widget.dateTime).yMMMMd == Jiffy(DateTime.now()).yMMMMd
                      ? widget.todayLabelColor ?? Color(4278241023)
                      : widget.dateLabelColor ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
