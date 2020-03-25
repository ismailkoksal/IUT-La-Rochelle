import 'package:edt_lr/api.dart';
import 'package:edt_lr/models/event.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<List<Event>> _schoolTimetable;

  void setJiffyLocale() async {
    await Jiffy.locale("fr");
  }

  @override
  void initState() {
    super.initState();
    setJiffyLocale();
    _schoolTimetable = getSchoolTimetable();
  }

  Future<List<Event>> getSchoolTimetable() async {
    List<Event> mergedEvents = [];
    var results = await Future.wait([
      Api.getStudentSchedule(week: Jiffy().week, studentId: '203610'),
      Api.getStudentSchedule(week: Jiffy().week + 1, studentId: '203610'),
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
            List<DateTime> eventsDate = events
                .map((e) =>
                    Jiffy(DateTime.parse(e.dtstart).toString(), "yyyy-MM-dd")
                        .local())
                .toSet()
                .toList();

            newsListSliver = SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  List<Event> dateEvents = events
                      .where((e) => Jiffy(DateTime.parse(e.dtstart).toString(),
                              "yyyy-MM-dd")
                          .isSame(eventsDate[index]))
                      .toList();
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      date(dateTime: Jiffy(eventsDate[index]).local()),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            for (var event in dateEvents)
                              card(
                                  title: event.description.spe,
                                  subtitle:
                                      '${formatHour(event.dtstart)} - ${formatHour(event.dtend)}'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            newsListSliver =
                SliverToBoxAdapter(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: <Widget>[sliverAppBar(), newsListSliver],
          );
        },
      ),
    );
  }

  String formatHour(String date) {
    Jiffy jiffy = new Jiffy(DateTime.parse(date))..local();
    return jiffy.format('HH:mm');
  }
}

SliverAppBar sliverAppBar() => SliverAppBar(
      expandedHeight: 200.0,
      snap: false,
      floating: false,
      pinned: false,
      flexibleSpace: Container(
        child: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Center(
            child: Text('Prochain cours dans 1 heure'),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(4281953020),
              Color(4280895743),
            ],
          ),
        ),
      ),
    );

Widget date({@required DateTime dateTime}) {
  return Container(
    width: 60,
    padding: EdgeInsets.only(top: 5),
    // color: Colors.red,
    child: Column(
      children: <Widget>[
        Text(
          Jiffy(dateTime).E.toUpperCase(),
          style: TextStyle(color: Colors.black26, fontSize: 12),
        ),
        Text(
          Jiffy(dateTime).date.toString(),
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: (Jiffy(dateTime).yMMMMd == Jiffy(DateTime.now()).yMMMMd
                ? Color(4281953020)
                : Colors.black87),
          ),
        ),
      ],
    ),
  );
}

Widget card({@required String title, String subtitle}) {
  return Container(
    margin: EdgeInsets.all(5),
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
    ),
  );
}

/*
Container(
      padding: EdgeInsets.all(10),
      color: Color.fromRGBO(244, 244, 247, 1),
      child: FutureBuilder(
        future: _schoolTimetable,
        builder: (context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.hasData) {
            List<Event> events = snapshot.data;
            events.sort((a, b) => a.dtstart.compareTo(b.dtstart));

            List<DateTime> eventsDate = events
                .map((e) =>
                    Jiffy(DateTime.parse(e.dtstart).toString(), "yyyy-MM-dd")
                        .local())
                .toSet()
                .toList();
            return ScrollablePositionedList.builder(
              itemCount: eventsDate.length,
              itemScrollController: itemScrollController,
              itemBuilder: (context, index) {
                List<Event> dateEvents = events
                    .where((e) => Jiffy(
                            DateTime.parse(e.dtstart).toString(), "yyyy-MM-dd")
                        .isSame(eventsDate[index]))
                    .toList();
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    date(dateTime: Jiffy(eventsDate[index]).local()),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          for (var event in dateEvents)
                            card(
                                title: event.description.spe,
                                subtitle:
                                    '${formatHour(event.dtstart)} - ${formatHour(event.dtend)}'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
 */
