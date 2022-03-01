import 'dart:convert';

import 'package:fipe_car_consult/src/features/favorite_cars/presenter/widgets/favorite_cars_drawer.dart';
import 'package:fipe_car_consult/src/features/home/presenter/widgets/app_card.dart';
import 'package:fipe_car_consult/src/features/home/presenter/widgets/app_loading_line.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as Http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _brands = [];
  List _models = [];
  List _years = [];

  List favoriteList = [];

  late Map<String, dynamic> _lastRemoved;
  late int _lastRemovedIndex;

  Map<String, dynamic> _dataCard = <String, dynamic>{};

  bool loadingBrand = false;
  bool loadingModel = false;
  bool loadingYear = false;
  bool _showCard = false;
  bool loadingCard = false;

  String _selectedValueBrand = '';
  String _selectedValueModel = '';
  String _selectedValueYear = '';

  Future<List> _getBrands() async {
    Http.Response response = await Http.get(
        Uri.parse("https://parallelum.com.br/fipe/api/v1/carros/marcas"));

    List _data = [];
    _data = json.decode(response.body);

    dynamic _firstItem = <String, dynamic>{};
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
        _models = [];
        _years = [];
        _showCard = false;
      });

      return [];
    }

    setState(() {
      _selectedValueBrand = brandValue;
      _selectedValueModel = "";
      _selectedValueYear = "";
      _models = [];
      _years = [];
      loadingModel = true;
      _showCard = false;
    });

    Http.Response response = await Http.get(Uri.parse(
        "https://parallelum.com.br/fipe/api/v1/carros/marcas/$_selectedValueBrand/modelos"));

    List _data = [];
    _data = json.decode(response.body)["modelos"];

    dynamic _firstItem = <String, dynamic>{};
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
        _years = [];
        _showCard = false;
      });

      return [];
    }

    setState(() {
      _selectedValueModel = modelValue;
      _selectedValueYear = "";
      _years = [];
      loadingYear = true;
      _showCard = false;
    });

    Http.Response response = await Http.get(Uri.parse(
        "https://parallelum.com.br/fipe/api/v1/carros/marcas/$_selectedValueBrand/modelos/$_selectedValueModel/anos"));

    List _data = [];
    _data = json.decode(response.body);

    dynamic _firstItem = <String, dynamic>{};
    _firstItem['codigo'] = '';
    _firstItem['nome'] = 'Selecione o ano...';
    _data.insert(0, _firstItem);

    return _data;
  }

  Future<Map<String, dynamic>> _getDataCard(String yearValue) async {
    setState(() {
      _selectedValueYear = yearValue;
      loadingCard = true;
    });

    if (yearValue == "") {
      return <String, dynamic>{};
    }

    Http.Response response = await Http.get(Uri.parse(
        "https://parallelum.com.br/fipe/api/v1/carros/marcas/$_selectedValueBrand/modelos/$_selectedValueModel/anos/$_selectedValueYear"));

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

  Future<String?> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  bool _isFavoriteCar() {
    List _hasFavorite = favoriteList
        .where((i) =>
            i['brandSelected'] == _selectedValueBrand &&
            i['modelSelected'] == _selectedValueModel &&
            i['yearSelected'] == _selectedValueYear)
        .toList();

    if (_hasFavorite.isNotEmpty) {
      return true;
    }
    return false;
  }

  void _setFavoriteCar() {
    List _hasFavorite = favoriteList
        .where((i) =>
            i['brandSelected'] == _selectedValueBrand &&
            i['modelSelected'] == _selectedValueModel &&
            i['yearSelected'] == _selectedValueYear)
        .toList();

    if (_hasFavorite.isNotEmpty) {
      setState(() {
        favoriteList.removeWhere((i) =>
            i['brandSelected'] == _selectedValueBrand &&
            i['modelSelected'] == _selectedValueModel &&
            i['yearSelected'] == _selectedValueYear);
        _saveData();
      });
    } else {
      setState(() {
        Map<String, dynamic> favorite = <String, dynamic>{};
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
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                favoriteList.insert(_lastRemovedIndex, _lastRemoved);
                _saveData();
              });
            }),
      );

      Scaffold.of(context).showSnackBar(snackbar);
    });
  }

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      if (data != null) {
        setState(() {
          favoriteList = json.decode(data);
        });
      }
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

  Widget dropDownLineItem(bool loadingFlag, String selectedValue, List listData,
      Function(String?)? onChanged) {
    if (!loadingFlag) {
      return DropdownButton<String>(
        isExpanded: true,
        value: selectedValue,
        onChanged: onChanged,
        items: listData.map((item) {
          return DropdownMenuItem(
            child: Text(item['nome']),
            value: item['codigo'].toString(),
          );
        }).toList(),
      );
    }
    return const AppLoadingLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FIPE Car"),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: FavoriteCarsDrawer(
        favoriteList: favoriteList,
        removeFavorite: _removeFavorite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                  ),
                  child: const Text(
                    "Pesquise o carro desejado",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text("Selecione a marca"),
                      dropDownLineItem(
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
                (_models.isEmpty &&
                        _selectedValueModel == "" &&
                        loadingModel == false
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text("Selecione o modelo"),
                            dropDownLineItem(
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
                (_years.isEmpty &&
                        _selectedValueYear == "" &&
                        loadingYear == false
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text("Selecione o ano"),
                            dropDownLineItem(
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
            loadingCard
                ? const AppLoadingLine()
                : _showCard
                    ? AppCard(
                        brand: _dataCard['Marca'] ?? "",
                        model: _dataCard['Modelo'] ?? "",
                        fuel: _dataCard['Combustivel'] ?? "",
                        year: _dataCard['AnoModelo'].toString(),
                        fipeCode: _dataCard['CodigoFipe'] ?? "",
                        value: _dataCard['Valor'] ?? "",
                        mesRef: _dataCard['MesReferencia'] ?? "",
                        isFavoriteCar: _isFavoriteCar,
                        setFavoriteCar: _setFavoriteCar,
                      )
                    : Container()
          ],
        ),
      ),
    );
  }
}
