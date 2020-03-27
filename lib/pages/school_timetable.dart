import 'package:edt_lr/models/event.dart';
import 'package:edt_lr/services/api.dart';
import 'package:edt_lr/widgets/date.dart';
import 'package:edt_lr/widgets/event_card.dart';
import 'package:edt_lr/widgets/sliver_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolTimetablePage extends StatefulWidget {
  @override
  _SchoolTimetablePageState createState() => _SchoolTimetablePageState();
}

class _SchoolTimetablePageState extends State<SchoolTimetablePage> {
  Future<List<Event>> _schoolTimetable;

  @override
  void initState() {
    super.initState();
    _schoolTimetable = getSchoolTimetable();
  }

  Future<List<Event>> getSchoolTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentId = prefs.getString('studentId');
    List<Event> mergedEvents = [];
    var results = await Future.wait([
      Api.getStudentSchedule(week: Jiffy().week, studentId: studentId),
      Api.getStudentSchedule(week: Jiffy().week + 1, studentId: studentId),
    ]);
    for (var response in results) {
      mergedEvents.addAll(response);
    }
    return mergedEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _schoolTimetable,
        builder: (context, AsyncSnapshot<List<Event>> snapshot) {
          Widget newsListSliver;
          if (snapshot.hasData) {
            List<Event> events = snapshot.data;
            events.sort((a, b) => a.dtstart.compareTo(b.dtstart));
            List<DateTime> eventsDate = getEventsDate(events);

            newsListSliver = SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  List<Event> dateEvents =
                      getEventsByDate(events, eventsDate[index]);
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 60,
                          padding: EdgeInsets.only(top: 5),
                          child: DateWidget(
                            dateTime: eventsDate[index],
                            todayLabelColor: Color(4278241023),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              for (var event in dateEvents)
                                EventCard(
                                  name: Text(event.description.spe),
                                  startTime: event.dtstart,
                                  endTime: event.dtend,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: eventsDate.length,
              ),
            );
          } else {
            newsListSliver = SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()));
          }

          return CustomScrollView(
            slivers: <Widget>[CustomSliverAppBar(), newsListSliver],
          );
        },
      ),
    );
  }

  List<DateTime> getEventsDate(List<Event> events) {
    return events
        .map((e) => DateTime.parse(Jiffy(e.dtstart).format('yyyy-MM-dd')))
        .where((e) => e.isAfter(DateTime.now().subtract(Duration(days: 2))))
        .toSet()
        .toList();
  }

  List<Event> getEventsByDate(List<Event> events, DateTime date) {
    return events
        .where((e) => DateTime.parse(Jiffy(e.dtstart).format('yyyy-MM-dd'))
            .isAtSameMomentAs(date))
        .toList();
  }
}
