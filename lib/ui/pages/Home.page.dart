import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fipe_car_consult/ui/drawer/favorite.drawer.dart';
import 'package:fipe_car_consult/ui/components/card.component.dart';
import 'package:fipe_car_consult/ui/components/loading_line.component.dart';


import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as Http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _brands = List();
  List _models = List();
  List _years = List();

  List favoriteList = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedIndex;

  Map<String, dynamic> _dataCard = Map<String, dynamic>();

  bool loadingBrand = false;
  bool loadingModel = false;
  bool loadingYear = false;
  bool _showCard = false;
  bool loadingCard = false;

  String _selectedValueBrand = '';
  String _selectedValueModel = '';
  String _selectedValueYear = '';

  Future<List> _getBrands() async {
    Http.Response response =
        await Http.get("https://parallelum.com.br/fipe/api/v1/carros/marcas");

    List _data = List();
    _data = json.decode(response.body);

    dynamic _firstItem = Map<String, dynamic>();
    _firstItem['codigo'] = '';
    _firstItem['nome'] = 'Selecione a marca...';
    _data.insert(0, _firstItem);

    return _data;
  }

  Future<List> _getModels(String brandValue) async {

    if (brandValue == "") {
      setState(() {
        _selectedValueBrand = brandValue;
        _selectedValueModel = "";
        _selectedValueYear = "";
        _models = List();
        _years = List();
        _showCard = false;
      });

      return List();
    }

    setState(() {
      _selectedValueBrand = brandValue;
      _selectedValueModel = "";
      _selectedValueYear = "";
      _models = List();
      _years = List();
      loadingModel = true;
      _showCard = false;
    });

    Http.Response response =
    await Http.get("https://parallelum.com.br/fipe/api/v1/carros/marcas/$_selectedValueBrand/modelos");

    List _data = List();
    _data = json.decode(response.body)["modelos"];

    dynamic _firstItem = Map<String, dynamic>();
    _firstItem['codigo'] = '';
    _firstItem['nome'] = 'Selecione o modelo...';
    _data.insert(0, _firstItem);

    return _data;
  }

  Future<List> _getYears(String modelValue) async {

    if (modelValue == "") {
      setState(() {
        _selectedValueModel = modelValue;
        _selectedValueYear = "";
        _years = List();
        _showCard = false;
      });

      return List();
    }

    setState(() {
      _selectedValueModel = modelValue;
      _selectedValueYear = "";
      _years = List();
      loadingYear = true;
      _showCard = false;
    });

    Http.Response response =
    await Http.get("https://parallelum.com.br/fipe/api/v1/carros/marcas/$_selectedValueBrand/modelos/$_selectedValueModel/anos");

    List _data = List();
    _data = json.decode(response.body);

    dynamic _firstItem = Map<String, dynamic>();
    _firstItem['codigo'] = '';
    _firstItem['nome'] = 'Selecione o ano...';
    _data.insert(0, _firstItem);

    return _data;
  }

  Future<Map> _getDataCard(String yearValue) async {

    setState(() {
      _selectedValueYear = yearValue;
      loadingCard = true;
    });

    if (yearValue == "") {
      return Map<String, dynamic>();
    }

    Http.Response response =
        await Http.get("https://parallelum.com.br/fipe/api/v1/carros/marcas/$_selectedValueBrand/modelos/$_selectedValueModel/anos/$_selectedValueYear");

    return json.decode(response.body);
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data-favorite-cars.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(favoriteList);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
  
  bool _is_favorite_car() {
    List _hasFavorite = favoriteList.where(
            (i) => i['brandSelected'] == _selectedValueBrand &&
            i['modelSelected'] == _selectedValueModel &&
            i['yearSelected'] == _selectedValueYear
    ).toList();

    if (_hasFavorite.length > 0) {
      return true;
    }
    return false;
  }

  void _setFavoriteCar() {

    List _hasFavorite = favoriteList.where(
            (i) => i['brandSelected'] == _selectedValueBrand &&
                i['modelSelected'] == _selectedValueModel &&
                i['yearSelected'] == _selectedValueYear
    ).toList();

    if (_hasFavorite.length > 0) {
      setState(() {
        favoriteList.removeWhere((i) =>
        i['brandSelected'] == _selectedValueBrand &&
            i['modelSelected'] == _selectedValueModel &&
            i['yearSelected'] == _selectedValueYear);
        _saveData();
      });
    }
    else {
      setState(() {
        Map<String, dynamic> favorite = Map<String, dynamic>();
        favorite['Marca'] = _dataCard['Marca'];
        favorite['Modelo'] = _dataCard['Modelo'];
        favorite['Combustivel'] = _dataCard['Combustivel'];
        favorite['AnoModelo'] = _dataCard['AnoModelo'];
        favorite['CodigoFipe'] = _dataCard['CodigoFipe'];
        favorite['Valor'] = _dataCard['Valor'];
        favorite['MesReferencia'] = _dataCard['MesReferencia'];
        favorite['brandSelected'] = _selectedValueBrand;
        favorite['modelSelected'] = _selectedValueModel;
        favorite['yearSelected'] = _selectedValueYear;
        favoriteList.add(favorite);
        _saveData();
      });
    }
  }

  void _removeFavorite(int index, BuildContext context) {
    setState(() {
      _lastRemoved = Map.from(favoriteList[index]);
      _lastRemovedIndex = index;
      favoriteList.removeAt(index);
      _saveData();

      Navigator.pop(context);

      final snackbar = SnackBar(
        content: Text("${_lastRemoved["Modelo"]} removido!"),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                favoriteList.insert(_lastRemovedIndex, _lastRemoved);
                _saveData();
              });
            }
        ),
      );

      Scaffold.of(context).showSnackBar(snackbar);
    });
  }

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        favoriteList = json.decode(data);
      });
    });

    setState(() {
      loadingBrand = true;
    });
    _getBrands().then((data) {
      setState(() {
        loadingBrand = false;
        _brands = data;
      });
    });
  }

  Widget DropDownLineItem(bool loadingFlag, String selectedValue, List listData,
      Function onChanged) {
    if (!loadingFlag) {
      return DropdownButton<String>(
        isExpanded: true,
        value: selectedValue,
        onChanged: onChanged,
        items: listData.map((item) {
          return DropdownMenuItem(
            child: new Text(item['nome']),
            value: item['codigo'].toString(),
          );
        }).toList(),
      );
    }
    return LoadingLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FIPE Car"),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
          ),
        ],
      ),
      endDrawer: FavoriteDrawer(favoriteList, _removeFavorite),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 18.0,
                      ),
                      child: Text(
                        "Pesquise o carro desejado",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Selecione a marca"),
                          DropDownLineItem(
                              loadingBrand, _selectedValueBrand, _brands,
                              (newValue) {
                                _getModels(newValue.toString()).then((data) {
                                  setState(() {
                                    loadingModel = false;
                                    _models = data;
                                  });
                            });
                          }),
                        ],
                      ),
                    ),
                    (_models.length == 0 && _selectedValueModel == "" && loadingModel == false ? Container() : Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Selecione o modelo"),
                          DropDownLineItem(
                              loadingModel, _selectedValueModel, _models,
                                (newValue) {
                                  _getYears(newValue.toString()).then((data) {
                                    setState(() {
                                      loadingYear = false;
                                      _years = data;
                                    });
                                  });
                              }),
                        ],
                      ),
                    )),
                    (_years.length == 0 && _selectedValueYear == "" && loadingYear == false ? Container() : Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Selecione o ano"),
                          DropDownLineItem(
                              loadingYear, _selectedValueYear, _years,
                                  (newValue) {
                                _getDataCard(newValue.toString()).then((data) {
                                  _dataCard = data;

                                  setState(() {
                                    if (_dataCard.containsKey('Marca') &&
                                        _dataCard['Marca'] != '') {
                                      _showCard = true;
                                      loadingCard = false;
                                    }
                                  });

                                });
                              }),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              loadingCard ? LoadingLine() :  _showCard ? CardComponent(
                _dataCard['Marca'] ?? "",
                _dataCard['Modelo'] ?? "",
                _dataCard['Combustivel'] ?? "",
                _dataCard['AnoModelo'].toString() ?? "",
                _dataCard['CodigoFipe'] ?? "",
                _dataCard['Valor'] ?? "",
                _dataCard['MesReferencia'] ?? "",
                _setFavoriteCar,
                _is_favorite_car,
              ) : Container()
            ],
          )),
    );
  }
}
