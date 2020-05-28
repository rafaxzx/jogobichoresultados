import 'package:html/parser.dart' show parse;
//import 'package:html/dom.dart';
import 'package:http/http.dart';

class HelperGetData {
  getDocumentFromURL(String url) async {
    Map<String, dynamic> _return = Map();
    var listPTM = List();
    var listPT = List();
    var listPTV = List();
    var listPTN = List();
    var listCOR = List();
    var response = await get(url);
    String result = response.body.toString();
    var document = parse(result);
    var tbody = document.getElementsByTagName("tbody");
    for (int col = 0; col < 6; col++) {
      for (int line = 0; line < 7; line++) {
        if (col == 1) listPTM.add(tbody[0].children[line].children[col].text);
        if (col == 2) listPT.add(tbody[0].children[line].children[col].text);
        if (col == 3) listPTV.add(tbody[0].children[line].children[col].text);
        if (col == 4) listPTN.add(tbody[0].children[line].children[col].text);
        if (col == 5) listCOR.add(tbody[0].children[line].children[col].text);
      }
    }
    _return["PTM"] = listPTM;
    _return["PT"] = listPT;
    _return["PTV"] = listPTV;
    _return["PTN"] = listPTN;
    _return["COR"] = listCOR;

    return _return;

    //DEBUG das LISTAS
//    print(listPTM);
//    print(listPT);
//    print(listPTV);
//    print(listPTN);
//    print(listCOR);
  }
}
