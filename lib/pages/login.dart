import 'package:edt_lr/routes.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;

  @override
  void initState() {
    super.initState();
    Api.isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, Routes.timetable);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  onSaved: (text) => _username = text,
                  decoration: InputDecoration(
                    labelText: 'Identifiant',
                  ),
                ),
                TextFormField(
                  onSaved: (text) => _password = text,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                  ),
                ),
                RaisedButton(
                  onPressed: signIn,
                  child: Text('Se connecter'),
                )
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(4278241023),
              Color(4278219519),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() {
    _formKey.currentState.save();

    Api.signIn(_username, _password).then((value) {
      if (value.data.toString().contains('CONNEXION ETABLIE')) {
        print(true);
        Api.getStudentGpuPage().then((value) {
          _saveStudentDetails(value.toString()).then(
              (_) => Navigator.pushReplacementNamed(context, Routes.timetable));
        });
      } else {
        final snackBar = SnackBar(
            content: Text('Identifiant ou mot de passe incorrent'),
            backgroundColor: Colors.redAccent);
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  Future<void> _saveStudentDetails(String html) async {
    final htmlDoc = parse(html);
    String student =
        htmlDoc.querySelector("input[name='etudiant']").parent.text;
    List<String> studentInfo = student.split(' ');
    String studentId = studentInfo[0];
    String studentName = studentInfo.sublist(1).join(' ');

    print(studentId);
    print(studentName);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('studentId', studentId);
    await prefs.setString('studentName', studentName);
  }
}
