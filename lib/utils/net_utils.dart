import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

Dio dio = new Dio();

class NetUtils {
  static Future get(String baseUrl) async {
    Response response;
    Dio dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(dir: appDocPath + "/.cookies/");
    dio.interceptors.add(CookieManager(cookieJar));

    response = await dio.get(baseUrl);

    return response;
  }

  static Future post(String baseUrl, FormData data) async {
    Response response;
    Dio dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(dir: appDocPath + "/.cookies/");
    dio.interceptors.add(CookieManager(cookieJar));

    response = await dio.post(baseUrl, data: data);

    return response;
  }
}
