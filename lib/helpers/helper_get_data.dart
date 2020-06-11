import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';

class HelperGetDataFromWeb {
  Future<Map<dynamic, dynamic>> getListOfResultsFromURL(String url) async {
    var _return = Map();
    var listPTM = List();
    var listPT = List();
    var listPTV = List();
    var listPTN = List();
    var listCOR = List();
    var response = await get(url);
    String result = response.body.toString();
    var document = parse(result);
    var tbody = document.getElementsByTagName("tbody");
    var captions = document.getElementsByTagName('caption');
    var weekDay = captions[0].text.split(',')[0];
    for (int col = 0; col < 6; col++) {
      for (int line = 0; line < 7; line++) {
        //In Sunday (Domingo) the game runs in different way
        if (weekDay == 'Domingo') {
          if (col == 1) listPTM.add(tbody[0].children[line].children[col].text);
          if (col == 2) listPT.add(tbody[0].children[line].children[col].text);
        } else {
          if (col == 1) listPTM.add(tbody[0].children[line].children[col].text);
          if (col == 2) listPT.add(tbody[0].children[line].children[col].text);
          if (col == 3) listPTV.add(tbody[0].children[line].children[col].text);
          if (col == 4) listPTN.add(tbody[0].children[line].children[col].text);
          if (col == 5) listCOR.add(tbody[0].children[line].children[col].text);
        }
      }
    }
    _return["PTM"] = listPTM;
    _return["PT"] = listPT;
    _return["PTV"] = listPTV;
    _return["PTN"] = listPTN;
    _return["COR"] = listCOR;
    _return['DATE'] = captions[0].text;

    //DEBUG of lists
    print('list ptm: $listPTM');
    print('list pt: $listPT');
    print('list ptv: $listPTV');
    print('list ptn: $listPTN');
    print('list coruj: $listCOR');
    return _return;
  }
}
