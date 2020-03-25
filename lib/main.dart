import 'package:edt_lr/pages/chat.dart';
import 'package:edt_lr/pages/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(39, 125, 202, 1),
        appBarTheme: AppBarTheme(elevation: 0.0),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/edt': (context) => ChatPage(),
      },
    );
  }
}
