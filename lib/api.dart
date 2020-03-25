import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:edt_lr/ical.dart';
import 'package:edt_lr/models/event.dart';
import 'package:edt_lr/utils/net_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static Future<Response> signIn(String username, String password) async {
    FormData formData = new FormData.fromMap(
        {'modeconnect': 'connect', 'util': username, 'acct_pass': password});

    return await NetUtils.post(
        'https://www.gpu-lr.fr/sat/index.php?page_param=accueilsatellys.php',
        formData);
  }

  static Future getStudentGpuPage() async {
    return await NetUtils.get(
        'https://www.gpu-lr.fr/gpu/index.php?page_param=fpetudiant.php');
  }

  static Future<List<Event>> getStudentSchedule(
      {int week, String studentId}) async {
    Response response = await NetUtils.get(
        'https://www.gpu-lr.fr/gpu/gpu2vcs.php?semaine=$week&prof_etu=ETU&etudiant=$studentId');

    // Use the compute function to run parseEvents in a separate isolate.
    return compute(parseEvents, response.data.toString());
  }

  // A function that converts a response body into a List<Event>.
  static List<Event> parseEvents(String responseBody) {
    final parsed =
        json.decode(ICAL.icsToJson(responseBody)).cast<Map<String, dynamic>>();
    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }

  static Future logout() async {
    // return await NetUtils.get(
    //    'https://www.gpu-lr.fr/sat/index.php?page_param=deconnect.php');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(dir: appDocPath + "/.cookies/");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear().then((_) => cookieJar.deleteAll());
  }

  static Future isLoggedIn() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(dir: appDocPath + "/.cookies/");
    List<Cookie> cookies = cookieJar
        .loadForRequest(Uri.parse('https://www.gpu-lr.fr/gpu/index.php'));
    print(cookies);
    return cookies.length > 1;
  }
}
