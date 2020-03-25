import 'package:edt_lr/api.dart';
import 'package:edt_lr/models/event.dart';
import 'package:edt_lr/widgets/course_item.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class EdtPage extends StatefulWidget {
  @override
  _EdtPageState createState() => _EdtPageState();
}

class _EdtPageState extends State<EdtPage> {
  Future<List<Event>> futureEdt;

  @override
  void initState() {
    super.initState();
    futureEdt = Api.getStudentSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: futureEdt,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    CourseItem(
                      name: snapshot.data[index]['summary'],
                      prof: snapshot.data[index]['location'],
                      startHour: formatHour(snapshot.data[index]['dtstart']),
                      endHour: formatHour(snapshot.data[index]['dtend']),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

String formatHour(String date) {
  Jiffy jiffy = new Jiffy(DateTime.parse(date))..local();
  return jiffy.format('HH:mm');
}

String getProf(String prof) {
  return prof.substring(
      prof.lastIndexOf('Prof:') + 5, prof.lastIndexOf(' Spe:'));
}

String getSpe(String spe) {
  return spe.substring(spe.lastIndexOf('Spe:') + 4, spe.lastIndexOf('\\Alt'));
}
