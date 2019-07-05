import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  String _brand;
  String _model;
  String _fuel;
  String _year;
  String _fipeCode;
  String _valor;
  String _mesRef;
  Function _setFavoriteCar;
  Function _is_favorite_car;


  CardComponent(
      this._brand, this._model, this._fuel, this._year, this._fipeCode, this._valor, this._mesRef, this._setFavoriteCar, this._is_favorite_car);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Colors.black.withOpacity(.2),
              offset: Offset(3.0, 3.0),
            ),
          ],
          border: Border.all(color: Colors.black12, width: 1),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Text(
              _brand,
              style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Text(
                _model,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              color: Colors.black26),
                          child: Text(
                            _fuel,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                  Expanded(
                      child: Center(
                        child: Text(
                          _year,
                          style: TextStyle(fontSize: 15, color: Colors.black45),
                        ),
                      )),
                  Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "FIPE: $_fipeCode",
                          style: TextStyle(fontSize: 15, color: Colors.black45),
                        ),
                      )),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      _valor,
                      style:
                      TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    Text("Mês Ref: $_mesRef",
                        style: TextStyle(fontSize: 14, color: Colors.black45)),
                  ],
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(_is_favorite_car() ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      _setFavoriteCar();
                    },
                    color: Colors.red,
                    iconSize: 36.0,
                  ),
                )
              ],
            ),
          ],
        ),
    );
  }
}
