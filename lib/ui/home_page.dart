import 'package:flutter/material.dart';
import 'package:jogobichoresultados/helpers/helper_lista_bichos.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables
  int _indexBottom = 1;
  HelperListaBichos helper;

  @override
  void initState() {
    super.initState();
    helper = HelperListaBichos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Resultados Jogo do Bicho",
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
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 250.0,
              color: _indexBottom == 0 ? Colors.red : Colors.yellow,
            ),
            Divider(),
            RaisedButton(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "LER ARQUIVO",
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              onPressed: () async {
                if (helper != null) {
                  var mapList = helper.getMap();
                  print("Comprimento da LISTA: ${mapList.length}");
                  print(mapList[1]);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
