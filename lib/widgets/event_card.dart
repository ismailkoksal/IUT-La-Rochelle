import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

/// Create an event card
/// [name] Event name
/// [speaker] Event speaker
/// [place] Place of event
/// [startTime] Event start time
/// [endTime] Event end time
class EventCard extends StatefulWidget {
  final Text name;
  final Text speaker;
  final Text place;
  final DateTime startTime;
  final DateTime endTime;

  const EventCard({
    Key key,
    this.name,
    this.speaker,
    this.place,
    this.startTime,
    this.endTime,
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        title: widget.name,
        enabled: isEventAlreadyStarted(eventStartTime: widget.startTime),
        subtitle:
            Text('${Jiffy(widget.startTime).Hm} - ${Jiffy(widget.endTime).Hm}'),
      ),
    );
  }

  bool isEventAlreadyStarted({@required DateTime eventStartTime}) {
    return DateTime.now().isBefore(eventStartTime);
  }
}
