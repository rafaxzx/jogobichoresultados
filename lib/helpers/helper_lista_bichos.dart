import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class HelperListaBichos {
//  static Map<String, dynamic> mapa = Map();
  static String jsonString = "";

  HelperListaBichos() {
    rootBundle.loadString('assets/bichos.json').then((value) {
      jsonString = value;
    });
  }

  List getMap() {
    return jsonDecode(jsonString);
  }
}
