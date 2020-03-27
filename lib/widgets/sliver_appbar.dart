import 'package:edt_lr/services/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes.dart';

class CustomSliverAppBar extends StatefulWidget {
  @override
  _CustomSliverAppBarState createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  Future<String> _studentName;

  @override
  void initState() {
    super.initState();
    _studentName = getStudentName();
  }

  Future<String> getStudentName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('studentName');
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0),
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(4278241023),
              Color(4278219519),
            ],
          ),
        ),
        child: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Container(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () => print('open drawer'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FutureBuilder(
                              future: _studentName,
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  );
                                }

                                return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.white),
                        onPressed: () => Api.logout().then(
                          (value) => Navigator.pushReplacementNamed(
                              context, Routes.login),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
