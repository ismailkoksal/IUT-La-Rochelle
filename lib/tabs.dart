import 'package:edt_lr/api.dart';
import 'package:edt_lr/pages/chat.dart';
import 'package:edt_lr/pages/school_schedule.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _firstName;

  Future<void> _getStudentDetails() async {
    _firstName =
        _prefs.then((SharedPreferences prefs) => prefs.getString('firstName'));
  }

  @override
  void initState() {
    super.initState();
    _getStudentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar(context),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              SchoolSchedulePage(),
              ChatPage(),
              /* FutureBuilder(
              future: _firstName,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  String firstName = snapshot.data;
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Bonjour,',
                          style: TextStyle(fontSize: 28.0),
                        ),
                        Text(
                          firstName.capitalize(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            ),*/
            ],
          ),
        ),
        bottomNavigationBar: tabBar(),
      ),
    );
  }
}

PreferredSizeWidget appBar(BuildContext context) {
  return AppBar(
    title: Text(
      'Emploi du temps',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () => Api.logout().then(
          (value) => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
    ],
    flexibleSpace: Container(
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
}

Widget tabBar() {
  return TabBar(
    tabs: [
      Tab(
        text: 'Emploi du temps',
      ),
      Tab(
        text: 'Chat',
      ),
    ],
    labelColor: Color.fromRGBO(39, 125, 202, 1),
    indicatorColor: Color.fromRGBO(39, 125, 202, 1),
    unselectedLabelColor: Color.fromRGBO(39, 125, 202, 0.5),
  );
}

Widget customScrollView() {
  return CustomScrollView(
    slivers: <Widget>[
      SliverAppBar(
        title: Text(('Title')),
      )
    ],
  );
}
