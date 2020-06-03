import 'package:flutter/material.dart';
import 'package:jogobichoresultados/helpers/helper_get_data.dart';
import 'package:jogobichoresultados/helpers/helper_lista_bichos.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Controllers
  final _pageController = PageController(initialPage: 0);

  //Variables
  var _snapshotAnimals = Map<String, dynamic>();
  String _defaultTitleBar = 'Jogo do Bicho';
  String _titleBar = 'Jogo do Bicho';
  int _indexBottom = 0;
  List listPTM, listPT, listPTV, listPTN, listCOR;
  var mapAnimals = Map<String, dynamic>();
  var _options = ['PTM', 'PT', 'PTV', 'PTN', 'Corujinha'];
  int _lengthMap;
  HelperListaBichos helperList = HelperListaBichos();
  HelperGetData helperGetData = HelperGetData();

  //Função chamada na abertuda do APP
  @override
  void initState() {
    super.initState();
//    _getDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Resultado $_titleBar",
          style: TextStyle(fontSize: 30.0),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
//          debugPrint('VALOR DO INDEX CHAMADO: $index');
          setState(() {
            if (_indexBottom == 0) _titleBar = _defaultTitleBar;
            if (_indexBottom == 1) _pageController.jumpToPage(0);
            _indexBottom = index;
          });
        },
        currentIndex: _indexBottom,
        elevation: 5.0,
        //Opções da barra inferior
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
              Icons.attach_money,
              size: 30.0,
            ),
            title: Text(
              "Resultados",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
        ],
      ),
      //Verificação de qual 'body' será chamado de acordo com bottom selecionado
      body: _indexBottom == 0
          ? _getFutureBuilderListAnimals()
          //verificação se as listas de resultados carregaram
          : FutureBuilder(
              future: helperGetData.getListOfResultsFromURL(
                  "https://www.ojogodobicho.com/deu_no_poste.htm"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PageView(
                    onPageChanged: (page) {
                      setState(() {
                        if (page != 0) _titleBar = _options[page - 1];
                        if (page == 0) _titleBar = _defaultTitleBar;
                      });
                    },
                    controller: _pageController,
                    children: <Widget>[
                      //Page -> 0
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                              width: 200,
                              color: Colors.lightBlue,
                              child: Text(
                                'Resultado:\n${snapshot.data['DATE']}',
                                style: _styleText,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            //Lista de botões para avanço direto
                            _getButtonResult('PTM', 1),
                            _getButtonResult('PT', 2),
                            _getButtonResult('PTV', 3),
                            _getButtonResult('PTN', 4),
                            _getButtonResult('CORUJINHA', 5),
                          ],
                        ),
                      ),
                      //Page -> 1
                      _getFutureBuilderListResults(snapshot.data['PTM']),
                      //Page -> 2
                      _getFutureBuilderListResults(snapshot.data['PT']),
                      //Page -> 3
                      _getFutureBuilderListResults(snapshot.data['PTV']),
                      //Page -> 4
                      _getFutureBuilderListResults(snapshot.data['PTN']),
                      //Page -> 5
                      _getFutureBuilderListResults(snapshot.data['COR']),
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
                    ),
                  );
                } else {
                  return Center(
                    child: IconButton(
                        iconSize: 50.0,
                        icon: Icon(
                          Icons.refresh,
                        ),
                        onPressed: () {
                          setState(() {});
                        }),
                  );
                }
              }),
    );
  }

  //Exibe a lista dos animais obtidos nos assets
  Widget _getFutureBuilderListAnimals() {
    return FutureBuilder(
      future: helperList.getMapAnimals(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          _lengthMap = snapshot.data.length;
          _snapshotAnimals.addAll(snapshot.data);
          return ListView.builder(
            itemCount: _lengthMap,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                elevation: 10.0,
                color: Colors.lightBlue,
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
                          Image.asset(
                            'images/${snapshot.data[(index + 1).toString()]}.png',
                            scale: 1.0,
                          ),
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
                      Divider(
                        color: Colors.lightBlue,
                      ),
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
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
          ));
        } else {
          return Center(
            child: IconButton(
                iconSize: 50.0,
                icon: Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  setState(() {});
                }),
          );
        }
      },
    );
  }

  //Exibe lista dos resultados passados
  Widget _getFutureBuilderListResults(List list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          var _animalGroup = int.parse(list[index].toString().split('-')[1]);
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            elevation: 10.0,
            color: Colors.lightBlue,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 25.0,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "${index + 1}º prêmio ${list[index].toString()}",
                        style: _styleText,
                      ),
                      Image.asset(
                          'images/${_snapshotAnimals[_animalGroup.toString()]}.png')
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Botão para ir direto ao resultado especifico
  Widget _getButtonResult(String title, int page) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(20.0),
      child: RaisedButton(
          color: Colors.lightBlue,
          elevation: 5.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            title,
            style: _styleText,
          ),
          onPressed: () {
            _pageController.jumpToPage(page);
          }),
    );
  }

  //Estilo de texto
  TextStyle _styleText = TextStyle(
      color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold);

  //Função que possivelmente usarei para criar um cache dos resultados
  void _getDataAsync() {
    helperGetData
        .getListOfResultsFromURL(
            "https://www.ojogodobicho.com/deu_no_poste.htm")
        .then((value) {
      listPTM = value["PTM"];
      listPT = value['PT'];
      listPTV = value['PTV'];
      listPTN = value['PTN'];
      listCOR = value['COR'];
    });
  }
}
