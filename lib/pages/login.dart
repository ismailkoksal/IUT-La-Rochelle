import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username, _password;

  @override
  void initState() {
    super.initState();
    Api.isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, '/edt');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(39, 125, 202, 1),
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: SafeArea(
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
      ),
    );
  }

  void signIn() {
    _formKey.currentState.save();

    Api.signIn(_username, _password).then((value) {
      if (value.data.toString().contains('CONNEXION ETABLIE')) {
        print(true);
        Api.getStudentGpuPage().then((value) {
          _saveStudentDetails(value.toString())
              .then((_) => Navigator.pushReplacementNamed(context, '/edt'));
        });
      } else {
        print(false);
      }
    });
  }

  Future<void> _saveStudentDetails(String html) async {
    final htmlDoc = parse(html);
    String student =
        htmlDoc.querySelector("input[name='etudiant']").parent.text;
    List<String> studentInfo = student.split(' ');
    String studentId = studentInfo[0];
    String lastName = studentInfo[1];
    String firstName = studentInfo[2];

    print(studentId);
    print(lastName);
    print(firstName);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('studentId', studentId);
    await prefs.setString('lastName', lastName);
    await prefs.setString('firstName', firstName);
  }
}
