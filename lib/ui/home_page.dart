import 'package:flutter/material.dart';
import 'package:jogobichoresultados/helpers/helper_get_data.dart';
import 'package:jogobichoresultados/helpers/helper_lista_bichos.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables
  var listPTM = List();
  int _indexBottom = 0;
  int _lenthMap;
  HelperListaBichos helperList = HelperListaBichos();
  HelperGetData helperGetData = HelperGetData();

  @override
  void initState() {
    super.initState();
    helperGetData
        .getDocumentFromURL("https://www.ojogodobicho.com/deu_no_poste.htm")
        .then((value) {
      listPTM = value["PTM"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Resultado Jogo do Bicho",
          style: TextStyle(fontSize: 30.0),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _indexBottom = index;
          });
        },
        currentIndex: _indexBottom,
        elevation: 5.0,
        items: <BottomNavigationBarItem>[
          //Lista de Itens do Bottom Navigation Bar
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pets,
              size: 30.0,
            ),
            title: Text(
              "Bichos",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.plus_one,
              size: 30.0,
            ),
            title: Text(
              "Resultados",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
        ],
      ),
      body: _indexBottom == 0
          ? _getFutureBuilderList()
          : listPTM.length > 0
              ? _getFutureBuilderResults(listPTM)
              : Center(
                  child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        size: 50.0,
                      ),
                      onPressed: () {
                        setState(() {});
                      }),
                ),
    );
  }

  Widget _getFutureBuilderList() {
    return FutureBuilder(
      future: helperList.getMapAnimals(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          _lenthMap = snapshot.data.length;
          return ListView.builder(
            itemCount: _lenthMap,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                elevation: 10.0,
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 25.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            snapshot.data[(index + 1).toString()],
                            style: _styleText,
                          ),
                          Text(
                            "Grupo ${index + 1}",
                            style: _styleText,
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        "Dezenas: ${helperList.getNumbersByGroup(index + 1).toString()}",
                        style: _styleText,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  //Exibe lista dos resultados PTM
  Widget _getFutureBuilderResults(List list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            elevation: 10.0,
            color: Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 25.0,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "$index prêmio ${list[index].toString()}",
                        style: _styleText,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  TextStyle _styleText = TextStyle(
      color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold);
}
