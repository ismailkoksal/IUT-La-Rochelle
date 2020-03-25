import 'package:edt_lr/api.dart';
import 'package:edt_lr/models/event.dart';
import 'package:edt_lr/widgets/course_item.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolSchedulePage extends StatefulWidget {
  @override
  _SchoolSchedulePageState createState() => _SchoolSchedulePageState();
}

class _SchoolSchedulePageState extends State<SchoolSchedulePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<Event>> _futureSchoolSchedule;

  @override
  void initState() {
    super.initState();
    getStudentSchedule();
  }

  Future<void> getStudentSchedule() async {
    _futureSchoolSchedule = _prefs.then((SharedPreferences prefs) {
      String studentId = prefs.getString('studentId');
      return Api.getStudentSchedule(week: 13, studentId: studentId);
    });
  }

  String formatHour(String date) {
    Jiffy jiffy = new Jiffy(DateTime.parse(date))..local();
    return jiffy.format('HH:mm');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: FutureBuilder<List<Event>>(
        future: _futureSchoolSchedule,
        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Event event = snapshot.data[index];
                return Column(
                  children: <Widget>[
                    SizedBox(height: 15),
                    CourseItem(
                      uid: event.uid,
                      name: event.description.spe,
                      prof: event.description.prof,
                      location: event.location,
                      startHour: event.dtstart,
                      endHour: event.dtend,
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
  }
}
