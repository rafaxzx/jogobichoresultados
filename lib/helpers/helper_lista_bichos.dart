import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class HelperListAnimals {
  Future<Map<String, dynamic>> getMapAnimals() async {
    var jsonString = await rootBundle.loadString('assets/bichos.json');
    var result = jsonDecode(jsonString);
    return result;
  }

  int getGroupOfANumber(int number) {
    int mod = number % 4;
    double quocient = number / 4;

    print("mod: $mod, quociente: $quocient");
    if (mod == 0) {
      return quocient.truncate();
    } else {
      return quocient.truncate() + 1;
    }
  }

  List<int> getNumbersByGroup(int group) {
    group *= 4;
    return [group - 3, group - 2, group - 1, group];
  }
}
