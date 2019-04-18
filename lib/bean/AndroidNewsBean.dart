import 'package:flutter_app/bean/AndroidInfo.dart';
import 'dart:convert' show json;

class AndroidNewsBean {

  bool error;
  List<AndroidInfo> results;

  AndroidNewsBean.fromParams({this.error, this.results});

  factory AndroidNewsBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new AndroidNewsBean.fromJson(json.decode(jsonStr)) : new AndroidNewsBean.fromJson(jsonStr);

  AndroidNewsBean.fromJson(jsonRes) {
    error = jsonRes['error'];
    results = jsonRes['results'] == null ? null : [];

    for (var resultsItem in results == null ? [] : jsonRes['results']){
      results.add(resultsItem == null ? null : new AndroidInfo.fromJson(resultsItem));
    }
  }

  @override
  String toString() {
    return '{"error": $error,"results": $results}';
  }
}



