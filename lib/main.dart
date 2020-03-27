import 'package:edt_lr/pages/login.dart';
import 'package:edt_lr/pages/school_timetable.dart';
import 'package:edt_lr/routes.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

void main() async {
  await Jiffy.locale("fr");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => LoginPage(),
        Routes.timetable: (context) => SchoolTimetablePage(),
      },
    );
  }
}
