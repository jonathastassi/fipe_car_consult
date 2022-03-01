import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final String brand;
  final String model;
  final String fuel;
  final String year;
  final String fipeCode;
  final String value;
  final String? mesRef;
  final Function setFavoriteCar;
  final Function isFavoriteCar;

  const AppCard({
    Key? key,
    required this.brand,
    required this.model,
    required this.fuel,
    required this.year,
    required this.fipeCode,
    required this.value,
    required this.mesRef,
    required this.setFavoriteCar,
    required this.isFavoriteCar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Colors.black.withOpacity(.2),
            offset: const Offset(
              3.0,
              3.0,
            ),
          ),
        ],
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Text(
            brand,
            style: const TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 12.0,
            ),
            child: Text(
              model,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black45,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 6.0,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                        color: Colors.black26,
                      ),
                      child: Text(
                        fuel,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      year,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "FIPE: $fipeCode",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Mês Ref: $mesRef",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(isFavoriteCar()
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    setFavoriteCar();
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
